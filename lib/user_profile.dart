import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile.dart';


class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          centerTitle: true,
          title: const Text(
            "User Profile",
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          //   TODO: Add actions here
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.red,
                ))
          ],
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Consumer<AuthServiceProvider>(
              builder: (_, authProvider, __) {
                final user = authProvider.user;
                if (user == null) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hero(tag: "user-profile-image" , child:Image.asset("assets/images/text_on_board_image.PNG")),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.firstName ?? "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 26,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user.lastName ?? "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 24,
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(user.email ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                              )),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
        ),
    ),
    ]
    );
  }
}
