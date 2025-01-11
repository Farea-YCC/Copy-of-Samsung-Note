import '../../../../core/imports/imports.dart';
import '../../domain/entities/note.dart';
import 'navigation_service.dart';

class ViewNotesListSearch extends StatelessWidget {
  final List<Note> notes;

  const ViewNotesListSearch({required this.notes, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(note.title),
          trailing: IconButton(
            icon: Icon(
              note.isFavorite ? Icons.star : Icons.star_border,
            ),
            onPressed: () async {
              final provider =
              Provider.of<NotesProvider>(context, listen: false);
              await provider.toggleFavorite(note);
            },
          ),
          onTap: () =>
              NavigationService.navigateToEditNoteScreen(context, note),
        );
      },
    );
  }
}
