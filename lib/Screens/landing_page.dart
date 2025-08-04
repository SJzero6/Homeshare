import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:homeshare/Screens/Animations/slide_animation.dart';
import 'package:homeshare/Screens/tenantSreens/login.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late PageController _pageController;

  final List<Map<String, String>> _pages = [
    {
      "title": "Find \nyour space",
      "subtitle":
          "Discover the best bed spaces, rooms, partitions, and villas for rent across the UAE.",
    },
    {
      "title": "Live \ncomfortably",
      "subtitle":
          "Easily browse and connect with landlords to find your ideal living arrangement.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _widthAnimation = Tween<double>(begin: 60, end: 160).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _pageController=PageController();
  }

  // void _nextPage() {
  //   setState(() {
  //     _currentIndex++;
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? Colors.green
                : Theme.of(context).disabledColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
  //final textTheme = Theme.of(context).textTheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return SafeArea(
          child: Column(
            children: [
              // PageView section
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (index < 2) {
                      final page = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            Center(child: Image.asset('assets/Logo.png')),
                            const SizedBox(height: 20),
                            Text(
                              page["title"]!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              page["subtitle"]!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Center(child: Image.asset('assets/Logo.png')),
                            const SizedBox(height: 30),
                            Text(
                              "Select User Type",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildUserCard(
                                  title: "Tenant",
                                  imagePath: "assets/tenant.png",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlidePageRoute(page: LoginScreen()),
                                    );
                                  },
                                  isDark: isDark,
                                ),
                                _buildUserCard(
                                  title: "Landlord",
                                  imagePath: "assets/landloard.png",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      SlidePageRoute(page: LoginScreen()),
                                    );
                                  },
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Dots always visible
              _buildDots(),

              const SizedBox(height: 20),

              // Button (hidden on last page)
              if (_currentIndex < 2)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SizedBox(
                      width: _widthAnimation.value,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentIndex < 2) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 40),
            ],
          ),
        );
}


  Widget _buildUserCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 70),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: BlobPainter(_controller.value),
                );
              },
            ),
          ),
          _buildPageContent(),
        ],
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  final double progress;
  BlobPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final offset = sin(progress * 2 * pi) * 20;

    final paint1 = Paint()..color = Colors.green.withOpacity(0.3);
    final paint2 = Paint()..color = Colors.greenAccent.withOpacity(0.3);
    final paint3 = Paint()..color = Colors.teal.withOpacity(0.2);
    final paint4 = Paint()..color = Colors.lightGreen.withOpacity(0.2);

    final path1 = Path()
      ..moveTo(0, size.height * 0.8)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.75 + offset,
        size.width * 0.75,
        size.height * 0.85 - offset,
        size.width,
        size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path2 = Path()
      ..moveTo(0, size.height * 0.9)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.95 - offset,
        size.width * 0.7,
        size.height * 0.85 + offset,
        size.width,
        size.height * 0.9)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path3 = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.8 + offset,
        size.width * 0.8,
        size.height * 0.95 - offset,
        size.width,
        size.height * 0.87)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path4 = Path()
      ..moveTo(0, size.height * 0.88)
      ..cubicTo(
        size.width * 0.1,
        size.height * 0.93 - offset,
        size.width * 0.9,
        size.height * 0.9 + offset,
        size.width,
        size.height * 0.92)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
    canvas.drawPath(path4, paint4);
  }

  @override
  bool shouldRepaint(covariant BlobPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
