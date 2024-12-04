import 'package:flutter/material.dart';
import 'package:news_app/services/news_api_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();
}