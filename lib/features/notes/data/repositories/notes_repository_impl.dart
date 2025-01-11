import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../models/note_model.dart';
import '../../domain/entities/note.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Note>> getAllNotes() async {
    return await localDataSource.getAllNotes();
  }

  @override
  Future<void> addNote(Note note) async {
    await localDataSource.addNote(
      NoteModel(
        title: note.title,
        content: note.content,
        isFavorite: note.isFavorite,
      ),
    );
  }

  @override
  Future<void> updateNote(Note note) async {
    await localDataSource.updateNote(
      NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        isFavorite: note.isFavorite,
      ),
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    await localDataSource.deleteNote(id);
  }

  @override
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await localDataSource.toggleFavorite(id, isFavorite);
  }
}