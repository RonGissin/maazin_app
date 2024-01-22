import 'package:flutter/material.dart';

class TemplateIntroductionPage extends StatelessWidget {
  final String imagePath; // Path to the screenshot image
  final String description;
  final Widget? child;

  const TemplateIntroductionPage({Key? key, this.imagePath = '', this.child, this.description = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primary = Theme.of(context).colorScheme.primary;

    return Container(
      color: Colors.lightGreen, // Light green background color
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath != '' ?
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: primary, // Border color
                width: 4.0, // Border width
              ),
              borderRadius: BorderRadius.circular(25.0), // The same radius as the ClipRRect
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust radius to get desired roundness
              child: Image.asset(
                imagePath, // Assuming imagePath is passed to the widget
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
           ),
          ) :
          child!,
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 20, right: 20),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
