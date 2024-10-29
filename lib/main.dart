import 'package:custfyp/providers/auth_service_provider.dart';
import 'package:custfyp/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:custfyp/login_screen.dart';
import 'package:custfyp/signup_screen.dart';
import 'package:custfyp/dashboard_com.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart';
import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   initializeDependencies();
  await FireBaseNotifications().initializeFireBase();// Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => AuthServiceProvider()), // Provide AuthProvider
    ],
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Teacher's Pet",
      // routerConfig: RouterConfig(routerDelegate: RouterDelegate()),
      routes: appRoutes,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),

      home: const SplashScreen(),
    ),
    );
  }
}

final Map<String, Widget Function(BuildContext)> appRoutes = {
  SignUpScreen.route: (_) => const SignUpScreen(),
  '/login': (_) => const Scaffold(
        body: LoginScreen(),
      ),
  '/home': (_) => const Scaffold(
        body: Dashboard(),
      ),
};
