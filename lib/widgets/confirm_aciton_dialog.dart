import 'package:flutter/material.dart';

class ConfirmActionDialog extends StatelessWidget {
  final String dialogBodyText;
  final VoidCallback onYesCallback;
  final VoidCallback onNoCallback;

  const ConfirmActionDialog({
    super.key,
    required this.dialogBodyText,
    required this.onYesCallback,
    required this.onNoCallback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text(dialogBodyText),
      actions: [
        TextButton(onPressed: onNoCallback, child: Text("No")),
        TextButton(onPressed: onYesCallback, child: Text("Yes")),
      ],
    );
  }
}
