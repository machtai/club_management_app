import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/controllers/clb_controller.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/clb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  static String id = '/AdminScreen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ClubController clubController = Get.put(ClubController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clubController.fetchClubs(); // Fetch clubs on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: Obx(() {
        if (clubController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (clubController.clubs.isEmpty) {
          return Center(child: Text("No clubs available"));
        }

        return ListView.builder(
          itemCount: clubController.clubs.length,
          itemBuilder: (context, index) {
            final club = clubController.clubs[index];
            return ListTile(
              title: Text("Tên câu lạc bộ: " + club.clbName, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Mô tả: " + club.description),
              onTap: () {
                _nameController.text = club.clbName;
                _descriptionController.text = club.description;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Edit Club'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Club Name'),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(labelText: 'Description'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          club.clbName = _nameController.text;
                          club.description = _descriptionController.text;
                          await clubController.updateClub(club);
                          Navigator.pop(context);
                        },
                        child: Text('Save'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await clubController.deleteClub(club.id!);
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _descriptionController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add New Club'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Club Name'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final newClub = Club(
                      clbName: _nameController.text,
                      leaderId: "",
                      description: _descriptionController.text,
                    );
                    await clubController.addClub(newClub);
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
