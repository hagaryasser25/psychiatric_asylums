import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:psychiatric_asylums/screens/admin/add_asylum.dart';
import 'package:psychiatric_asylums/screens/admin/add_essay.dart';
import 'package:psychiatric_asylums/screens/admin/add_video.dart';
import 'package:psychiatric_asylums/screens/admin/admin_bottom.dart';
import 'package:psychiatric_asylums/screens/admin/admin_home.dart';
import 'package:psychiatric_asylums/screens/auth/admin_login.dart';
import 'package:psychiatric_asylums/screens/auth/login.dart';
import 'package:psychiatric_asylums/screens/auth/signUp.dart';
import 'package:psychiatric_asylums/screens/user/add_exp.dart';
import 'package:psychiatric_asylums/screens/user/bottom_user.dart';
import 'package:psychiatric_asylums/screens/user/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com'
              ? const BottomBarScreen()
              : const BottomBarUser(),
      routes: {
        SignupPage.routeName: (ctx) => SignupPage(),
        LoginPage.routeName: (ctx) => LoginPage(),
        UserHome.routeName: (ctx) => UserHome(),
        AddEssay.routeName: (ctx) => AddEssay(),
        AdminHome.routeName: (ctx) => AdminHome(),
        BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
        AddAsylum.routeName: (ctx) => AddAsylum(),
        AddVideo.routeName: (ctx) => AddVideo(),
        AdminLogin.routeName: (ctx) => AdminLogin(),
        BottomBarUser.routeName: (ctx) => BottomBarUser(),
      },
    );
  }
}
