import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.backgroundImage = AppImages.backgroundImage,
  });

  final String? title;
  final Widget body;
  final String? backgroundImage;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: title != null ? AppBar(title: Text(title!)) : null,
      body: SafeArea(bottom: true, left: true, right: true, child: body),
    );

    // if (backgroundImage == null) {
    //   print('the img is null');
    //   return scaffold;
    // }

    return Stack(
      fit: StackFit.expand,
      children: [
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
      ],
    );
  }
}
