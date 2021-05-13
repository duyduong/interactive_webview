class ScriptDataModel {
  final String? action;
  final dynamic data;

  ScriptDataModel({this.action, this.data});

  ScriptDataModel.fromJson(Map map)
      : action = map['action'],
        data = map['data'];
}

class TabModel {
  final String? link;
  final String? name;

  TabModel({this.link, this.name});

  TabModel.fromJson(Map map)
      : link = map['link'],
        name = map['name'];
}

class NewsModel {
  final String? thumbnail;
  final String? title;
  final String? desc;

  NewsModel({this.thumbnail, this.title, this.desc});

  NewsModel.fromJson(Map map)
      : thumbnail = map['thumbnail'],
        title = map['title'],
        desc = map['desc'];
}
