import '../entities/note.dart';
abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int id);
  Future<void> toggleFavorite(int id, bool isFavorite);
}
