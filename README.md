[![pub package](https://img.shields.io/pub/v/interactive_webview.svg)](https://pub.dartlang.org/packages/interactive_webview) 


# interactive_webview

Plugin that allow Flutter to communicate with a native WebView.

***Warning:***
This is not a display WebView. This plugin is designed to make communication between Flutter and WebView javascript. You can call a Javascript function; in the other hand, you can send messgage (`postMessage`) from Javascript to Flutter

- Android: using `JavascriptInterface`
- iOS: using `WKUserContentController`

## Getting Started

For help getting started with Flutter, view our online [documentation](http://flutter.io/).

### How it works

`InteractiveWebView` provide a singleton instance linked to one unique webview,
so you can take control of the webview from anywhere in the app. You don't need to care where is the webview. It is hidden and automatically added to the `keyWindow` (iOS) and `decorView` (Android)

#### Load HTML string with/without a base url

`InteractiveWebView` allow you to load an HTML string with different base url

```dart
final _webView = new InteractiveWebView();

_webView.loadHTML("<html><head></head><script> src='https://code.jquery.com/jquery-3.3.1.min.js'></script><body></body></html>", baseUrl: "https://www.google.com/");
````

by using base url, you can do some `hacking` work on Javascript such as embedding iframe and AJAX request from Javascript. Normally you cannot do these things if your base url is different from url you are requesting

#### Load url

```dart
final _webView = new InteractiveWebView();

_webView.loadUrl("https://www.google.com/");
````

#### Listen for events

```dart
final _webView = new InteractiveWebView();

_webView.stateChanged.listen((state) {
  // state.type: enum (didStatrt and didFinish)
  // state.url
});

_webView.didReceiveMessage.listen((message) {
  // message.name
  // message.data (should be a Map/List/String)
});
```

#### Call Javascript function

```dart
final _webView = new InteractiveWebView();

_webView.evalJavascript("<your javascript function>");
````

#### Set restricted schemes

Sometimes you want the webview to restrict from loading specific urls/schemes. You can archieve that by using:

```dart
final _webView = new InteractiveWebView();

_webView.setOptions(restrictedSchemes: <String>["google.com"]); // google.com will not allow to load in webview
```

### How to post message from Javascript

As mentioned above, you can post message from Javascript to Flutter.

Both iOS and Android defined a message handler called 'native':

- iOS: you can access this handler by using `webkit.messageHandlers.native`
- Android: you can access this handler by using `window.native`

So you only need to check which one is available in the webview, for example:

```javascript
const nativeCommunicator = typeof webkit !== 'undefined' ? webkit.messageHandlers.native : window.native;
```

Then you can post message to Flutter

***Warning:***
`postMessage` accepts String value only. So if you want to send an object/array, you need to using `JSON.stringify` to convert it to JSON string. `InteractiveWebView` will convert it back to Map/List respectively.

```javascript
// send an array data
const array = [{name: "Hello"}, 1, true, "from", "WebView!!!"];
nativeCommunicator.postMessage(JSON.stringify(array));

// send and object data
const obj = {action: "my_action", text: "Hello from WebView!!!", number: 1, bool: false};
nativeCommunicator.postMessage(JSON.stringify(obj));

// send a text data
const text = "Hello from WebView!!!";
nativeCommunicator.postMessage(text);
```

To listen to post message from Flutter, you can use `didReceiveMessage`, see [Listen for events](#listen-for-events)