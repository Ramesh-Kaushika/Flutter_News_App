import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_api_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();
  List<Article> _articles = [];
  bool _isLoading = true;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    _articles = await _newsApiService.fetchTopHeadlines();
    _isLoading = false;
    notifyListeners();
  }
}
