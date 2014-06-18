import 'dart:html';
import 'dart:convert';
import 'dart:collection';
import 'Story.dart';

var queue = new Queue();

void main() {
  loadData();
}

void loadData() {
  var url = "http://www.reddit.com/user/Grasa/m/onionornot.json";
  var request = HttpRequest.getString(url).then(onDataLoaded);
}

void onDataLoaded(String responseText) {
  var jsonString = responseText;
  var parsedList = JSON.decode(jsonString);
  parsedList["data"]["children"].forEach(jsonToQueue);
  Story s = queue.first;
  querySelector("#stuff").appendHtml("<h1>" + s.title + "</h1>");
}

void jsonToQueue(element){
  queue.addLast(new Story.fromJsonObject(element));
}
