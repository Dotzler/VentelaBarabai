import 'dart:convert';

Articles articlesFromJson(String str) => Articles.fromJson(json.decode(str));

String articlesToJson(Articles data) => json.encode(data.toJson());

class Articles {
    String status;
    int totalResults;
    List<Article> articles;

    Articles({
        required this.status,
        required this.totalResults,
        required this.articles,
    });

    factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };
}

class Article {
    Source source;
    String? author;
    String title;
    String description;
    String url;
    String? urlToImage;
    DateTime publishedAt;
    String content;

    Article({
        required this.source,
        this.author, // author can be null
        required this.title,
        required this.description,
        required this.url,
        this.urlToImage, // urlToImage can be null
        required this.publishedAt,
        required this.content,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author, // author can be null, no need to check
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage, // urlToImage can be null, no need to check
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}

class Source {
    String? id;
    String name;

    Source({
        this.id, // id can be null
        required this.name,
    });

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id, // id can be null, no need to check
        "name": name,
    };
}