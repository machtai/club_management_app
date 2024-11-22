import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/member.dart';
import 'package:club_management_app/services/member_api_service.dart';
import 'package:flutter/material.dart';
class MemberDetailScreen extends StatelessWidget {
  static String id = '/member_detail';
  final Member member;

  const MemberDetailScreen({Key? key, required this.member}) : super(key: key);

  _updateMember() async {
    try {
      await MemberApiService.updateMember(member);
      // Optionally, show a success message and return to the previous screen
    } catch (e) {
      // Handle error
      print("Error updating member: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/default_avatar.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '${member.user.split(" ")[0]} ${member.user.split(" ").length > 1 ? member.user.split(" ")[1] : ""}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    member.phone,
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 2),
                const SizedBox(height: 20),

                // Hiển thị thông tin chi tiết
                Row(
                  children: [
                    const Text(
                      'Email: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.email,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Lớp: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.lop,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Mã sinh viên: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.mssv,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Địa chỉ: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.addr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
               Row(
  children: [
    const Text(
      'Ngày tham gia: ',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Flexible(
      child: Text(
        member.join_clb_at ?? 'N/A',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu text quá dài
      ),
    ),
  ],
),

                const SizedBox(height: 25),
                const Divider(thickness: 2),
                const SizedBox(height: 25),
                const Text(
                  'Events:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: member.events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(member.events[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
