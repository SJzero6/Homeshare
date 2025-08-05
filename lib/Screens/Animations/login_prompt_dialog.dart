// widgets/login_prompt_dialog.dart
import 'package:flutter/material.dart';

class LoginPromptDialog extends StatelessWidget {
  const LoginPromptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Login Required"),
      content: const Text("You need to login to view room details."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.pushNamed(context, '/login'); // Navigate to login page
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}
