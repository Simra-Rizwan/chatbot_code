import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/signup_screen.dart';
import 'package:custfyp/widgets/auth_text_field.dart';
import 'package:custfyp/widgets/password_text_field.dart';
import 'package:custfyp/widgets/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMeSelected = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  // Future<void> _signIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //     if (userCredential.user != null) {
  //       Navigator.pushNamed(context, '/home');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       _errorMessage = e.message;
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Login',
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    AuthTextField(
                      hintText: "Email",
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
                      height: 20,
                    ),

                    PasswordTextField(
                        hintText: "Password",
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
                    const SizedBox(
                      height: 15,
                    ),
                    //const SizedBox(height: 15),
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
                          "Remember Login",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
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
                                  "Login",
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
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const SignUpScreen(),
                            //   ),
                            // );
                            Navigator.pushNamed(
                              context,
                              SignUpScreen.route,
                            );
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
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

                          // const SizedBox(height: 50),
                          // TextFormField(
                          //   controller: _emailController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Email',
                          //     labelStyle: const TextStyle(color: Colors.white),
                          //     filled: true,
                          //     fillColor: Colors.white.withOpacity(0.2),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //       borderSide: BorderSide.none,
                          //     ),
                          //     contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          //   ),
                          //   style: const TextStyle(color: Colors.white),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your email';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(height: 20),
                          // TextFormField(
                          //   controller: _passwordController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Password',
                          //     labelStyle: const TextStyle(color: Colors.white),
                          //     filled: true,
                          //     fillColor: Colors.white.withOpacity(0.2),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //       borderSide: BorderSide.none,
                          //     ),
                          //     contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          //   ),
                          //   style: const TextStyle(color: Colors.white),
                          //   obscureText: true,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your password';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(height: 20),
                          // if (_errorMessage != null)
                          //   Text(
                          //     _errorMessage!,
                          //     style: const TextStyle(color: Colors.red),
                          //   ),
                          // const Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     'Forgotten Password?',
                          //     style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                          //   ),
                          // ),
                          // const SizedBox(height: 40),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     if (_formKey.currentState!.validate()) {
                          //       _signIn();
                          //     }
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white.withOpacity(0.2),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(vertical: 20),
                          //   ),
                          //   child: _isLoading
                          //       ? const CircularProgressIndicator(
                          //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          //   )
                          //       : const Text(
                          //     'Login',
                          //     style: TextStyle(color: Colors.white, fontSize: 18),
                          //   ),
                          // ),
                          // const SizedBox(height: 20),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       Navigator.pushNamed(context, '/createAccount');
                          //     },
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.zero,
                          //       alignment: Alignment.centerLeft,
                          //     ),
                          //     child: const Text(
                          //       'Create an Account',
                          //       style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                          //     ),
                          //   ),
                          // ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    )));
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      await context.read<AuthServiceProvider>().login(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          );
    }
  }
}
