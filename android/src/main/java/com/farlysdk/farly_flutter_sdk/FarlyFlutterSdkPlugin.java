package com.farlysdk.farly_flutter_sdk;

import static com.farly.farly.Farly.getInstance;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.farly.farly.Farly;
import com.farly.farly.jsonmodel.Action;
import com.farly.farly.jsonmodel.FeedItem;
import com.farly.farly.model.Gender;
import com.farly.farly.model.OfferWallRequest;
import com.farly.farly.model.OfferWallRequestBuilder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FarlyFlutterSdkPlugin
 */
public class FarlyFlutterSdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "farly_flutter_sdk");
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            if (call.method.equals("setup")) {
                Farly.getInstance().setPublisherId(call.argument("publisherId"));
                result.success("Android " + android.os.Build.VERSION.RELEASE);
            } else if (call.method.equals("getHostedOfferwallUrl")) {
                OfferWallRequest request = parseOfferwallRequest(call.arguments());
                Farly.getInstance().getHostedOfferWallUrlFromMainThread(context, request, new Farly.OfferWallUrlCompletionHandler() {
                    @Override
                    public void onComplete(String url) {
                        result.success(url);
                    }

                    @Override
                    public void onError(Exception e) {
                        result.error("farly_error", e.getMessage(), e);
                    }
                });
            } else if (call.method.equals("showOfferwallInBrowser")) {
                OfferWallRequest request = parseOfferwallRequest(call.arguments());
                getInstance().showOfferWall(this.activity, request, Farly.OfferWallPresentationMode.BROWSER);
                result.success(null);
            } else if (call.method.equals("showOfferwallInWebview")) {
                OfferWallRequest request = parseOfferwallRequest(call.arguments());
                getInstance().showOfferWall(this.activity, request, Farly.OfferWallPresentationMode.WEB_VIEW);
                result.success(null);
            } else if (call.method.equals("getOfferwall")) {
                OfferWallRequest request = parseOfferwallRequest(call.arguments());
                getInstance().getOfferWall(this.activity, request, new Farly.OfferWallRequestCompletionHandler() {
                    @Override
                    public void onComplete(List<FeedItem> feed) {
                        try {
                            JSONArray results = new JSONArray();
                            for (FeedItem feedItem : feed) {
                                results.put(toJson(feedItem));
                            }
                            result.success(results.toString());
                        } catch (Exception e) {
                            result.error("farly_error", e.getMessage(), e);
                        }
                    }

                    @Override
                    public void onError(Exception e) {
                        result.error("farly_error", e.getMessage(), e);
                    }
                });
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            result.error("farly_error", e.getMessage(), e);
        }
    }

    private JSONObject toJson(FeedItem feedItem) throws JSONException {
        JSONObject result = new JSONObject();
        result.put("id", feedItem.getId());
        result.put("name", feedItem.getName());
        result.put("devName", feedItem.getDevName());
        result.put("link", feedItem.getLink());
        result.put("icon", feedItem.getIcon());
        result.put("smallDescription", feedItem.getSmallDescription());
        result.put("smallDescriptionHTML", feedItem.getSmallDescriptionHTML());
        JSONArray actions = new JSONArray();
        for (Action action : feedItem.getActions()) {
            JSONObject actionMap = new JSONObject();
            actionMap.put("id", action.getId());
            actionMap.put("amount", action.getAmount());
            actionMap.put("text", action.getText());
            actionMap.put("html", action.getHtml());
            actions.put(actionMap);
        }
        result.put("actions", actions);
        return result;
    }

    private OfferWallRequest parseOfferwallRequest(@Nullable HashMap argumentsMap) throws Exception {
        if (argumentsMap == null) {
            throw new Exception("User id is mandatory");
        }
        // remove null values from map
        Iterator<Map.Entry<String, Object>> iterator = argumentsMap.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, Object> entry = iterator.next();
            if (entry.getValue() == null) {
                iterator.remove();
            }
        }
        JSONObject arguments = new JSONObject(argumentsMap);
        String userId = arguments.optString("userId");
        if (TextUtils.isEmpty(userId)) {
            throw new Exception("User id is mandatory");
        }

        Gender userGender = null;
        String userGenderRaw = arguments.optString("userGender");
        if ("Male".equals(userGenderRaw)) {
            userGender = Gender.MALE;
        } else if ("Female".equals(userGenderRaw)) {
            userGender = Gender.FEMALE;
        }

        Date userSignupDate = null;
        if (arguments.has("userSignupDate") && arguments.optDouble("userSignupDate") != 0) {
            double userSignupDateInMs = arguments.getDouble("userSignupDate");
            userSignupDate = new Date((long) userSignupDateInMs);
        }

        JSONArray callbackParametersRaw = arguments.optJSONArray("callbackParameters");
        String[] cps = new String[callbackParametersRaw == null ? 0 : callbackParametersRaw.length()];
        if (callbackParametersRaw != null) {
            for (int i = 0; i < callbackParametersRaw.length(); i++) {
                cps[i] = callbackParametersRaw.getString(i);
            }
        }

        return new OfferWallRequestBuilder()
                .setUserId(userId)
                .setZipCode(TextUtils.isEmpty(arguments.optString("zipCode")) ? null : arguments.getString("zipCode"))
                .setCountryCode(TextUtils.isEmpty(arguments.optString("countryCode")) ? null : arguments.getString("countryCode"))
                .setUserAge(arguments.optInt("userAge") != 0 ? arguments.getInt("userAge") : null)
                .setUserGender(userGender)
                .setUserSignupDate(userSignupDate)
                .setCallbackParameters(cps)
                .build();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }
}
