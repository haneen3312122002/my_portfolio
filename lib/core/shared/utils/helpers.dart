import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> openLinkSmart(String rawUrl, {BuildContext? context}) async {
  String url = rawUrl.trim();
  if (url.isEmpty) return;

  // ✅ لو المستخدم حاط رابط بدون scheme
  // مثال: github.com/user أو www.google.com
  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*:').hasMatch(url);
  if (!hasScheme) {
    // لو بدأ بـ www أو دومين، خليه https
    url = 'https://$url';
  }

  Uri uri;
  try {
    uri = Uri.parse(url);
  } catch (_) {
    await _copyToClipboard(url, context: context, msg: 'Invalid link. Copied.');
    return;
  }

  // ✅ اختيار المود حسب النوع والمنصة
  LaunchMode mode;

  // mailto/tel/sms لازم external
  if (uri.scheme == 'mailto' || uri.scheme == 'tel' || uri.scheme == 'sms') {
    mode = LaunchMode.externalApplication;
  } else {
    // روابط عادية: على الويب افتح تبويب/نافذة جديدة، على الموبايل افتح خارجي
    mode = kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;
  }

  // ✅ على الويب: حاول launch مباشرة (canLaunchUrl أحياناً يعطي false غلط)
  if (kIsWeb) {
    try {
      final ok = await launchUrl(uri, mode: mode);
      if (!ok) {
        await _copyToClipboard(
          url,
          context: context,
          msg: 'Could not open. Copied.',
        );
      }
      return;
    } catch (_) {
      await _copyToClipboard(
        url,
        context: context,
        msg: 'Could not open. Copied.',
      );
      return;
    }
  }

  // ✅ على Android/iOS/Desktop: جرّب canLaunch ثم launch
  try {
    final can = await canLaunchUrl(uri);
    if (can) {
      final ok = await launchUrl(uri, mode: mode);
      if (!ok) {
        await _copyToClipboard(
          url,
          context: context,
          msg: 'Could not open. Copied.',
        );
      }
    } else {
      // fallback خاص بالـ mailto: انسخ الإيميل فقط
      if (uri.scheme == 'mailto') {
        final email = uri.path;
        await _copyToClipboard(
          email,
          context: context,
          msg: 'Email not supported. Copied.',
        );
      } else {
        await _copyToClipboard(
          url,
          context: context,
          msg: 'Could not open. Copied.',
        );
      }
    }
  } catch (_) {
    await _copyToClipboard(
      url,
      context: context,
      msg: 'Could not open. Copied.',
    );
  }
}

Future<void> _copyToClipboard(
  String text, {
  BuildContext? context,
  String msg = 'Copied',
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  debugPrint('$msg: $text');

  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

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
