import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLinkSmart(String url) async {
  final uri = Uri.parse(url);

  if (uri.scheme == 'mailto') {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final email = uri.path;
      await Clipboard.setData(ClipboardData(text: email));
      debugPrint('Email not supported. Copied: $email');
    }
    return;
  }

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch $url');
  }
}
