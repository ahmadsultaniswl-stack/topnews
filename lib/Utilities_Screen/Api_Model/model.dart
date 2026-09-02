class NewsModel {
  final String title;
  final String description;
  final String image;
  final String content;
  final String source;
  final String url;

  NewsModel({
    required this.title,
    required this.description,
    required this.image,
    required this.content,
    required this.source,
    required this.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      content: json['content'] ?? '',
      source: json['source']['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
