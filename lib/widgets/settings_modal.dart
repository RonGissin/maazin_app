import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String _appInfoUrl = "https://maazinappsa.z5.web.core.windows.net/";

class SettingsModal extends StatelessWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints(maxWidth: 600), // Set a max width for larger screens
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _launchURL(_appInfoUrl),
              child: const Text(
                'Support',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _launchURL(_appInfoUrl),
              child: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 Maazin App. All rights reserved.',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchURL(String url) async {
  var uri = Uri.parse(url);
  try {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }
  catch (err) {
    throw 'Could not launch $err';
  }
}
