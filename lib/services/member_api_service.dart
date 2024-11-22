import 'dart:convert';
import 'package:club_management_app/controllers/auth_controller.dart';
import 'package:club_management_app/models/member.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class MemberApiService {
  static const String url = "https://ql-clb.onrender.com/api";
  static final AuthController authController = Get.find<AuthController>();

  static final String? clubid = authController.currentUser.value?.clbId;
  static Future<List<Member>> getMembersByClbId() async {
    try {
      final response = await http.post(
        Uri.parse('$url/get/clb/member'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'clb_id': clubid}),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Member.fromJson(json)).toList();
      } else {
        print("Lỗi khi lấy danh sách thành viên: ${response.statusCode}");
        throw Exception("Không thể tải danh sách thành viên");
      }
    } catch (e) {
      print("Lỗi ngoại lệ: $e");
      throw Exception("Đã xảy ra lỗi trong quá trình tải danh sách thành viên");
    }
  }

  static Future<void> updateMember(Member member) async {
    final response = await http.put(
      Uri.parse('$url/${member.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'studentId': member.id,
        'name': member.user,
        'phone': member.phone,
        'events': member.events,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update member");
    }
  }

  static Future<void> deleteMember(String mssv) async {
    final token = authController.token.value;
    final response = await http.post(
      Uri.parse('$url/delete/clb/member'),
      headers: {
        'Content-Type': 'application/json',
        'Token': '$token', // Thêm token vào header
      },
      body: json.encode({
        'mssv': mssv,
        'clb_id': clubid,
      }),
    );

    if (response.statusCode == 200) {
      await getMembersByClbId(); // Refresh list
    }
  }

  // Phương thức tạo mới thành viên
  // Hàm thêm thành viên vào CLB dựa trên MSSV và clb_id
  Future<void> addMemberToClb(String mssv) async {
    final token = authController.token.value;
    final response = await http.post(
      Uri.parse('$url/add/clb/member'),
      headers: {
        'Content-Type': 'application/json',
        'Token': '$token', // Thêm token vào header
      },
      body: json.encode({
        'mssv': mssv,
        'clb_id': clubid,
      }),
    );

    if (response.statusCode == 200) {
      await getMembersByClbId(); // Refresh list
    }
  }

  Future<List<Map<String, dynamic>>> getUserDontHaveClbIDList() async {
    final response = await http.get(Uri.parse('$url/get/user'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((user) => Map<String, dynamic>.from(user)).toList();
    } else {
      throw Exception('Lỗi khi lấy danh sách người dùng');
    }
  }
}
