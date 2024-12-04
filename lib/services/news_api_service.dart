import 'package:news_app/models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'af1ec12c17314a37afe9569ec7640541';

  Future<List<Article>> fetchTopHeadlines() async {}
}
