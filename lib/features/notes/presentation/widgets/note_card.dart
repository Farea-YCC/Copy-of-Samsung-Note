import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          trailing: note.isFavorite
              ? const Icon(Icons.favorite, color: Color.fromARGB(255, 242, 104, 77),)
              : null,
          title: Text(
            note.title,
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