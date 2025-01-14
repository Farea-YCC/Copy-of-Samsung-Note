import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../screens/add_edit_screen.dart';
class NavigationService {
  static void navigateToAddNoteScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditScreen(
          onSave: (title, content) {
            Provider.of<NotesProvider>(context, listen: false)
                .addNote(Note(title: title, content: content));
          },
        ),
      ),
    );
  }

  static void navigateToEditNoteScreen(BuildContext context, Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditScreen(
          initialNote: note,
          onSave: (title, content) {
            Provider.of<NotesProvider>(context, listen: false).updateNote(
              Note(id: note.id, title: title, content: content),
            );
          },
        ),
      ),
    );
  }
}