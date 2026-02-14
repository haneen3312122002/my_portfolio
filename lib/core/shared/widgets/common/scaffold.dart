import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.backgroundImage = AppImages.backgroundImage,

    // ✅ new
    this.overlay,
    this.overlayAlignment = Alignment.bottomRight,
    this.overlayPadding = const EdgeInsets.all(18),
    this.overlayOnlyOnWeb = false,
  });

  final String? title;
  final Widget body;
  final String? backgroundImage;

  // ✅ new
  final Widget? overlay;
  final AlignmentGeometry overlayAlignment;
  final EdgeInsets overlayPadding;
  final bool overlayOnlyOnWeb;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: SafeArea(bottom: true, left: true, right: true, child: body),
    );

    final canShowOverlay = overlay != null && (!overlayOnlyOnWeb || kIsWeb);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (backgroundImage != null)
          Image.asset(
            backgroundImage!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Failed to load:\n$backgroundImage\n\n$error',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

        scaffold,

        // ✅ overlay فوق كلشي
        if (canShowOverlay)
          Align(
            alignment: overlayAlignment,
            child: Padding(padding: overlayPadding, child: overlay!),
          ),
      ],
    );
  }
}
