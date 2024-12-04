import 'package:flutter/material.dart';
import 'package:news_app/view_models/news_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            onPressed: () => newsProvider.fetchNews(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: newsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsProvider.articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: newsProvider.articles[index]);
              },
            ),
    );
  }
}
