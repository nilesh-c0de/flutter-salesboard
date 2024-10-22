import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 60),
        child: PageView(
          controller: controller,
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/image1.svg", width: 400, height: 400,),
                  Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 8,),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",style: TextStyle(color: Colors.grey, fontSize: 18), textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/image2.svg", width: 400, height: 400,),
                  Text("Meet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 8,),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", style: TextStyle(color: Colors.grey, fontSize: 18), textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/image3.svg", width: 400, height: 400,),
                  Text("Report", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 8,),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", style: TextStyle(color: Colors.grey, fontSize: 18), textAlign: TextAlign.center,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        height: 60,
        child: _currentPage == 2 ?
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () async {

            final prefs = await SharedPreferences.getInstance();

            prefs.setBool('first_time', true);

            if(prefs.containsKey("isLoggedIn")) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }


          }, child: Text("GET STARTED"),),
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {
              // print();
              controller.jumpToPage(2);
            }, child: Text("SKIP")),
            Center(
              child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotHeight: 10,
                  dotWidth: 10,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.blue.shade700
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn
                ),

              ),
            ),
            TextButton(onPressed: () {
              controller.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut
              );
            }, child: Text("NEXT"))
          ],
        ),
      ),
    );
  }
}
