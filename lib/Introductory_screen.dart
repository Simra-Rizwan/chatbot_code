import 'package:custfyp/login_screen.dart';
import 'package:flutter/material.dart';

class IntroductoryScreen extends StatefulWidget {
  @override
  State<IntroductoryScreen> createState() => _IntroductoryScreenState();
}

class _IntroductoryScreenState extends State<IntroductoryScreen> {
  final List<Map<String, String>> features = [
    {
      'title': 'Chatbot',
      'quote': '"Ask your questions, and let the AI guide you to the answers."',
    },
    {
      'title': 'Summarizer',
      'quote': '"Turn lengthy texts into concise insights with ease."',
    },
    {
      'title': 'Quiz Maker',
      'quote': '"Transform knowledge into challenges for better learning."',
    },
    {
      'title': 'Prepare with Teacher Pet',
      'quote': '"Your companion for smarter, faster preparation."',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background gradient container
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7F00FF),
                Color(0xFFE100FF),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Set the Scaffold background to transparent
          body: SafeArea(
            child: SingleChildScrollView(
              // backgroundColor: Colors.transparent, // Ensure the background remains transparent
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Teacher Pet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final feature = features[index];
                        return Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                feature['quote']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10), // Add some space at the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
        // Floating Action Button
        Positioned(
          bottom: 40,
          left: screenWidth / 2 - 100, // Center the button with a larger offset
          child: Container(
            width: 200, // Set a specific width for the button
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to Login screen using Navigator.push()
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '👉 Let\'s Start',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
