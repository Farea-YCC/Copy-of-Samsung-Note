import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../domain/entities/note.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress, required List<Note> allNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          trailing: note.isFavorite
              ? const Icon(
            Icons.favorite,
            color: Color.fromARGB(255, 242, 104, 77),
          )
              : null,
          title: Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.content.isNotEmpty
                ? Document.fromJson(jsonDecode(note.content))
                .toPlainText()
                .trim()
                : 'لا يوجد محتوى',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
