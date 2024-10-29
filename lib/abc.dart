// import 'package:custfyp/providers/auth_service_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:provider/provider.dart';
//
// // Define the SummarizeService class
// class SummarizeService {
//   final String baseUrl;
//
//   SummarizeService(this.baseUrl);
//
//   Future<String> summarizeText(String text, int sentenceCount) async {
//     final url = '$baseUrl/summarize';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'text': text, 'sentence_count': sentenceCount}),
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       return jsonResponse['summary'];
//     } else {
//       throw Exception('Failed to summarize text');
//     }
//   }
// }
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//
//   @override
//   _DashboardState createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final SummarizeService _summarizeService =
//   SummarizeService('http://192.168.43.121:5000');
//   String _summary = '';
//
//   Future<void> _showInputDialog(BuildContext context) async {
//     final TextEditingController textController = TextEditingController();
//     final TextEditingController lengthController = TextEditingController();
//
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // User must tap a button to close the dialog
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Insert Parameters'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 TextField(
//                   controller: textController,
//                   decoration:
//                   const InputDecoration(hintText: 'Enter text to summarize'),
//                   maxLines: 5,
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: lengthController,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter number of sentences'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Submit'),
//               onPressed: () async {
//                 final text = textController.text;
//                 final sentenceCount = int.tryParse(lengthController.text) ?? 5;
//                 if (text.isNotEmpty) {
//                   try {
//                     final summary = await _summarizeService.summarizeText(
//                         text, sentenceCount);
//                     setState(() {
//                       _summary = summary;
//                     });
//                   } catch (e) {
//                     // Handle error
//                     print("Something went Wrong $e");
//                   }
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // User can dismiss the dialog
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF7F00FF).withOpacity(0.8),
//           title: const Text(
//             'Confirm Logout',
//             style: TextStyle(color: Colors.white),
//           ),
//           content: const Text(
//             'Are you sure you want to log out?',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text(
//                 'No',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 'Yes',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/login');
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the size of the screen
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//         actions: const [
//           Icon(Icons.notifications, color: Colors.black, size: 30),
//         ],
//       ),
//       drawer: Consumer<AuthServiceProvider>(
//         builder: (_, authProvider, __) {
//           final user = authProvider.user;
//           return Drawer(
//             child: Column(
//               children: [
//                 UserAccountsDrawerHeader(
//                   accountName: Text(authProvider.displayName),
//                   accountEmail: Text(user?.email ?? 'guest@example.com'),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.account_circle_rounded),
//                   title: const Text("Personal Information"),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.chat),
//                   title: const Text("Chat"),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.logout),
//                   title: const Text("LogOut"),
//                   onTap: () {
//                     _showLogoutConfirmationDialog(context);
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurpleAccent,
//               padding: EdgeInsets.symmetric(
//                 vertical: screenHeight * 0.02,
//                 horizontal: screenWidth * 0.2,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             onPressed: () {
//               _showInputDialog(context);
//             },
//             child: const Center(
//               child: Text(
//                 'Summarize',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF7F00FF),
//               Color(0xFFE100FF),
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(height: screenHeight * 0.02),
//               Container(
//                 width: screenWidth * 0.9,
//                 padding: EdgeInsets.all(screenWidth * 0.05),
//                 decoration: BoxDecoration(
//                   color: Colors.deepPurple,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Go Premium',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Save 60% off on all domains\nPersonalised Features',
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Container(
//                   width: screenWidth * 0.9,
//                   padding: EdgeInsets.all(screenWidth * 0.05),
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Summary:',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       SizedBox(
//                         height: screenHeight * 0.1,
//                         child: SingleChildScrollView(
//                           child: Text(
//                             _summary,
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
