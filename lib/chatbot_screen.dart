import 'dart:convert';
import 'dart:io';
import 'package:custfyp/services/dialog_service.dart';
import 'package:custfyp/subsciption_screen.dart';
import 'package:custfyp/summarizer_screen.dart';
import 'package:custfyp/user_profile.dart';
import 'package:custfyp/welcome_screen.dart';
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
  String? selectedPdfName;  // Variable to store the PDF name
  List<Map<String, dynamic>> messages = [
    {'sender': 'bot', 'text': 'Hi,Welcome to ChatBot'},
    {'sender': 'bot', 'text': 'How can I help you?'}
  ];

  Future<void> sendEncodedPayload(String? pdfUrl) async {
    setState(() {
      messages.add({'sender': 'user', 'text': _controller.text, 'file': pdfUrl});
      selectedPdfPath = null;
      selectedPdfName = null;  // Reset the file name after sending the message
    });

    Map<String, dynamic> inputData = {
      "query_text": _controller.text,
      "model_name": selectedModel,
      "temperature": temperatureSliderValue,
      "top_p": topPSliderValue,
      "max_length": maxLengthSliderValue.toInt(), // Ensure this is cast to int
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
          messages.add(
              {'sender': 'bot', 'text': jsonDecode(response.body)['response']});
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
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white), // Person icon
            onPressed: () {
              // Navigate to UserProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
        ],
        title: const Text(
          'ChatBot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // This will center the title in the AppBar
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(05.0),
                  child: Text('Settings',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                ListTile(
                  title: const Text('Select Model',
                      style: TextStyle(color: Colors.white)),
                  trailing: DropdownButton<String>(
                    value: selectedModel,
                    items: const [
                      DropdownMenuItem(
                        value: 'Bert v1',
                        child: Text('Bert v1',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'llama3.1',
                        child: Text('llama3.1',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'Llama',
                        child: Text('Llama',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value!;
                      });
                    },
                    hint: const Text('Select Model',
                        style: TextStyle(color: Colors.white)),
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
                const SizedBox(height: 5),
                ListTile(
                  leading: const Icon(Icons.subscriptions, color: Colors.white),
                  title: const Text("Subscriptions",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubsciptionScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.clear_all, color: Colors.white),
                  title: const Text("Clear Chat",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      messages.clear();
                      messages.add(
                          {'sender': 'bot', 'text': 'Hi, how can I help you?'});
                    });
                    Navigator.pop(context); // Close the drawer after clearing
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("LogOut",
                      style: TextStyle(color: Colors.white)),
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
                  print("Message: ${message['text']}");
                  return Align(
                    alignment: message['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
                        'PDF: ${selectedPdfName}', // Display the PDF name
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.file_copy, color: Colors.blue),
                    onPressed: () async {
                      final pickedFile = await _pickFile();
                      if (pickedFile != null) {
                        setState(() {
                          selectedPdfPath = pickedFile.path;
                          selectedPdfName = pickedFile.path.split('/').last; // Extract and store the PDF name
                        });
                        sendEncodedPayload(null); // Send message without PDF
                      }
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      sendEncodedPayload(null); // Send message without PDF
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}

class SliderSetting extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderSetting({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Slider(
        value: value,
        min: 0.0,
        max: 1.0,
        onChanged: onChanged,
      ),
    );
  }
}
