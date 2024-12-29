import 'package:custfyp/Introductory_screen.dart';
import 'package:custfyp/chatbot_screen.dart';
import 'package:custfyp/dashboard_com.dart';
import 'package:custfyp/email_verification_screen.dart';
import 'package:custfyp/models/user_model.dart';
import 'package:custfyp/on_board_screen.dart';
import 'package:custfyp/premium_screen.dart';
import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          bool hasSeenOnboarding =
              sl<SharedPreferences>().getBool("hasSeenOnboarding") ?? false;
          if (true) {
            if (snapshot.hasData) {
              // print(snapshot.hasData);
              final authProvider = context.read<AuthServiceProvider>();
              authProvider.fetchUserData();
              final UserModel? user = authProvider.user;
              // TODO: Implement email verification
              print(snapshot.data?.emailVerified);

              if (snapshot.data?.emailVerified ?? false) {
                if (user?.subscribePlan == null) {
                  // return const Dashboard();
                  // return  ChatBotScreen();
                  return WelcomeScreen();
                } else {
                  return const PremiumScreen();
                }
              } else {
                return const EmailVerificationScreen();
              }

            } else {
              // return const LoginScreen();
              return  IntroductoryScreen();
            }
          } else {
            return OnBoardScreen();
          }
        });
  }
}
