import 'package:dashboard_app/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => DashboardProvider(),
    child:MaterialApp(
      title: 'Analytics Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0E2238),
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF3EB1C8),
          primary: Color(0xFF0E2238),
          secondary: Color(0xFF3EB1C8),
          background: Color(0xFFF5F8FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E2238),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF011638)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3EB1C8)),
          ),
          labelStyle: TextStyle(color: Color(0xFF011638)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF3EB1C8),
        ),
      ),
      home: const LoginPage(),
    ));
  }
}
