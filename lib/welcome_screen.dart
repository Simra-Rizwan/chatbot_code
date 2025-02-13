import 'package:custfyp/chatbot_screen.dart';
import 'package:custfyp/quizmaker_screen.dart';
import 'package:custfyp/summarizer_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> welcomeItems = [
    {
      'title': 'Welcome to Chatbot',
      'image': 'assets/images/chatbot.webp',
    },
    {
      'title': 'Welcome to Summarizer',
      'image': 'assets/images/summarizer.webp',
    },
    {
      'title': 'Quiz Maker',
      'image': 'assets/images/quiz_maker.webp',
    },
    {
      'title': "Prepare with Teacher's Pet",
      'image': 'assets/images/teachers_pet.webp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
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
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0), // Add top padding here
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/images/crown_image.png', // Use your crown image here
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: welcomeItems.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    final item = welcomeItems[index];
                    final bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });

                        if (item['title'] == 'Welcome to Chatbot') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatBotScreen(),
                            ),
                          );
                        }

                        if (item['title'] == 'Welcome to Summarizer') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummarizerScreen(),
                            ),
                          );
                        }
                        if (item['title'] == 'Quiz Maker') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizMakerScreen(),
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Image moved below the text
                                  Image.asset(
                                    item['image'],
                                    height: 70,
                                    width: 100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
