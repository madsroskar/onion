import 'dart:html';
import 'dart:convert';
import 'dart:collection';
import 'Story.dart';

var queue = new Queue();
Story currentStory;
int score = 0;

bool loading = false;

const URL = "http://www.reddit.com/user/Grasa/m/onionornot.json";
const COUNT = "count=5";
const AFTER = "after=";
const THE_ONION = "TheOnion";
const NOT_THE_ONION = "nottheonion";

final storyTitleDiv = querySelector("#story-title");
final storyThumbnailImg = querySelector("#story-thumbnail img");

final btnTheOnion = querySelector("#the-onion");
final btnNotTheOnion = querySelector("#not-the-onion");
final spanScore = querySelector("#stats #score");

void main() {
  init();

}

void init() {
  btnTheOnion.addEventListener("click", answer);
  btnNotTheOnion.addEventListener("click", answer);
  loadNewStories(onInit);
  if(window.localStorage['score'] == null){
    window.localStorage['score'] = "0";
  }
}

void answer(Event e) {

  if(loading) return;
  DivElement div = e.target;
  if(div.id == "the-onion"){
    if(currentStory.subreddit == THE_ONION){
      correctAnswer();
    }else{
      wrongAnswer();
    }
  }else{
    if(currentStory.subreddit == NOT_THE_ONION){
      correctAnswer();
    }else{
      wrongAnswer();
    }
  }
}

void correctAnswer(){
  //Score++
  nextQuestion();
}

void wrongAnswer(){
  editScore(2);
  nextQuestion();
}

void nextQuestion(){
  editScore(-1);
  addStoryToView(getNextStory());
}

String generateUrl() {
  if (queue.length == 0) {
    return URL;
  } else {
    Story last = queue.last;
    return URL + "?" + COUNT + "&" + AFTER + "t3_" + last.id;
  }
}

Story getNextStory() {
  if (queue.length < 3 && !loading) {
    loadNewStories();
    return queue.removeFirst();
  }
  return queue.removeFirst();
}

void loadNewStories([dynamic callback]) {
  loading = true;
  var request = HttpRequest.getString(generateUrl()).then(callback == null ? onDataLoaded : callback);

}

void onInit(String responseText) {
  onDataLoaded(responseText);
  addStoryToView(getNextStory());
  loading = false;
}

void onDataLoaded(String responseText) {
  var jsonString = responseText;
  var parsedList = JSON.decode(jsonString);
  parsedList["data"]["children"].forEach(jsonToQueue);
  //Story s = queue.first;
  //querySelector("#stuff").appendHtml("<h1>" + s.title + "</h1>");
  loading = false;
}

void jsonToQueue(element) {
  queue.addLast(new Story.fromJsonObject(element));
}

void editScore(int change){
  window.localStorage['score'] = (int.parse(window.localStorage['score']) + change).toString();
  if(int.parse(window.localStorage['score']) < 0){
    window.localStorage['score'] = "0";
  }
}

void addStoryToView(Story story) {
  currentStory = story;
  storyTitleDiv.text = story.title;
  spanScore.text = window.localStorage['score'];

  // = "url(" + story.thumbnail + ");";
}
