import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:club_management_app/screens/authentication/login_screen.dart';
import 'package:club_management_app/splash_screen/shape_image_positioned.dart'; // Nếu cần import

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final double _buttonWidth = 100;

  late AnimationController _buttonScaleController;
  late Animation<double> _buttonScaleAnimation;

  void _initButtonScale() {
    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1, end: .9).animate(_buttonScaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _buttonWidthController.forward();
        }
      });
  }

  late AnimationController _buttonWidthController;
  late Animation<double> _buttonWidthAnimation;

  void _initButtonWidth(double screenWidth) {
    _buttonWidthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _buttonWidthAnimation = Tween<double>(begin: _buttonWidth, end: screenWidth)
        .animate(_buttonWidthController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _positionedController.forward();
        }
      });
  }

  late AnimationController _positionedController;
  late Animation<double> _positionedAnimation;

  void _initPositioned(double screenWidth) {
    _positionedController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _positionedAnimation = Tween<double>(begin: 10, end: screenWidth - 160)
        .animate(_positionedController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _screenScaleController.forward();
        }
      });
  }

  late AnimationController _screenScaleController;
  late Animation<double> _screenScaleAnimation;

  void _initScreenScale() {
    _screenScaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _screenScaleAnimation =
        Tween<double>(begin: 1, end: 24).animate(_screenScaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child:  LoginScreen(),
                      type: PageTransitionType.fade));
            }
          });
  }

  @override
  void initState() {
    _initButtonScale();
    _initScreenScale();
    super.initState();
  }

  @override
  void dispose() {
    _buttonScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    _initButtonWidth(screenWidth);
    _initPositioned(screenWidth);

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemFill,
        child: Stack(
          children: [
            // Đặt ảnh nền dưới cùng
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover, // Đảm bảo ảnh phủ kín màn hình
              ),
            ),
            const ShapeImagePositioned(), // Hình nền động
            const ShapeImagePositioned(top: -100),
            const ShapeImagePositioned(top: -150),
            const ShapeImagePositioned(top: -200),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'We promise you will have the most fuss-free time with us ever',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(.8),
                        fontSize: 20,
                        height: 1.5),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  AnimatedBuilder(
                    animation: _buttonScaleController,
                    builder: (_, child) => Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: CupertinoButton(
                        onPressed: () {
                          _buttonScaleController.forward();
                        },
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _buttonWidthController,
                              builder: (_, child) => Container(
                                height: _buttonWidth,
                                width: _buttonWidthAnimation.value,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemIndigo
                                      .withOpacity(.7),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _positionedController,
                              builder: (_, child) => Positioned(
                                top: 10,
                                left: _positionedAnimation.value,
                                child: AnimatedBuilder(
                                  animation: _screenScaleController,
                                  builder: (_, child) => Transform.scale(
                                    scale: _screenScaleAnimation.value,
                                    child: Container(
                                      height: _buttonWidth - 20,
                                      width: _buttonWidth - 20,
                                      decoration: const BoxDecoration(
                                        color: CupertinoColors.systemIndigo,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: _screenScaleController.isDismissed
                                          ? const Icon(
                                              CupertinoIcons.chevron_forward,
                                              color: CupertinoColors.white,
                                              size: 35,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
