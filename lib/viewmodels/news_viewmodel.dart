import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../dbhelper/database_helper.dart';

class NewsViewModel with ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  List<Article> _articles = [];

  final NewsService _newsService = NewsService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  bool get isLoading => _isLoading;
  String get error => _error;
  List<Article> get articles => _articles;

  // Private methods for state management
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void _setError(String errorMsg) {
    _error = errorMsg;
    notifyListeners();
  }

  void _setArticles(List<Article> newArticles) {
    _articles = newArticles;
    notifyListeners();
  }

  // Fetch top headlines
  Future<void> fetchTopHeadlines() async {
    _setLoadingState(true);
    try {
      List<Article> fetchedArticles = await _newsService.fetchTopHeadlines();
      _setArticles(fetchedArticles);
      _setError('');
    } catch (e) {
      _setError('Failed to fetch top headlines: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Search news articles by query
  Future<void> searchNews(String query) async {
    _setLoadingState(true);
    try {
      List<Article> fetchedArticles = await _newsService.searchNews(query);
      _setArticles(fetchedArticles);
      _setError('');
    } catch (e) {
      _setError('Failed to search news: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Fetch news articles by category
  Future<void> fetchNewsByCategory(String category) async {
    _setLoadingState(true);
    try {
      List<Article> fetchedArticles =
          await _newsService.fetchNewsByCategory(category);
      _setArticles(fetchedArticles);
      _setError('');
    } catch (e) {
      _setError('Failed to fetch news by category: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Check if an article is saved
  Future<bool> isArticleSaved(String id) async {
    try {
      return await _databaseHelper.isArticleSaved(id);
    } catch (e) {
      _setError('Failed to check if article is saved: $e');
      return false;
    }
  }

  // Save an article to the database
  Future<void> saveArticle(Article article) async {
    try {
      await _databaseHelper.saveArticle(article);
      notifyListeners();
    } catch (e) {
      _setError('Failed to save article: $e');
    }
  }

  // Unsave an article from the database
  Future<void> unsaveArticle(String id) async {
    try {
      await _databaseHelper.unsaveArticle(id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to unsave article: $e');
    }
  }

  // Fetch all saved articles
  Future<List<Article>> fetchSavedArticles() async {
    _setLoadingState(true);
    try {
      List<Article> savedArticles = await _databaseHelper.getSavedArticles();
      _setArticles(savedArticles);
      return savedArticles;
    } catch (e) {
      _setError('Failed to fetch saved articles: $e');
      return [];
    } finally {
      _setLoadingState(false);
    }
  }

  // Sort articles alphabetically (A-Z)
  void sortArticlesAZ() {
    _articles.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  // Sort articles in reverse alphabetical order (Z-A)
  void sortArticlesZA() {
    _articles.sort((a, b) => b.title.compareTo(a.title));
    notifyListeners();
  }
}
