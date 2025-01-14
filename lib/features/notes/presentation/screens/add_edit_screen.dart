import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // استيراد الترجمة

class AddEditScreen extends StatefulWidget {
  final Note? initialNote;
  final void Function(String title, String content) onSave;

  const AddEditScreen({
    super.key,
    this.initialNote,
    required this.onSave,
  });

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialNote?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialNote?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final l10n = AppLocalizations.of(context)!; // استدعاء الترجمة
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      widget.onSave(title, content);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.title_content_empty),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // استدعاء الترجمة
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: _isEditingTitle
                  ? TextField(
                controller: _titleController,
                onChanged: (value) {
                  if (value.length > 50) {
                    _titleController.text = value.substring(0, 50);
                    _titleController.selection =
                        TextSelection.fromPosition(
                          TextPosition(offset: _titleController.text.length),
                        );
                  }
                },
                onSubmitted: (_) =>
                    setState(() => _isEditingTitle = false),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: l10n.enter_title,
                ),
              )
                  : GestureDetector(
                onTap: () => setState(() => _isEditingTitle = true),
                child: Text(
                  _titleController.text.isEmpty
                      ? l10n.new_note
                      : _titleController.text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.save,size: 30,),
                onPressed: _saveNote,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: _contentController,
          decoration: InputDecoration(
            hintText: l10n.write_your_note,
            border: InputBorder.none,
          ),
          maxLines: null,
          expands: true,
        ),
      ),
    );
  }
}
