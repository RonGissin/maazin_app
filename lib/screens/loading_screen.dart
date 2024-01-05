import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './main_home_page.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    
    // Simulate loading by delaying for 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      // Transition to the MainContentScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MaazinHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo.svg', // Replace with your logo image path
              width: 200,
              height: 200,
              color: secondaryColor,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
