import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  final List<String> categories;
  final Function(String) onChanged;

  const CategoryDropdown(
      {Key? key, required this.categories, required this.onChanged})
      : super(key: key);

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        widget.onChanged(value!);
      },
      items: widget.categories
          .map<DropdownMenuItem<String>>(
            (value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }
}
