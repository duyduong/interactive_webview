import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interactive_webview/interactive_webview.dart';
import 'package:interactive_webview_example/models.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _webView = InteractiveWebView();

  var _tabs = List<TabModel>();
  var _news = List<NewsModel>();

  @override
  void initState() {
    super.initState();
    _addWebViewHandler();
  }

  _addWebViewHandler() {
    _webView.didReceiveMessage.listen(this._onReceivedMessage);

    _webView.stateChanged.listen((state) {
      if (state.type == WebViewState.didFinish) this._onFinish();
    });

    _webView.loadUrl("https://www.gosugamers.net/dota2/articles");
  }

  _onReceivedMessage(WebkitMessage message) async {
    var scriptModel = ScriptDataModel.fromJson(message.data);
    switch (scriptModel.action) {
      case "ready":
        setState(() {
          _tabs = (scriptModel.data as List)
              .map((data) => TabModel.fromJson(data))
              .toList();
        });

        if (_tabs.length > 0)
          _webView.evalJavascript("loadNews(`${_tabs[0].link}`);");
        break;

      case "loadNews":
        setState(() {
          _news = (scriptModel.data as List)
              .map((data) => NewsModel.fromJson(data))
              .toList();
        });
        break;
    }
  }

  _onFinish() async {
    // inject our script in
    final script =
        await rootBundle.loadString("assets/injection.js", cache: false);
    _webView.evalJavascript(script);
    _webView.evalJavascript("getReady();");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dota2 News"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: _TabBar(
            tabs: _tabs,
            tabIndexChanged: (model) {
              _webView.evalJavascript("loadNews(`${model.link}`);");
            },
          ),
        ),
      ),
      body: Container(
        color: Color(0xff27282C),
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: _news.length,
          itemBuilder: (context, i) => Container(
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      _news[i].thumbnail,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      _news[i].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Text(
                    _news[i].desc,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatefulWidget {
  final List<TabModel> tabs;
  final Function(TabModel) tabIndexChanged;

  const _TabBar({this.tabs, this.tabIndexChanged});

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<_TabBar> {
  TabModel _selectedTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.tabs
          .asMap()
          .map((i, tab) {
            return MapEntry(
              i,
              Flexible(
                child: _Tab(
                  isSelected: _selectedTab == null
                      ? i == 0
                      : widget.tabs.indexOf(_selectedTab) == i,
                  model: tab,
                  onPressed: () {
                    widget.tabIndexChanged(tab);

                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                ),
              ),
            );
          })
          .values
          .toList(),
    );
  }
}

class _Tab extends StatelessWidget {
  final TabModel model;
  final bool isSelected;
  final VoidCallback onPressed;

  const _Tab({this.isSelected, this.model, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        model.name.toUpperCase(),
        style: TextStyle(color: isSelected ? Colors.greenAccent : Colors.white),
      ),
    );
  }
}
