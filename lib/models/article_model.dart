class Article {
  final String id; // The unique identifier (using URL as id)
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String author;

  /// Constructor for creating an `Article` object.
  Article({
    required this.id, // Unique identifier
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.author,
  });

  /// Factory constructor to create an `Article` from a JSON object.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['url'] ?? '', // Use URL as the unique identifier
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? 'No Content',
      author: json['author'] ?? 'Unknown Author',
    );
  }

  /// Converts the `Article` to a JSON object for API requests or logging.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'author': author,
    };
  }

  /// Converts the `Article` to a map for database operations.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'author': author,
    };
  }

  /// Factory constructor to create an `Article` from a database map.
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'], // Ensure 'id' is used here as well
      title: map['title'] ?? 'No Title',
      description: map['description'] ?? 'No Description',
      url: map['url'] ?? '',
      urlToImage: map['urlToImage'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      content: map['content'] ?? 'No Content',
      author: map['author'] ?? 'Unknown Author',
    );
  }

  /// Override `toString` for easier debugging and logging.
  @override
  String toString() {
    return 'Article(id: $id, title: $title, description: $description, url: $url)';
  }

  /// Override `==` to compare two `Article` objects.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Article) return false;
    return id == other.id &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        urlToImage == other.urlToImage &&
        publishedAt == other.publishedAt &&
        content == other.content &&
        author == other.author;
  }

  /// Override `hashCode` for use in collections like `Set`.
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        url.hashCode ^
        urlToImage.hashCode ^
        publishedAt.hashCode ^
        content.hashCode ^
        author.hashCode;
  }
}
