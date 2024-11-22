import 'dart:convert';

import 'package:club_management_app/models/user.dart';
import 'package:club_management_app/services/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString token = ''.obs;
  RxInt role = 0.obs;
  Rx<User?> currentUser = Rx<User?>(null);
  final AuthService _authService = AuthService();

  // Method to handle user registration
  Future<bool> register(
      String user, String pwd, String email, String phone, String addr) async {
    try {
      var response = await _authService.register(user, pwd, email, phone, addr);

      if (response['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print('Register failed: $e');
      return false;
    }
  }

  Future<bool> login(String user, String pwd) async {
    try {
      var response = await _authService.login(user, pwd);
      if (response['token'] != null) {
        token.value = response['token'];
        
        // Giải mã token và gán thông tin người dùng
        var decodedData = _decodeToken(response['token']);
        currentUser.value =
            User.fromJson(decodedData['data_user'][0]); // Gán vào currentUser
        role.value = currentUser.value?.role ?? 0;
        return true;
      }
      return false;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload);
  }

  void logout() {
    token.value = '';
    role.value = 0;
    currentUser.value = null;
    Get.offAllNamed('/LoginScreen');
  }
}
