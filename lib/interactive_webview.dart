import 'dart:async';

import 'package:flutter/services.dart';

enum WebViewState { didStart, didFinish }

class InteractiveWebView {
  final MethodChannel _channel = const MethodChannel('interactive_webview');

  final _stateChanged = new StreamController<WebViewStateChanged>.broadcast();
  final _didReceiveMessage = new StreamController<WebkitMessage>.broadcast();

  Stream<WebViewStateChanged> get stateChanged => _stateChanged.stream;
  Stream<WebkitMessage> get didReceiveMessage => _didReceiveMessage.stream;

  static InteractiveWebView _instance;

  factory InteractiveWebView() => _instance ??= new InteractiveWebView._();

  InteractiveWebView._() {
    _channel.setMethodCallHandler(_handleMessages);
  }

  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'stateChanged':
        _stateChanged.add(WebViewStateChanged.fromMap(Map<String, dynamic>.from(call.arguments)));
        break;

      case 'didReceiveMessage':
        _didReceiveMessage.add(WebkitMessage.fromMap(Map<String, dynamic>.from(call.arguments)));
        break;
    }
  }

  Future<Null> setOptions({List<String> restrictedSchemes, String webkitHandler}) async {
    final args = <String, dynamic> {
      'restrictedSchemes': restrictedSchemes ?? <String>[],
    };

    await _channel.invokeMethod('setOptions', args);
  }

  Future<Null> evalJavascript(String script) async {
    final args = <String, dynamic> {
      'script': script,
    };

    await _channel.invokeMethod('evalJavascript', args);
  }

  Future<Null> loadHTML(String html, {String baseUrl}) async {
    final args = <String, dynamic> {
      'html': html,
    };

    if (baseUrl != null)
      args['baseUrl'] = baseUrl;

    await _channel.invokeMethod('loadHTML', args);
  }

  Future<Null> loadUrl(String url) async {
    final args = <String, dynamic> {
      'url': url,
    };

    await _channel.invokeMethod('loadUrl', args);
  }
}

class WebViewStateChanged {

  final WebViewState type;
  final String url;

  WebViewStateChanged(this.type, this.url);

  factory WebViewStateChanged.fromMap(Map<String, dynamic> map) {
    WebViewState t;
    switch (map['type']) {
      case 'didStart':
        t = WebViewState.didStart;
        break;

      case 'didFinish':
        t = WebViewState.didFinish;
        break;
    }
    return WebViewStateChanged(t, map['url']);
  }
}

class WebkitMessage {

  final String name;
  final dynamic data;

  WebkitMessage(this.name, this.data);

  factory WebkitMessage.fromMap(Map<String, dynamic> map) {
    return WebkitMessage(map["name"], map["data"]);
  }
}





