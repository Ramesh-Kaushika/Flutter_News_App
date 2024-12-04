import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: article.imageUrl.isNotEmpty
            ? Image.network(article.imageUrl, width: 100, fit: BoxFit.cover)
            : null,
        title: Text(article.title),
        subtitle: Text(article.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
      ),
    );
  }
}
