import 'package:club_management_app/admin_screen.dart';
import 'package:club_management_app/home_screen.dart';
import 'package:club_management_app/screens/authentication/forgot_password.dart';
import 'package:club_management_app/screens/authentication/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:club_management_app/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  String? username;
  String? password;
  bool _showSpinner = false;

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.06;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/images/background.png'),
          ),
          // Background and login UI
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Login', style: TextStyle(fontSize: fontSize * 1.2)),
                // Username and password fields
                Column(
                  children: [
                    TextField(
                      onChanged: (value) => username = value,
                      decoration: InputDecoration(hintText: 'Username', labelText: 'Username'),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => password = value,
                      decoration: InputDecoration(hintText: 'Password', labelText: 'Password'),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, ForgotPassword.id),
                        child: Text('Forgot Password?', style: TextStyle(fontSize: fontSize * 0.8, color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() => _showSpinner = true);

                    // Validate username and password
                    if (username == null || username!.isEmpty || password == null || password!.isEmpty) {
                      Get.snackbar(
                        "Validation Error",
                        "Vui lòng nhập đầy đủ thông tin",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      setState(() => _showSpinner = false);
                      return;
                    }

                    // Perform login
                    bool loginSuccess = await authController.login(username!, password!);

                    setState(() => _showSpinner = false);

                    if (loginSuccess) {
                      // Check role and navigate accordingly
                      if (authController.role.value == 1) {
                        Get.snackbar(
                          "Login Successful",
                          "Chào mừng quản trị viên",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Navigator.pushNamed(context, AdminScreen.id);
                      } else {
                        Get.snackbar(
                          "Login Successful",
                          "Chào mừng bạn đã đăng nhập",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                    } else {
                      // Show error message if login failed
                      Get.snackbar(
                        "Login Failed",
                        "Sai tài khoản hoặc mật khẩu",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Text('Login', style: TextStyle(fontSize: fontSize, color: Colors.white)),
                ),
                if (_showSpinner)
                  Center(child: SpinKitCircle(color: Colors.blueAccent, size: 50.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 1.0,
                        width: 60.0,
                        color: Colors.black87,
                      ),
                    ),
                    Text('Or', style: TextStyle(fontSize: fontSize)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 1.0,
                        width: 60.0,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Google login logic here
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/google.png', height: 40.0),
                            SizedBox(width: 8.0),
                            Text('Google', style: TextStyle(fontSize: fontSize * 0.7)),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Facebook login logic here
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/facebook.png', height: 40.0),
                            SizedBox(width: 8.0),
                            Text('Facebook', style: TextStyle(fontSize: fontSize * 0.7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?', style: TextStyle(fontSize: fontSize)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(' Sign Up', style: TextStyle(fontSize: fontSize, color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
