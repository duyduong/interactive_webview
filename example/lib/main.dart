import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:interactive_webview/interactive_webview.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _webView = InteractiveWebView();

  @override
  void initState() {
    super.initState();
    _webViewHandler();
  }

  _webViewHandler() async {
    _webView.didReceiveMessage.listen((message) {
      print(message.data);
    });

    _webView.stateChanged.listen((state) {
      print("stateChanged ${state.type} ${state.url}");
    });

    final html = await rootBundle.loadString("assets/index.html", cache: false);
    _webView.loadHTML(html, baseUrl: "http://bilutv.net/");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new RaisedButton(onPressed: () {
            final text = "Hello from Native!!!";
            _webView.evalJavascript("test('$text')");
          }, child: Text("Send to WebView"))
        ),
      ),
    );
  }
}
