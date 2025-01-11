import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

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
  late QuillController _quillController;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialNote?.title ?? '');
    _quillController = QuillController(
      document: widget.initialNote?.content != null
          ? Document.fromJson(jsonDecode(widget.initialNote!.content))
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text;
    final content = jsonEncode(_quillController.document.toDelta().toJson());
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
    final l10n = AppLocalizations.of(context)!;
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
                icon: const Icon(
                  Icons.save,
                  size: 30,
                ),
                onPressed: _saveNote,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Expanded(
                child: QuillEditor.basic(
                  controller: _quillController,
                  focusNode: FocusNode(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: QuillToolbar.simple(
                    controller: _quillController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
