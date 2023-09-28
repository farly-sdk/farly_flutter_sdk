import Flutter
import UIKit
import Farly
import AppTrackingTransparency

enum FarlyError: Error {
    case runtimeError(String)
}
extension FarlyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .runtimeError(let msg):
            return msg
        }
    }
}

public class FarlyFlutterSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "farly_flutter_sdk", binaryMessenger: registrar.messenger())
        let instance = FarlyFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func parseOfferwallRequest(_ info: [String: Any]) throws -> OfferWallRequest {
        guard let userId = info["userId"] as? String else {
            let error = "userId is mandatory in request"
            throw FarlyError.runtimeError(error)
        }
        let req = OfferWallRequest(userId: userId)
        req.zipCode = info["zipCode"] as? String
        req.countryCode = info["countryCode"] as? String
        req.userAge = info["userAge"] as? NSNumber
        if let gender = info["userGender"] as? String {
            switch gender {
            case "Male":
                req.userGender = .Male
            case "Female":
                req.userGender = .Female
            default:
                req.userGender = .Unknown
            }
        }
        if let userSignupDate = info["userSignupDate"] as? Double {
            req.userSignupDate = Date(timeIntervalSince1970: userSignupDate * 1000)
        }
        if let callbackParameters = info["callbackParameters"] as? [String] {
            req.callbackParameters = callbackParameters
        }
        
        return req
    }
    
    private func toJson(_ fe: FeedElement) -> [String: Any] {
        let result = [
            "id": fe.id,
            "name": fe.name,
            "devName": fe.devName,
            "link": fe.link,
            "icon": fe.icon,
            "smallDescription": fe.smallDescription,
            "smallDescriptionHTML": fe.smallDescriptionHTML,
            "actions": fe.actions.map({ action in
                return [
                    "id": action.id,
                    "amount": action.amount,
                    "text": action.text,
                    "html": action.html
                ] as [String: Any]
            })
        ] as [String: Any]
        
        return result
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "setup":
            let args = call.arguments as! [String: Any]
            guard let apiKey = args["apiKey"] as? String,
                  let publisherId = args["publisherId"] as? String else {
                result(FlutterError(code: "setup_error", message: "apiKey and publisherId are mandatory", details: nil))
                return
            }
            Farly.shared.apiKey = apiKey
            Farly.shared.publisherId = publisherId
            
            result(nil)
        case "requestAdvertisingIdAuthorization":
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    result(status == .authorized)
                }
            } else {
                // On earlier version the advertising identifier is available without a system popup.
                // We recommend you to implement your own.
                result(true)
            }
            result(nil)
        case "getHostedOfferwallUrl":
            let args = call.arguments as! [String: Any]
            do {
                let request = try parseOfferwallRequest(args)
                let url = Farly.shared.getHostedOfferwallUrl(request: request)
                result(url?.absoluteString)
            } catch let e {
                result(FlutterError(code: "get_offerwall_error", message: e.localizedDescription, details: nil))
            }
        case "showOfferwallInBrowser":
            let args = call.arguments as! [String: Any]
            do {
                let request = try parseOfferwallRequest(args)
                Farly.shared.showOfferwallInBrowser(request: request) { error in
                    if let e = error {
                        result(FlutterError(code: "show_offerwall_in_browser_error", message: e.localizedDescription, details: nil))
                    } else {
                        result(nil)
                    }
                }
            } catch let e {
                result(FlutterError(code: "show_offerwall_in_browser_error", message: e.localizedDescription, details: nil))
            }
        case "showOfferwallInWebview":
            let args = call.arguments as! [String: Any]
            do {
                let request = try parseOfferwallRequest(args)
                Farly.shared.showOfferwallInWebview(request: request) { error in
                    if let e = error {
                        result(FlutterError(code: "show_offerwall_in_webview_error", message: e.localizedDescription, details: nil))
                    } else {
                        result(nil)
                    }
                }
            } catch let e {
                result(FlutterError(code: "show_offerwall_in_webview_error", message: e.localizedDescription, details: nil))
            }
        case "getOfferwall":
            let args = call.arguments as! [String: Any]
            do {
                let request = try parseOfferwallRequest(args)
                Farly.shared.getOfferWall(request: request) { error, offers in
                    if let e = error {
                        result(FlutterError(code: "get_offerwall_error", message: e, details: nil))
                    } else {
                        guard let offers = offers else {
                            result(nil)
                            return
                        }
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: offers.map(self.toJson))
                            let jsonString = String(data: jsonData, encoding: .utf8)
                            result(jsonString)
                        } catch {
                            print("Error converting offers to JSON: \(error.localizedDescription)")
                            result(nil)
                        }
                    }
                }
            } catch let e {
                result(FlutterError(code: "get_offerwall_error", message: e.localizedDescription, details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
