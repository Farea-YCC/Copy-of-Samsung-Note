import 'package:notes/core/imports/imports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(l10n.title),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: NotesSearchDelegate());
            },
            icon: Tooltip(
              message:
                  l10n.search, // Use the localization string for the tooltip
              child: const Icon(Icons.search_rounded),
            ),
          ),
        ],
      ),
      body: provider.notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.isEmpty,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    l10n.isEmptyAddNote,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                return NoteCard(
                  note: note,
                  onTap: () =>
                      NavigationService.navigateToEditNoteScreen(context, note),
                  onLongPress: () =>
                      BottomSheetService.showBottomSheetNote(context, note),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.tooltip,
        onPressed: () => NavigationService.navigateToAddNoteScreen(context),
        child: Image.asset(
          'assets/images/add.png',
          width: 20.0,
          height: 20.0,
        ),
      ),
    );
  }
}
