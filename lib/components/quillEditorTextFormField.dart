import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/material.dart';

class QuillEditorFormField extends StatefulWidget {
  const QuillEditorFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
  }) : super(key: key);

  final QuillController controller;
  final String labelText;
  final String? hintText;
  final int maxLines;
  final int? minLines;

  @override
  _QuillEditorFormFieldState createState() => _QuillEditorFormFieldState();
}

class _QuillEditorFormFieldState extends State<QuillEditorFormField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.controller.document.toPlainText());
    widget.controller.addListener(_updateController);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateController);
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateController() {
    final plainText = widget.controller.document.toPlainText();
    if (_textEditingController.text != plainText) {
      _textEditingController.value =
          _textEditingController.value.copyWith(text: plainText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        icon: const Icon(
          Icons.article,
          color: Colors.deepPurple,
        ),
      ),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onChanged: (text) {
        widget.controller.replaceText(0, widget.controller.document.length,
            text, TextSelection(baseOffset: 1, extentOffset: 2));
      },
    );
  }
}
