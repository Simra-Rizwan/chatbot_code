import 'package:custfyp/services/summarize_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_service_provider.dart';

Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // User can dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF7F00FF).withOpacity(0.8),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async{
              // Navigator.pushReplacementNamed(context, '/login');
                await context.read<AuthServiceProvider>().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', // Replace this with your login route name
                      (route) => false, // Remove all routes
                );
                // Navigator.of(context).pop();
              },
          ),
        ],
      );
    },
  );
}


Future<String> showInputDialog(BuildContext context) async {
  final SummarizeService _summarizeService =
  SummarizeService('http://192.168.43.121:5000');
  final TextEditingController textController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();

  String? _summary;

  await showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Insert Parameters'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                    hintText: 'Enter text to summarize'),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lengthController,
                decoration: const InputDecoration(
                    hintText: 'Enter number of sentences'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Submit'),
            onPressed: () async {
              final text = textController.text;
              final sentenceCount = int.tryParse(lengthController.text) ?? 5;
              if (text.isNotEmpty) {
                try {
                  final summary = await _summarizeService.summarizeText(
                      text, sentenceCount);
                  // setState(() {
                    _summary = summary;
                  // });
                  // return summary;
                } catch (e) {
                  // Handle error
                  print("Something went Wrong $e");
                }
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
   return _summary ?? "";
}

