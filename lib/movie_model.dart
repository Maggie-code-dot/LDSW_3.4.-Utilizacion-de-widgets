class Movie {
  final String id;
  final String title;
  final int year;
  final String director;
  final String genre;
  final String synopsis;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'imageUrl': imageUrl,
    };
  }

  factory Movie.fromMap(String id, Map<String, dynamic> map) {
    return Movie(
      id: id,
      title: map['title'] ?? '',
      year: map['year'] ?? 0,
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      synopsis: map['synopsis'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}