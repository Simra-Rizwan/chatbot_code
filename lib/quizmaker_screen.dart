import 'dart:convert';
import 'dart:io';
import 'package:custfyp/services/dialog_service.dart';
import 'package:custfyp/subsciption_screen.dart';
import 'package:custfyp/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class QuizMakerScreen extends StatefulWidget {
  const QuizMakerScreen({super.key});

  @override
  _QuizMakerScreenState createState() => _QuizMakerScreenState();
}

class _QuizMakerScreenState extends State<QuizMakerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? selectedPdfPath;
  String? pdfName; // Variable to store the PDF name
  int selectedQuestions = 1; // Default number of questions
  bool isShortChecked = false;
  bool isMCQsChecked = false;
  bool isTrueFalseChecked = false;
  List<Map<String, dynamic>> messages = [
    {'sender': 'bot', 'text': 'Hi, Welcome to Quiz Maker'},
    {'sender': 'bot', 'text': 'I can generate short questions, mcqs and true/false for you'}
  ];
  final TextEditingController shortController = TextEditingController();
  final TextEditingController mcqController = TextEditingController();
  final TextEditingController trueFalseController = TextEditingController();

  String errorMessage = ''; // Variable to store error messages

  Future<void> sendEncodedPayload(String? pdfUrl) async {
    setState(() {
      messages
          .add({'sender': 'user', 'text': _controller.text, 'file': pdfUrl});
      selectedPdfPath = null;
    });

    Map<String, dynamic> inputData = {
      "query_text": _controller.text,
      "selected_question": selectedQuestions,
      "short_checked": isShortChecked,
      "mcqs_checked": isMCQsChecked,
      "truefalse_checked": isTrueFalseChecked,
      "pdf_name": pdfName,
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

  Future<void> pickAndUploadPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedPdfPath = result.files.single.path;
        pdfName = result.files.single.name;  // Storing the PDF name here
      });
    }
  }


  // Function to check the condition of the sum of numbers in checkboxes
  bool isValidQuestionCount() {
    int sum = 0;
    if (isShortChecked) sum += int.tryParse(shortController.text) ?? 0;
    if (isMCQsChecked) sum += int.tryParse(mcqController.text) ?? 0;
    if (isTrueFalseChecked) sum += int.tryParse(trueFalseController.text) ?? 0;

    if (sum == selectedQuestions) {
      setState(() {
        errorMessage = ''; // Clear error if valid
      });
      return true;
    } else {
      setState(() {
        errorMessage = 'The total number of questions must equal $selectedQuestions.';
      });
      return false;
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
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
        ],
        title: const Text(
          'Quiz Maker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    Navigator.pop(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(05.0),
                  child: Text('Settings',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.white),
                  title: const Text("Upload PDF",
                      style: TextStyle(color: Colors.white)),
                  onTap: pickAndUploadPDF,
                ), // Default value

                ListTile(
                  leading: const Icon(Icons.format_list_numbered,
                      color: Colors.white),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("No. of Questions",
                          style: TextStyle(color: Colors.white)),
                      DropdownButton<int>(
                        value: selectedQuestions,
                        dropdownColor: Colors.black,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        items: List.generate(20, (index) {
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text((index + 1).toString()),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedQuestions = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Checkbox(
                    value: isShortChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isShortChecked = value!;
                      });
                    },
                  ),
                  title: TextField(
                    controller: shortController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Short Questions",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Checkbox(
                    value: isMCQsChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isMCQsChecked = value!;
                      });
                    },
                  ),
                  title: TextField(
                    controller: mcqController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "MCQs",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Checkbox(
                    value: isTrueFalseChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isTrueFalseChecked = value!;
                      });
                    },
                  ),
                  title: TextField(
                    controller: trueFalseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "True/False",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (errorMessage.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                // New "Generate" button
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.play_arrow, color: Colors.white),
                  title: const Text("Generate", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    if (isValidQuestionCount()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating quiz...')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 05),
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
                      messages.addAll([
                          {'sender': 'bot', 'text': 'Hi, Welcome to Quiz Maker'},
                          {'sender': 'bot', 'text': 'I can generate short questions, mcqs and true/false for you'}
                      ]);
                    });
                    Navigator.pop(context);
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'PDF: $pdfName',
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis, // Ensures text does not overflow
                          maxLines: 1, // Keeps it to a single line
                        ),
                      ),
                    ),


                  // IconButton(
                  //   icon: const Icon(Icons.file_copy, color: Colors.blue),
                  //   onPressed: pickAndUploadPDF,
                  // ),
                  // Expanded(
                  //   child: TextField(
                  //     controller: _controller,
                  //     style: const TextStyle(color: Colors.white),
                  //     decoration: const InputDecoration(
                  //       hintText: 'Type your message...',
                  //       hintStyle: TextStyle(color: Colors.white),
                  //       border: InputBorder.none,
                  //     ),
                  //   ),
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.send, color: Colors.blue),
                  //   onPressed: () {
                  //     sendEncodedPayload(selectedPdfPath);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
