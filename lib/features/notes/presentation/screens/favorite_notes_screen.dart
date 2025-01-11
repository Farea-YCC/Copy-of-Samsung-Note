import 'package:notes/core/imports/imports.dart';
class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final favoriteNotes = Provider.of<NotesProvider>(context).favoriteNotes;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title:  Text(l10n.favoritenotes),
      ),
      body: favoriteNotes.isEmpty
          ? Center(
              child: Text(l10n.no_note_favorite),
            )
          : ListView.builder(
              itemCount: favoriteNotes.length,
              itemBuilder: (context, index) {
                final note = favoriteNotes[index];
                return Card(
                  child: ListTile(
                    trailing: note.isFavorite
                        ? const Icon(Icons.favorite, color: Color.fromARGB(255, 242, 104, 77),)
                        : null,
                    title: Text(note.title),
                    onTap: () =>
                        NavigationService.navigateToEditNoteScreen(context, note),
                  ),

                );
              },
            ),
    );
  }
}
