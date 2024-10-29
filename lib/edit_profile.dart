import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final UserModel? user = context.read<AuthServiceProvider>().user;
    if (user != null) {
      _firstNameController.text = user.firstName ?? "";
      _lastNameController.text = user.lastName ?? " ";
    }
  }

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
          "Edit Profile",
          style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30,),
                AuthTextField(
                  hintText: "First Name",
                  controller: _firstNameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                AuthTextField(
                  hintText: "Last Name",
                  controller: _lastNameController,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.blue, // Change the background color here
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Consumer<AuthServiceProvider>(
                      builder: (_, authProvider, __) {
                        return authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                          "Save Profile",
                          style: TextStyle(
                              fontSize: 16, color: Colors.black),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ))
    ),
    ]
    );
  }

  void _updateProfile() async {
    (await context.read<AuthServiceProvider>().updateUser(
        firstName: _firstNameController.text, lastName: _lastNameController.text,));
    Navigator.pop(
      context,
    );
  }
}

