import '../../domain/entities/note.dart';
class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.title,
    required super.content,
    super.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isFavorite: map['is_favorite'] == 1,
    );
  }
}