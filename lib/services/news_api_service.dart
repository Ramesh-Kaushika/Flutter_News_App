import 'package:news_app/models/article.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'af1ec12c17314a37afe9569ec7640541';

  Future<List<Article>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }

  }
}
