import 'package:carousel_slider/carousel_slider.dart';
import 'package:custfyp/widgets/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'login_screen.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int _currentIndex = 0;  // Track the current index of the image

  @override
  void initState() {
    super.initState();
    hasSeenOnboarding();
  }

  final List<String> imageList = [
    'assets/images/text_on_board_image.PNG',
    'assets/images/text_on_board_image2.png',
    'assets/images/chatbot_image.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 35.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            fixedSize: const Size(350, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Let's Get Started",
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: UnfocusKeyboard(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to The Teacher's Pet",
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // CarouselSlider for multiple images
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      autoPlayAnimationDuration: const Duration(milliseconds: 200),  // Shorter duration for faster transition
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;  // Update the current image index
                        });
                      },
                    ),
                    items: imageList.map((imagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                  // Add some space between the image and the dots
                  const SizedBox(height: 20),
                  // Dot indicators to show image position
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageList.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: 12.0,  // Increased size of the dots
                        height: 12.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void hasSeenOnboarding() {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl<SharedPreferences>().setBool("hasSeenOnboarding", true);
  }
}
