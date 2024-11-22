import 'package:club_management_app/controllers/auth_controller.dart';
import 'package:club_management_app/screens/authentication/login_screen.dart';
import 'package:club_management_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:validators/validators.dart' as validator;
class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());

  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;

  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  bool _wrongName = false;
  bool _wrongPhone = false;
  bool _wrongAddress = false;

  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';
  String _nameText = 'Please enter your full name';
  String _phoneText = 'Please enter a valid phone number';
  String _addressText = 'Please enter your address';

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) _validateName();
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) _validateEmail();
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) _validatePassword();
    });
    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) _validatePhone();
    });
    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) _validateAddress();
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _wrongName = name == null || name!.isEmpty;
      _nameText = _wrongName ? 'Please enter your full name' : '';
    });
  }

  void _validateEmail() {
    setState(() {
      if (email == null || email!.isEmpty) {
        _wrongEmail = true;
        _emailText = 'Please enter your email address';
      } else if (!validator.isEmail(email!)) {
        _wrongEmail = true;
        _emailText = 'Please enter a valid email address';
      } else {
        _wrongEmail = false;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      if (password == null || password!.isEmpty) {
        _wrongPassword = true;
        _passwordText = 'Please enter your password';
      } else if (!validator.isLength(password!, 6)) {
        _wrongPassword = true;
        _passwordText = 'Password must be at least 6 characters';
      } else {
        _wrongPassword = false;
      }
    });
  }

  void _validatePhone() {
    setState(() {
      _wrongPhone = phone == null || phone!.isEmpty || !validator.isNumeric(phone!);
      _phoneText = _wrongPhone ? 'Please enter a valid phone number' : '';
    });
  }

  void _validateAddress() {
    setState(() {
      _wrongAddress = address == null || address!.isEmpty;
      _addressText = _wrongAddress ? 'Please enter your address' : '';
    });
  }
Future<void> _registerUser() async {
  _validateName();
  _validateEmail();
  _validatePassword();
  _validatePhone();
  _validateAddress();

  if (!_wrongName && !_wrongEmail && !_wrongPassword && !_wrongPhone && !_wrongAddress) {
    setState(() {
      _showSpinner = true;
    });
  
    final success = await _authController.register(
      name!,        // user
      password!,    // password
      email!,       // email
      phone!,       // phone
      address!,     // address
    );

    setState(() {
      _showSpinner = false;
    });

    if (success) {
      Get.snackbar("Registration Successful", "You can now login");
      Navigator.pushNamed(context, LoginScreen.id);
    } else {
      Get.snackbar("Registration Failed", "Please check your information");
    }
  }
}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/images/background.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20),
                Text('Register', style: TextStyle(fontSize: screenWidth * 0.12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lets get', style: TextStyle(fontSize: screenWidth * 0.08)),
                    Text('you on board', style: TextStyle(fontSize: screenWidth * 0.08)),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        focusNode: _nameFocusNode,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          labelText: 'Full Name',
                          errorText: _wrongName ? _nameText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _wrongEmail ? _emailText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _wrongPassword ? _passwordText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          errorText: _wrongPhone ? _phoneText : null,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        focusNode: _addressFocusNode,
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (value) {
                          address = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Address',
                          errorText: _wrongAddress ? _addressText : null,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: _showSpinner ? CircularProgressIndicator() : Text("Register"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
