import 'package:flutter/material.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required String validatorMsg,
  bool readOnly = false,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    readOnly: readOnly,
    maxLines: maxLines,
    validator: (v) => v!.isEmpty ? validatorMsg : null,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.green.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
