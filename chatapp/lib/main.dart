import 'dart:ui';

import 'package:chat_app_flutter/screen/auth_screen.dart';
import 'package:chat_app_flutter/screen/chat_screen.dart';
import 'package:chat_app_flutter/screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chat app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.indigo,
        accentColor: Color.fromRGBO(255, 170, 0, 1.0),
        accentColorBrightness: Brightness.light,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Color.fromRGBO(255, 170, 0, 1.0),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, usersnapshot) {
            if (usersnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else if (usersnapshot.hasData) {
              return ChatScreen();
            } else {
              return AuthScreen();
            }
          }),
      routes: {
        ChatScreen.routeName: (ctx) => ChatScreen(),
      },
    );
  }
}
