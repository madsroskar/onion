class Story {

  String id, kind, subreddit, thumbnail, title, url;



  Story.fromJsonObject(var json){
    this.id = json["data"]["id"];
    this.kind = json["kind"];
    this.subreddit = json["data"]["subreddit"];
    this.thumbnail = json["data"]["thumbnail"];
    this.title = json["data"]["title"];
    this.url = json["data"]["url"];
  }

}
