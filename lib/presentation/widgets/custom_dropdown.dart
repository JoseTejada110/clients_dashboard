import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.errorText,
  });
  final List<dynamic> items;
  final dynamic value;
  final void Function(dynamic) onChanged;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        isDense: true,
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
      ),
      value: value,
      items: _builItems(),
      onChanged: onChanged,
    );
  }

  List<DropdownMenuItem<dynamic>> _builItems() {
    return items
        .map((element) => DropdownMenuItem(
              value: element,
              child: Text(element?['descripcion'] ?? ''),
            ))
        .toList();
  }
}