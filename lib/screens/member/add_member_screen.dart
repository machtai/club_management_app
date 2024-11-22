import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/member.dart';
import 'package:club_management_app/services/member_api_service.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  static String id = '/add_event';
  final String clbId;

  const AddMemberScreen({Key? key, required this.clbId}) : super(key: key);

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String mssv = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> userList = [];
  Map<String, dynamic>? selectedMember;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  // Hàm lấy danh sách người dùng từ API chưa có clb
  _fetchUserList() async {
    try {
      List<Map<String, dynamic>> users =
          await MemberApiService().getUserDontHaveClbIDList();
      setState(() {
        userList = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi lấy danh sách người dùng: $e"),
      ));
    }
  }

  // Hàm tìm thông tin thành viên từ danh sách
  _getMemberDetails(String mssv) {
    return userList.firstWhere((user) => user['mssv'] == mssv,
        orElse: () => {});
  }

  // Hàm thêm thành viên vào CLB
  _addMember() async {
    if (mssv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mã số sinh viên không được bỏ trống"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Start loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to add the member to the club
      await MemberApiService().addMemberToClb(mssv);

      // After successfully adding, fetch the updated list of members for the club
      List<Member> updatedMembers = await MemberApiService.getMembersByClbId();

      // After data is fetched, stop loading
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Thành viên đã được thêm vào CLB!"),
        backgroundColor: Colors.green,
      ));

      // After successfully adding, pop the current screen and return to the previous one with updated members list
      Navigator.pop(context, updatedMembers);
    } catch (e) {
      // Stop loading in case of an error
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi thêm thành viên: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return userList
                              .where((user) => user['mssv']
                                  .toLowerCase()
                                  .contains(textEditingValue.text.toLowerCase()))
                              .map((user) => user['mssv'] as String);
                        },
                        onSelected: (String selectedMssv) {
                          setState(() {
                            mssv = selectedMssv;
                            selectedMember = _getMemberDetails(selectedMssv);
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: _controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(labelText: 'Mã sinh viên'),
                            onChanged: (value) {
                              setState(() {
                                mssv = value;
                                selectedMember = _getMemberDetails(value);
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      if (selectedMember != null && selectedMember!.isNotEmpty) ...[
                        Text('Tên: ${selectedMember!['user']}'),
                        Text('Email: ${selectedMember!['email']}'),
                        Text('Lớp: ${selectedMember!['lop']}'),
                        Text('Số điện thoại: ${selectedMember!['phone']}'),
                        SizedBox(height: 20),
                      ],
                      ElevatedButton(
                        onPressed: _addMember,
                        child: Text('Thêm vào CLB'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
