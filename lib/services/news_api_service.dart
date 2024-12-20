import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/article.dart';

class NewsApi {
  // for news home screen
  List<NewsModel> dataStore = [];
Future<void> getNews({
  String? query,
  required String country,
  String sortBy = 'relevancy', // Default sort is relevance
}) async {
  Uri url = Uri.parse(
    "https://newsapi.org/v2/top-headlines?country=$country${query != null && query.isNotEmpty ? '&q=$query' : ''}&sortBy=$sortBy&apiKey=af1ec12c17314a37afe9569ec7640541"
  );

  var response = await http.get(url);
  var jsonData = jsonDecode(response.body);
  if (jsonData["status"] == 'ok') {
    dataStore.clear(); // Clear old data before adding new articles
    jsonData["articles"].forEach((element) {
      if (element['urlToImage'] != null &&
          element['description'] != null &&
          element['author'] != null &&
          element['content'] != null) {
        NewsModel newsModel = NewsModel(
          title: element['title'],
          urlToImage: element['urlToImage'],
          description: element['description'],
          author: element['author'],
          content: element['content'],
        );
        dataStore.add(newsModel);
      }
    });
  }
}


}

class CategoryNews {
  // for news home screen
  List<NewsModel> dataStore = [];
  Future<void> getNews(String category) async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=af1ec12c17314a37afe9569ec7640541");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null) {
          NewsModel newsModel = NewsModel(
            title: element['title'], // name must be same fron api
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
          );
          dataStore.add(newsModel);
        }
      });
    }
  }
}
