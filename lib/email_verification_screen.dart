import 'dart:async';
import 'package:custfyp/dashboard_com.dart';
import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/widgets/unfocus_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});
  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  void checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Verified"),
      ));
      timer?.cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  const Dashboard()));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
    child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              const Center(
                  child: Text(
                    "Send Email",
                    style: TextStyle(
                        color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(child:
                  Consumer<AuthServiceProvider>(builder: (_, authProvider, __) {
                    return Text(
                      "We have send an Email on ${authProvider.user?.email} ",
                      textAlign: TextAlign.center,
                    );
                  }))),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    "Verified Email",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                    onPressed: () {
                      try {
                        FirebaseAuth.instance.currentUser?.sendEmailVerification();
                      } catch (e) {
                        print("error");
                      }
                    },
                    child: const Text(
                      "Resend Email",
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    )),
              )
            ],
          )),
    )
      )
    );
  }
}
