class Book {
  int id;
  String title;
  String author;
  double rating;
  bool isRead;
  String? imagePath;
  String? pdfPath; // Add this line

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.isRead,
    this.imagePath,
    this.pdfPath, // Add this line
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'isRead': isRead ? 1 : 0,
      'imagePath': imagePath,
      'pdfPath': pdfPath, // Add this line
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      rating: json['rating'],
      isRead: json['isRead'] == 1,
      imagePath: json['imagePath'],
      pdfPath: json['pdfPath'], // Add this line
    );
  }
}
