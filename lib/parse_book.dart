class Book {
  final int id;
  final String title;
  final List<Map<String, dynamic>> authors;
  final List<String> subjects;
  final List<String> bookshelves;
  final List<String> languages;
  final bool copyright;
  final String mediaType;
  final Map<String, String> formats;
  final int downloadCount;
  final String imageUrl;

  // Constructor to initialize all the fields
  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
    required this.imageUrl,  
  });

  // Factory constructor to create a Book from a JSON map
  factory Book.parseJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: List<Map<String, dynamic>>.from(json['authors']),
      subjects: List<String>.from(json['subjects']),
      bookshelves: List<String>.from(json['bookshelves']),
      languages: List<String>.from(json['languages']),
      copyright: json['copyright'],
      mediaType: json['media_type'],
      formats: Map<String, String>.from(json['formats']),
      downloadCount: json['download_count'],
      imageUrl: json['formats']['image/jpeg'] ?? '', 
    );
  }
}
