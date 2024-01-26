import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maazin_app/providers/onboarding_status_provider.dart';
import 'package:maazin_app/screens/introduction/template_introduction_page.dart';
import 'package:maazin_app/screens/loading_screen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _currentPage = 0;
  PageController _controller = PageController();
  OnboardingStatusProvider _onboardingStatusProvider = OnboardingStatusProvider();

  @override
  Widget build(BuildContext context) { 
    var scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: <Widget>[
          // Add your onboarding content here
          Center(child: TemplateIntroductionPage(
            description: "Welcome to Maazin App !",
            child: SvgPicture.asset(
                    'assets/logo.svg', // Replace with the path to your SVG file
                    width: 150,  // Set the desired width
                    height: 150, // Set the desired height
                    color: scheme.secondary,
            ))),
          Center(child: const TemplateIntroductionPage(
            imagePath: 'assets/add_members_intro_page_screenshot.jpg',
            description: "First, add your team members",)),
          Center(child: const TemplateIntroductionPage(
            imagePath: 'assets/generate_list_intro_snapshot.jpg',
            description: "Second, create your guard list",)),
          Center(child: const TemplateIntroductionPage(
            imagePath: 'assets/edit_and_share_intro_screenshot.jpg',
            description: "Finally, edit and share with your team !",)),
          Center(child: TemplateIntroductionPage(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(scheme.primary),
                  foregroundColor: MaterialStateProperty.all<Color>(scheme.onPrimary)),
                child: Text("Get Started !", style: TextStyle(fontSize: 20)),
                onPressed: () => _completeOnboarding(),
            ),)
          )
        ],
      ),
      bottomSheet: Container(
            color: scheme.primary,
            height: 70,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(5, (index) => _buildDot(index, context)),
            ),
          ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index 
            ? Colors.lightGreen 
            : Colors.grey,
      ),
    );
  }

  void _completeOnboarding() async {
    _onboardingStatusProvider.completeOnboarding();
    
    // Navigate to home screen.
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()),
  );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
