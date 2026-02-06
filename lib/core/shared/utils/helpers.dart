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
//...

Color mycolorFromHex(String hex) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h'; // alpha
  return Color(int.parse(h, radix: 16));
}

String myhexFromColor(Color c) {
  final a = c.alpha.toRadixString(16).padLeft(2, '0');
  final r = c.red.toRadixString(16).padLeft(2, '0');
  final g = c.green.toRadixString(16).padLeft(2, '0');
  final b = c.blue.toRadixString(16).padLeft(2, '0');
  return '#${(a + r + g + b).toUpperCase()}';
}
