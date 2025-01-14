import 'package:notes/core/imports/imports.dart';
class AddEditScreen extends StatefulWidget {
  final Note? initialNote;
  final void Function(String title, String content) onSave;

  const AddEditScreen({
    super.key,
    this.initialNote,
    required this.onSave,
  });

  @override
  AddEditScreenState createState() => AddEditScreenState();
}
class AddEditScreenState extends State<AddEditScreen> {
  late TextEditingController _titleController;
  late QuillController _quillController;

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
    _saveNote();
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = jsonEncode(_quillController.document.toDelta().toJson());
    final plainTextContent = _quillController.document.toPlainText().trim();

    if (title.isEmpty) {
      _generateUniqueTitle(plainTextContent);
    } else {
      widget.onSave(title, content);
    }
  }

  void _generateUniqueTitle(String content) {
    final allNotes = Provider.of<NotesProvider>(context, listen: false).notes;
    final usedNumbers = allNotes
        .where((n) => n.title.startsWith('ملاحظة نصية '))
        .map((n) => int.tryParse(n.title.replaceFirst('ملاحظة نصية ', '')))
        .where((num) => num != null)
        .toSet();

    int counter = 1;
    while (usedNumbers.contains(counter)) {
      counter++;
    }

    widget.onSave('ملاحظة نصية $counter', content);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _saveNote();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 5,
        title: _buildTitleField(l10n),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildQuillEditor()),
            _buildQuillToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField(AppLocalizations l10n) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: l10n.enter_title,
      ),
    );
  }

  Widget _buildQuillEditor() {
    return QuillEditor.basic(
      controller: _quillController,
      focusNode: FocusNode(),
    );
  }

  Widget _buildQuillToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: QuillToolbar.simple(controller: _quillController),
    );
  }
}
