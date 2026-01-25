import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialGlowButton extends StatefulWidget {
  final SocialItem item;
  final double size;

  const SocialGlowButton({super.key, required this.item, this.size = 44});

  @override
  State<SocialGlowButton> createState() => _SocialGlowButtonState();
}

class _SocialGlowButtonState extends State<SocialGlowButton> {
  bool _hover = false;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url.trim());
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = AppColors.body;
    final Color glowColor = AppColors.heading;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _open(widget.item.url),
        child: AnimatedScale(
          scale: _hover ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: widget.size + 16,
            height: widget.size + 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(_hover ? 0.35 : 0.18),
                  blurRadius: _hover ? 22 : 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: _buildIcon(iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color iconColor) {
    // ✅ 1) لو في iconUrl (من Firebase Storage)
    final iconUrl = widget.item.iconUrl;
    if (iconUrl != null && iconUrl.trim().isNotEmpty) {
      return ClipOval(
        child: Image.network(
          iconUrl,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.link, size: widget.size, color: iconColor),
        ),
      );
    }

    // ✅ 2) لو في Material icon (codePoint)
    final iconCode = widget.item.iconCodePoint;
    if (iconCode != null) {
      return Icon(
        IconData(iconCode, fontFamily: 'MaterialIcons'),
        size: widget.size,
        color: iconColor,
      );
    }

    // ✅ 3) fallback
    return Icon(Icons.link, size: widget.size, color: iconColor);
  }
}
