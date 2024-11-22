import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/services/member_api_service.dart';
import 'package:flutter/material.dart';
import '../../models/member.dart';
import 'member_detail_screen.dart';
import 'add_member_screen.dart';

class MemberManagementScreen extends StatefulWidget {
  static String id = '/members';
  final String clbId;

  MemberManagementScreen({required this.clbId});

  @override
  State<MemberManagementScreen> createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends State<MemberManagementScreen> {
  List<Member> members = [];
  List<Member> filteredMembers = [];
  bool isAscending = true;
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  _loadMembers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      members = await MemberApiService.getMembersByClbId();
      filteredMembers = List.from(members);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error loading members: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDelete(String studentId) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc chắn muốn xóa thành viên này không?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Xóa"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteMember(studentId);
    }
  }

  _deleteMember(String studentId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await MemberApiService.deleteMember(studentId);
      await _loadMembers();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Xóa thành viên thành công!"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi khi xóa thành viên: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _searchMember(String query) {
    setState(() {
      filteredMembers = members
          .where((member) =>
              member.user.toLowerCase().contains(query.toLowerCase()) ||
              member.mssv.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  _sortMembers() {
    setState(() {
      filteredMembers.sort((a, b) =>
          isAscending ? a.mssv.compareTo(b.mssv) : b.mssv.compareTo(a.mssv));
      isAscending = !isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm thành viên...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(20),
                                right: Radius.circular(20),
                              ),
                            ),
                          ),
                          onChanged: _searchMember,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          isAscending ? Icons.sort_by_alpha : Icons.sort,
                        ),
                        onPressed: _sortMembers,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final updatedMembers = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddMemberScreen(clbId: widget.clbId),
                            ),
                          );

                          if (updatedMembers != null &&
                              updatedMembers is List<Member>) {
                            setState(() {
                              members = updatedMembers;
                              filteredMembers = List.from(members);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredMembers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/default_avatar.png') as ImageProvider,
                        ),
                        title: Text(member.user),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mã sinh viên: ${member.mssv}"),
                            Text("Lớp: ${member.lop}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _confirmDelete(member.mssv);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MemberDetailScreen(member: member),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
