import 'dart:convert';
import 'dart:io';
import 'package:custfyp/services/dialog_service.dart';
import 'package:custfyp/subsciption_screen.dart';
import 'package:custfyp/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String selectedModel = 'Bert v1';
  double temperatureSliderValue = 0.8;
  double topPSliderValue = 0.9;
  double maxLengthSliderValue = 0.3;
  String? selectedPdfPath;
  List<Map<String, dynamic>> messages = [
    {'sender': 'bot', 'text': 'Hi, how can I help you?'}
  ];

  Future<void> sendEncodedPayload() async {
    setState(() {
      messages.add({
        'sender': 'user',
        'text': _controller.text,
        'file': selectedPdfPath
      });
      selectedPdfPath = null;
    });

    Map<String, dynamic> inputData = {
      "query_text": _controller.text,
      "model_name": selectedModel,
      "temperature": temperatureSliderValue,
      "top_p": topPSliderValue,
      "max_length": maxLengthSliderValue.toInt(),
    };

    _controller.clear();

    String jsonStr = jsonEncode(inputData);
    String encodedStr = base64Encode(utf8.encode(jsonStr));

    String url = "http://10.0.2.2:5000/decode";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"encoded_data": encodedStr}),
      );

      if (response.statusCode == 200) {
        setState(() {
          messages.add({
            'sender': 'bot',
            'text': jsonDecode(response.body)['response']
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Chat Bot', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),  // Person icon
            onPressed: () {
              // Navigate to UserProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()), // Replace with your actual user profile screen widget
              );
            },
          ),
        ],// Set drawer icon color to white
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                ListTile(
                  title: const Text('Select Model', style: TextStyle(color: Colors.white)),
                  trailing: DropdownButton<String>(
                    value: selectedModel,
                    items: const [
                      DropdownMenuItem(
                        value: 'Bert v1',
                        child: Text('Bert v1', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'llama3.1',
                        child: Text('llama3.1', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'Llama',
                        child: Text('Llama', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value!;
                      });
                    },
                    hint: const Text('Select Model', style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.grey[800],
                  ),
                ),
                SliderSetting(
                  title: 'Temperature',
                  value: temperatureSliderValue,
                  onChanged: (newValue) {
                    setState(() {
                      temperatureSliderValue = newValue;
                    });
                  },
                ),
                SliderSetting(
                  title: 'Top-P',
                  value: topPSliderValue,
                  onChanged: (newValue) {
                    setState(() {
                      topPSliderValue = newValue;
                    });
                  },
                ),
                SliderSetting(
                  title: 'Max Length',
                  value: maxLengthSliderValue,
                  onChanged: (newValue) {
                    setState(() {
                      maxLengthSliderValue = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.subscriptions, color: Colors.white),
                  title: const Text("Subscriptions", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubsciptionScreen()),
                    );
                  },
                ),
                const SizedBox(height: 2),
                ListTile(
                  leading: const Icon(Icons.clear_all, color: Colors.white),
                  title: const Text("Clear Chat", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      messages.clear();
                      messages.add({'sender': 'bot', 'text': 'Hi, how can I help you?'});
                    });
                    Navigator.pop(context); // Close the drawer after clearing
                  },
                ),
                const SizedBox(height: 2),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("LogOut", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'user'
                            ? Colors.grey
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message['file'] != null)
                            Text(
                              "PDF: ${message['file']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          Text(
                            message['text'] ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  if (selectedPdfPath != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'PDF: ${selectedPdfPath!.split('/').last}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.file_copy, color: Colors.blue),
                    onPressed: () async {
                      final pickedFile = await _pickFile();
                      setState(() {
                        selectedPdfPath = pickedFile?.path;
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[850],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Type your message here...',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (_controller.text.isNotEmpty || selectedPdfPath != null) {
                        sendEncodedPayload();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
    return null;
  }

}

class SliderSetting extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderSetting({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 1.0,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
