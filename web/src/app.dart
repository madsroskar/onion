import 'dart:html';
import 'dart:convert';
import 'dart:collection';
import 'Story.dart';

var queue = new Queue();

const URL = "http://www.reddit.com/user/Grasa/m/onionornot.json";
const COUNT = "count=5";
const AFTER = "after=";

final storyTitleDiv = querySelector("#story-title");

void main() {
  init();
}

void init(){
  loadNewStories(onInit);
}

String generateUrl(){
  if(queue.length == 0){
    return URL;
  }else{
    Story last = queue.last;
    return URL + "?" + COUNT + "&" + AFTER + "t3_" + last.id;
  }
}

Story getNextStory() {
  if(queue.length < 3) {
    loadNewStories();
  }
  return queue.removeFirst();
}

void loadNewStories([dynamic callback]){
  var request = HttpRequest.getString(generateUrl()).then(callback == null ? onDataLoaded : callback);

}

void onInit(String responseText){
  onDataLoaded(responseText);
  addStoryToView(getNextStory());
}

void onDataLoaded(String responseText) {
  var jsonString = responseText;
  var parsedList = JSON.decode(jsonString);
  parsedList["data"]["children"].forEach(jsonToQueue);
  //Story s = queue.first;
  //querySelector("#stuff").appendHtml("<h1>" + s.title + "</h1>");
}

void jsonToQueue(element) {
  queue.addLast(new Story.fromJsonObject(element));
}

void addStoryToView(Story story){
  storyTitleDiv.appendHtml(story.title);
}
