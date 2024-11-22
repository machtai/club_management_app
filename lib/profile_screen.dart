import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:club_management_app/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  static String id = '/ProfileScreen';
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value;
    var role = "Giáo viên";

    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar and Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: 
                           AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.user ?? "Username",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // User Info Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileRow(Icons.email, 'Email', user?.email ?? 'Not provided'),
                      _buildProfileRow(Icons.phone, 'Phone', user?.phone ?? 'Not provided'),
                      _buildProfileRow(Icons.location_on, 'Address', user?.addr ?? 'Not provided'),
                      _buildProfileRow(Icons.badge, 'Staff ID (MSNV)', user?.msnv ?? 'Not provided'),
                      _buildProfileRow(Icons.group, 'Club ID (CLB ID)', user?.clbId ?? 'Not provided'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  authController.logout();
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
