import 'dart:io';

import 'package:farly_flutter_sdk/feed_element.dart';
import 'package:farly_flutter_sdk/offerwall_request.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:farly_flutter_sdk/farly_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<FeedElement> _feedElements = [];
  final _farlyFlutterSdkPlugin = FarlyFlutterSdk();
  final _req = OfferWallRequest(
    userId: 'userId',
    userSignupDate: DateTime.now(),
    userGender: UserGender.male,
  );

  @override
  void initState() {
    super.initState();
    _farlyFlutterSdkPlugin.setup(publisherId: 'publisherId');
    if (Platform.isIOS) {
      _farlyFlutterSdkPlugin.requestAdvertisingIdAuthorization();
    }
    refreshOffers();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> refreshOffers() async {
    setState(() {
      _feedElements = [];
    });
    var feedElements = await _farlyFlutterSdkPlugin.getOfferwall(_req);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _feedElements = feedElements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _farlyFlutterSdkPlugin.showOfferwallInBrowser(_req);
                },
                child: const Text('Show offerwall in browser'),
              ),
              ElevatedButton(
                onPressed: () {
                  _farlyFlutterSdkPlugin.showOfferwallInWebview(_req);
                },
                child: const Text('Show offerwall in webview'),
              ),
              ElevatedButton(
                onPressed: () {
                  _farlyFlutterSdkPlugin
                      .getHostedOfferwallUrl(_req)
                      .then((value) {
                    Clipboard.setData(ClipboardData(text: value ?? ''));
                    print("Copied to clipboard");
                    print(value);
                  });
                },
                child: const Text('Copy offerwall url to clipboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  refreshOffers();
                },
                child: const Text('Refresh offers array'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _feedElements.length,
                  itemBuilder: (context, index) {
                    final feedElement = _feedElements[index];
                    return ListTile(
                      title: Text(feedElement.name),
                      subtitle: Text(feedElement.smallDescription ?? ''),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
