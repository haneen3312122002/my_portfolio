import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceHelper {
  static bool isWeb() => kIsWeb;

  static bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (kIsWeb) {
      // لو ويب: نعتبره موبايل إذا العرض صغير
      return width < 650;
    }

    // لو مش ويب: نتحقق من نوع المنصة
    return Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (kIsWeb) {
      return width >= 650;
    }

    return Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.linux;
  }
}
