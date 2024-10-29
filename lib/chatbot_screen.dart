import 'dart:io';
import 'package:custfyp/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String selectedModel = 'Bert v1';
  List<Map<String, dynamic>> messages = [
    {'sender': 'user', 'text': 'Hey'},
    {'sender': 'bot', 'text': 'Hey! How’s it going? Is there something I can help you with?'},
    {'sender': 'user', 'text': 'What is the capital of Pakistan?'},
    {'sender': 'bot', 'text': 'The capital of Pakistan is Islamabad.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Chat Dat', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  ListTile(
                    title: Text('Select Model', style: TextStyle(color: Colors.white)),
                    trailing: DropdownButton<String>(
                      value: selectedModel,
                      items: [
                        DropdownMenuItem(
                          child: Text('Bert v1', style: TextStyle(color: Colors.white)),
                          value: 'Bert v1',
                        ),
                        DropdownMenuItem(
                          child: Text('GPT-3', style: TextStyle(color: Colors.white)),
                          value: 'GPT-3',
                        ),
                        DropdownMenuItem(
                          child: Text('Llama', style: TextStyle(color: Colors.white)),
                          value: 'Llama',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedModel = value!;
                        });
                      },
                      hint: Text('Select Model', style: TextStyle(color: Colors.white)),
                      dropdownColor: Colors.grey[800],
                    ),
                  ),
                  SliderSetting(title: 'Temperature', value: 0.8),
                  SliderSetting(title: 'Top-P', value: 0.9),
                  SliderSetting(title: 'Max Length', value: 32),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Upload PDF'),
                    ),
                  ),
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
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['sender'] == 'user'
                            ? Colors.red
                            : Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: message['text'] != null
                          ? Text(
                        message['text'],
                        style: TextStyle(color: Colors.black),
                      )
                          : Image.file(
                        message['image'],
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
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
                  IconButton(
                    icon: Icon(Icons.photo_camera, color: Colors.blue),
                    onPressed: () {
                      _showImageSourceOptions(context);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[850],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Type your message here...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          messages.add({'sender': 'user', 'text': _controller.text});
                          _controller.clear();
                        });
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

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[900],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera, color: Colors.white),
                title: Text('Take a Picture', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await _pickImage(ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      messages.add({
                        'sender': 'user',
                        'image': pickedFile,
                      });
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.white),
                title: Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile = await _pickImage(ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      messages.add({
                        'sender': 'user',
                        'image': pickedFile,
                      });
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
    return null;
  }


  // void showLogoutConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Confirm Logout"),
  //         content: Text("Are you sure you want to log out?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //               // Implement the logout functionality here
  //             },
  //             child: Text("Logout"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class SliderSetting extends StatefulWidget {
  final String title;
  final double value;

  SliderSetting({required this.title, required this.value});

  @override
  _SliderSettingState createState() => _SliderSettingState();
}

class _SliderSettingState extends State<SliderSetting> {
  late double _currentSliderValue;
  late double _minValue;
  late double _maxValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.value;

    if (widget.title == 'Max Length') {
      _minValue = 0.0;
      _maxValue = 100.0;
    } else {
      _minValue = 0.0;
      _maxValue = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(color: Colors.white)),
          Slider(
            value: _currentSliderValue,
            min: _minValue,
            max: _maxValue,
            divisions: widget.title == 'Max Length' ? 100 : 10,
            label: _currentSliderValue.toStringAsFixed(1),
            onChanged: (double newValue) {
              setState(() {
                _currentSliderValue = newValue;
              });
            },
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
