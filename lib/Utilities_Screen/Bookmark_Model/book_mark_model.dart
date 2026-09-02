class BookmarkModel {
  final String title;
  final String description;
  final String image;
  final String content;
  final String source;
  final String url;
  final DateTime savedAt;

  BookmarkModel({
    required this.title,
    required this.description,
    required this.image,
    required this.content,
    required this.source,
    required this.url,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'image': image,
    'content': content,
    'source': source,
    'url': url,
    'savedAt': savedAt.toIso8601String(),
  };

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
    title: json['title'],
    description: json['description'],
    image: json['image'],
    content: json['content'],
    source: json['source'],
    url: json['url'],
    savedAt: DateTime.parse(json['savedAt']),
  );
}
