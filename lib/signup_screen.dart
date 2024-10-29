import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/widgets/auth_text_field.dart';
import 'package:custfyp/widgets/password_text_field.dart';
import 'package:custfyp/widgets/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String route = "/createAccount";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isRememberMeSelected = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusKeyboard(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment(-0.08, 0.18),
              end: Alignment(0.92, 0.83),
              colors: [
                Color(0xFFB53BEC),
                Color(0xFFF887FF),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),

              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        'Create new Account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Text(
                      'First Name',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        hintText: "Simra",
                        obscureText: false,
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    Text(
                      'Last Name',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        hintText: "Rizwan",
                        obscureText: false,
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    Text(
                      'Email',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AuthTextField(
                        hintText: "xyz@gmail.com",
                        obscureText: false,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Please enter the valid email address';
                          }
                          return null;
                        }),
                    const SizedBox(height: 15),
                    Text(
                      'PASSWORD',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                        hintText: "••••••••",
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else {
                            if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(value)) {
                              return 'Enter valid password';
                            } else {
                              return null;
                            }
                          }
                        }),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Checkbox(
                          value: isRememberMeSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              isRememberMeSelected = !isRememberMeSelected;
                            });
                          },
                        ),
                        const Text(
                          "I agree Terms and conditions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signup();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Consumer<AuthServiceProvider>(
                            builder: (_, provider, __) {
                          return provider.isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Sign Up",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20,
                                  ),
                                );
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.normal,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontStyle: FontStyle.normal,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                                const SizedBox(height: 2),
                                const Align(
                alignment: Alignment.center,
                child: Text(
                  "Or Continue with",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                  ),
                ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                alignment: Alignment.center,
                    child: Consumer<AuthServiceProvider>(
                        builder: (_, authProvider, __) {
                          return GestureDetector(
                            onTap: () {
                              authProvider.signInWithGoogle();
                            },
                            child: Image.asset(
                              "assets/images/google_icon.png",
                              width: 200,
                              height: 70,
                            ),
                          );
                        }),
                                ),
                                ]
                              ),
          ),
        ),
      ),
    )
      )
    );
  }

  void _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<AuthServiceProvider>().signUp(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          );

    }
  }
}
