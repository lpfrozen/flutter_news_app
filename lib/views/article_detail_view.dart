import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../viewmodels/news_viewmodel.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          FutureBuilder<bool>(
            future: Provider.of<NewsViewModel>(context, listen: false)
                .isArticleSaved(article.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: null, // Show loading state
                );
              }

              bool isSaved = snapshot.data ?? false;
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : Colors.white,
                ),
                onPressed: () async {
                  if (isSaved) {
                    await Provider.of<NewsViewModel>(context, listen: false)
                        .unsaveArticle(article.id);
                  } else {
                    await Provider.of<NewsViewModel>(context, listen: false)
                        .saveArticle(article);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: article.urlToImage,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: article.urlToImage.isNotEmpty
                        ? Image.network(
                            article.urlToImage,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                height: 250,
                                child: Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            height: 250,
                            child: Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  article.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'By ${article.author}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Published on: ${article.publishedAt}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  article.description ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  article.content ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
