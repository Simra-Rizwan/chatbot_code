import 'package:custfyp/services/dialog_service.dart';
import 'package:custfyp/subsciption_screen.dart';
import 'package:custfyp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _summary = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
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
          key: _scaffoldKey,
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: const [
              Icon(Icons.notifications, color: Colors.black, size: 30),
            ],
          ),
          drawer: const AppDrawer(),
          body:
              // SingleChildScrollView(
              // child:
              Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubsciptionScreen()), // Replace 'NextScreen' with your target screen widget
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Go Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Save 60% off on all domains\nPersonalised Features',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Summary:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: screenHeight * 0.1,
                          child: SingleChildScrollView(
                            child: Text(
                              _summary,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(
                      16.0), // Add padding inside the container
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() async {
                            _summary = await showInputDialog(context);
                          });
                        },
                        child: const Text(
                          "Summarize",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Add your onPressed function here
                        },
                        icon: const Icon(Icons.crop_free, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
        // ),
      ],
    );
  }
}
