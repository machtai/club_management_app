import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Image.asset(
              "assets/icon/icon.png", 
              width: 30, 
              height: 30, 
            ),
            onPressed: () {
              // Handle the icon press
            },
          ), 
          Text(
            "Club Management",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5, // Thêm khoảng cách chữ
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue, // Màu nền cho AppBar
      elevation: 10, // Thêm hiệu ứng bóng đổ
    );
  }

  // Cung cấp chiều cao cho AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Bạn có thể tùy chỉnh chiều cao nếu cần
}
