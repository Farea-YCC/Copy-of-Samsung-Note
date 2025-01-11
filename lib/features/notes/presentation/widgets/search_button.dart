import 'package:notes/features/notes/presentation/widgets/view_notes_list_search.dart';

import '../../../../core/imports/imports.dart';

class NotesSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final notesProvider
    = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.searchNotes(query);

    return ViewNotesListSearch(notes: notesProvider.notes);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        final filteredNotes = notesProvider.notes
            .where((note) => note.title.contains(query))
            .toList();
        return ViewNotesListSearch(notes: filteredNotes);
      },
    );
  }
}
