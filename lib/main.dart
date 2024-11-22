import 'package:club_management_app/admin_screen.dart';
import 'package:club_management_app/profile_screen.dart';
import 'package:club_management_app/screens/statistics/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'splash_screen/splash_screen.dart';

import 'package:club_management_app/screens/event/event_management_screen.dart';
import 'package:club_management_app/screens/authentication/forgot_password.dart';
import 'package:club_management_app/screens/authentication/login_screen.dart';
import 'package:club_management_app/screens/authentication/register_screen.dart';
import 'package:club_management_app/home_screen.dart';
import 'package:club_management_app/screens/member/member_management_screen.dart';
void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Changed to GetMaterialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Abel',
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set SplashScreen as home
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterPage.id: (context) => RegisterPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        HomeScreen.id: (context) => HomeScreen(),
        MemberManagementScreen.id: (context) => MemberManagementScreen(clbId: '',),
        EventManagementScreen.id: (context) => EventManagementScreen(),
        AdminScreen.id: (context) => AdminScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        DashboardScreen.id: (context) => DashboardScreen()
      },
    );
  }
}