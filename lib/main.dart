import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'login_screen.dart';
import 'checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // හිරුණි, ඔයාගේ Firebase Project එකේ අලුත්ම Configuration එක මෙන්න
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAsqbjwylycHpjMOvCQQxzRJOmcSr_9Oy0", // ඔයා Unrestrict කරපු Key එක
        authDomain: "secrets-of-fashion.firebaseapp.com",
        projectId: "secrets-of-fashion",
        storageBucket: "secrets-of-fashion.firebasestorage.app",
        messagingSenderId: "142807900506",
        appId: "1:142807900506:web:b7a53c144b8897679f1363",
        measurementId: "G-R6HHDWR0L1",
      ),
    );
    print("Firebase Initialize Success! ✨");
  } catch (e) {
    print("Firebase Error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secrets of Fashion',
      theme: ThemeData(
        // ඔයාගේ Brand එකට ගැලපෙන රන්වන් පැහැය
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4AF37)),
        useMaterial3: true,
      ),
      home: const LoginScreen(), 
    );
  }
}