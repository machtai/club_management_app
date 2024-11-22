import 'package:club_management_app/controllers/auth_controller.dart';
import 'package:club_management_app/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav extends StatefulWidget {
   
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}
final AuthController authController = Get.find();
final user = authController.currentUser.value;
class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 246, 253, 247),
                    minimumSize: Size(100, 50),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.home, color: Colors.blue),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Trang chủ',
                        style: 
                          TextStyle(color: Colors.black,)
                        
                      ),
                    ],
                  ),
                  onPressed: () {
                    // Use pushReplacementNamed to replace the current screen
               if (authController.role.value == 1) {
                        Navigator.pushReplacementNamed(context, "/AdminScreen");
                      } else {
                         Navigator.pushReplacementNamed(context, "/HomeScreen");
                      }
                           
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.blue),
                      onPressed: () {
                        // Add action for notifications
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, ProfileScreen.id);

                      },
                      icon: Icon(Icons.person, color: Colors.blue),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
