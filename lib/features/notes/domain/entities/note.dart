class Note {
  final int? id;
  final String title;
  final String content;
  final bool isFavorite;

  const Note({
    this.id,
    required this.title,
    required this.content,
    this.isFavorite = false,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    bool? isFavorite,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}