import 'dart:async'; // Thêm thư viện Timer
import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> news = [
    {
      'image': 'assets/images/c1.jpg',
      'title': 'Cuộc thi Tìm kiếm tài năng Ngôn ngữ Trung Quốc năm 2024',
      'description': 'Cuộc thi Tìm kiếm tài năng Ngôn ngữ Trung Quốc các trường khu vực phía Nam năm 2024.'
    },
    {
      'image': 'assets/images/c2.jpg',
      'title': 'Cuộc thi Finance & Accounting Arena 2024',
      'description': 'Cuộc thi Finance & Accounting Arena 2024 chính thức đi đến hồi kết!'
    },
    {
      'image': 'assets/images/c3.jpg',
      'title': 'Giao lưu với Trường Đại học Khoa học Kỹ thuật Quốc lập Vân Lâm, Đài Loan',
      'description': 'Thông tin về tin tức 3.'
    },
    {
      'image': 'assets/images/c4.jpg',
      'title': 'Chung kết Cuộc thi Hùng biện tiếng Hàn lần 10 ',
      'description': 'Nhằm tạo ra sân chơi bổ ích, cho sinh viên được học hỏi, giao lưu và tiếp cận với nền văn hóa Hàn Quốc '
    },
    {
      'image': 'assets/images/c5.jpg',
      'title': 'Workshop "Giảm Stress - Cân bằng giữa công việc và cuộc sống"',
      'description': 'Bạn đang cảm thấy áp lực từ công việc, học tập và cuộc sống cá nhân khiến bạn khó cân bằng?'
    },
   
  ];

  bool _showMoreNews = false;

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
     
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trường Đại học Lạc Hồng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.blue,
                  ),
                ),
                // Slider tự động trượt
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('assets/images/c${index + 1}.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Quick Access IconButtons
                Text(
                  'Chức năng quản lý',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconButton(Icons.people, 'Thành viên', '/members'),
                    _buildIconButton(Icons.event, 'Sự kiện', '/events'),
                    _buildIconButton(Icons.bar_chart, 'Dashboard', '/dashboard'),
                  ],
                ),
                SizedBox(height: 20),
                // News Section
                Text(
                  'Tin tức',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: _buildNewsList(),
                ),
                if (_newsToShow() < news.length)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showMoreNews = !_showMoreNews;
                      });
                    },
                    child: Text(
                      _showMoreNews ? 'Show Less' : 'Show More',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, String routeName) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          icon: Icon(icon, size: 40),
        ),
        Text(label),
      ],
    );
  }

  List<Widget> _buildNewsList() {
    return news
        .take(_newsToShow())
        .map((newsItem) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Image.asset(
                    newsItem['image']!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    newsItem['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(newsItem['description']!),
                ),
              ),
            ))
        .toList();
  }

  int _newsToShow() {
    return _showMoreNews ? news.length : 3;
  }
}
