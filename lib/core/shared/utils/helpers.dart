import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> openLinkSmart(
  String rawUrl, {
  BuildContext? context,
  String? subject,
  String? body,
}) async {
  var url = rawUrl.trim();
  if (url.isEmpty) return;

  // ✅ إذا المستخدم كاتب ايميل فقط بدون mailto
  final isEmailOnly = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(url);
  if (isEmailOnly) {
    final mailUri = Uri(
      scheme: 'mailto',
      path: url,
      queryParameters: {
        if (subject != null && subject.trim().isNotEmpty) 'subject': subject,
        if (body != null && body.trim().isNotEmpty) 'body': body,
      },
    );
    final ok = await launchUrl(mailUri, mode: LaunchMode.externalApplication);
    if (!ok) {
      await _copyToClipboard(url, context: context, msg: 'Email copied.');
    }
    return;
  }

  // ✅ إذا الرابط بدون scheme (مثال github.com)
  final hasScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*:').hasMatch(url);
  if (!hasScheme) url = 'https://$url';

  Uri uri;
  try {
    uri = Uri.parse(url);
  } catch (_) {
    await _copyToClipboard(url, context: context, msg: 'Invalid link. Copied.');
    return;
  }

  // ✅ لو mailto وبدك تضيف subject/body (حتى لو كان الرابط mailto جاهز)
  if (uri.scheme == 'mailto' && (subject != null || body != null)) {
    uri = Uri(
      scheme: 'mailto',
      path: uri.path,
      queryParameters: {
        ...uri.queryParameters,
        if (subject != null && subject.trim().isNotEmpty) 'subject': subject,
        if (body != null && body.trim().isNotEmpty) 'body': body,
      },
    );
  }

  final mode =
      (uri.scheme == 'mailto' || uri.scheme == 'tel' || uri.scheme == 'sms')
      ? LaunchMode.externalApplication
      : (kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication);

  try {
    final ok = await launchUrl(uri, mode: mode);
    if (!ok) {
      if (uri.scheme == 'mailto') {
        await _copyToClipboard(
          uri.path,
          context: context,
          msg: 'Email copied.',
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
    if (uri.scheme == 'mailto') {
      await _copyToClipboard(uri.path, context: context, msg: 'Email copied.');
    } else {
      await _copyToClipboard(
        url,
        context: context,
        msg: 'Could not open. Copied.',
      );
    }
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
