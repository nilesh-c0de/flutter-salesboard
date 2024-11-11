import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salesboardapp/pages/login_screen.dart';
import 'package:salesboardapp/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  var _currentPage = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 60),
        child: PageView(
          controller: controller,
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth / 1.5,
                  height: screenWidth / 1.5,
                  child: SvgPicture.asset(
                    "assets/image1.svg",
                  ),
                ),
                const Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  child: Text(
                    "Easily find and navigate to customer locations to make every visit count.",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth / 1.5,
                  height: screenWidth / 1.5,
                  child: SvgPicture.asset(
                    "assets/image2.svg",
                  ),
                ),
                const Text(
                  "Meet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  child: Text(
                    "Track your visits seamlessly and stay on top of customer interactions.",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth / 1.5,
                  height: screenWidth / 1.5,
                  child: SvgPicture.asset(
                    "assets/image3.svg",
                  ),
                ),
                const Text(
                  "Report",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                  child: Text(
                    "Generate insightful reports to analyze your performance and grow sales.",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: _currentPage == 2
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    prefs.setBool('first_time', true);

                    if (prefs.containsKey("isLoggedIn")) {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainScreen()), (route) => false);
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                      }
                    }
                  },
                  child: const Text("GET STARTED"),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        // print();
                        controller.jumpToPage(2);
                      },
                      child: const Text("SKIP")),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(spacing: 16, dotHeight: 10, dotWidth: 10, dotColor: Colors.black26, activeDotColor: Colors.blue.shade700),
                      onDotClicked: (index) => controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      },
                      child: const Text("NEXT"))
                ],
              ),
      ),
    );
  }
}
