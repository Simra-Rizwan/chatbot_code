import "package:custfyp/providers/auth_service_provider.dart";
import "package:custfyp/widgets/unfocus_keyboard.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "login_screen.dart";
import "widgets/auth_text_field.dart";

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusKeyboard(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.08, 0.18),
              end: Alignment(0.92, 0.83),
              colors: [
                Color(0xFFB53BEC),
                Color(0xFFF887FF),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.getFont(
                            'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Enter your email ",
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AuthTextField(
                        hintText: "Enter Email Address",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter the valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _resetPassword();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize: const Size(350, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Verify Email",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot username?",
                            style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Let us Help",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context
          .read<AuthServiceProvider>()
          .resetPassword(email: _emailController.text, context: context);
    }
  }
}
