import 'package:notes/core/imports/imports.dart';
class BottomSheetService {
  static void showBottomSheetNote(BuildContext context, Note note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBottomSheetOption(
                  context,
                  icon: Icons.delete,
                  label: l10n.delete,
                  onTap: () {
                    _showDeleteConfirmationDialog(context, note);
                  },
                ),
                const Divider(),
                _buildBottomSheetOption(
                  context,
                  icon:
                      note.isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: note.isFavorite ? l10n.unfavorites : l10n.favorites,
                  onTap: () {
                    Provider.of<NotesProvider>(context, listen: false)
                        .toggleFavorite(note);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                _buildBottomSheetOption(
                  context,
                  icon: Icons.share,
                  label: l10n.share,
                  onTap: () {
                    if (note.content.isNotEmpty) {
                      Share.share(note.content, subject: l10n.share);
                    } else {
                      return;
                    }
                  },
                ),
                const Divider(),
                _buildBottomSheetOption(
                  context,
                  icon: Icons.lock_outline_rounded,
                  label: l10n.lock,
                  onTap: () {
                    _lockNote(context, note);
                  },
                ),
                const Divider(),
                _buildBottomSheetOption(
                  context,
                  icon: Icons.print,
                  label: l10n.print,
                  onTap: () {
                    PrintService.printNote(context, note);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _showDeleteConfirmationDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Center(child: Text(l10n.delete)),
          content: Text(l10n.areYouSuredelete),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<NotesProvider>(context, listen: false)
                    .deleteNote(note.id!);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  static void _lockNote(BuildContext context, Note note) {
    Navigator.of(context).pop();
  }

  static Widget _buildBottomSheetOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
