import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/icon_button.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/outline_button.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/primary_button.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class StoryboardPage extends StatelessWidget {
  const StoryboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      backgroundImage: AppImages.backgroundImage,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== TEXTS =====
          Text('Texts', style: t.titleMedium),
          const SizedBox(height: 12),

          // إذا عندك AppTitle/AppSubtitle/AppBodyText
          const AppTitle('ABOUT ME (TitleText / Neon)'),
          const SizedBox(height: 8),
          const AppSubtitle('Flutter Developer (SubtitleText)'),
          const SizedBox(height: 8),
          const AppBodyText(
            'This is body text. It should follow the theme automatically. '
            'Try long text to see wrapping and readability.',
          ),

          const SizedBox(height: 20),
          const Divider(),

          // ===== BUTTONS =====
          Text('Buttons', style: t.titleMedium),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                PrimaryButton(title: 'Primary', onPressed: () {}),
                PrimaryButton(
                  title: 'Loading',
                  isLoading: true,
                  onPressed: () {},
                ),
                OutlineButton(title: 'Outline', onPressed: () {}),
                AppIconButton(
                  icon: Icons.favorite_border,
                  tooltip: 'Like',
                  onPressed: () {},
                ),
                AppIconButton(
                  icon: Icons.settings,
                  tooltip: 'Settings',
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // ===== INPUTS =====
          Text('Inputs', style: t.titleMedium),
          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'example@mail.com',
            ),
          ),
          const SizedBox(height: 12),

          const TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '••••••••',
            ),
            obscureText: true,
          ),

          const SizedBox(height: 20),
          const Divider(),

          // ===== CARDS / LIST TILES =====
          Text('Cards & Tiles', style: t.titleMedium),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppTitle('Card Title'),
                  const SizedBox(height: 8),
                  const AppBodyText('Card body text goes here.'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      PrimaryButton(title: 'Action', onPressed: () {}),
                      const SizedBox(width: 12),
                      OutlineButton(title: 'Secondary', onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.divider,
                child: Icon(Icons.person, color: AppColors.body),
              ),
              title: Text('ListTile Title', style: t.titleSmall),
              subtitle: Text('ListTile subtitle', style: t.bodyMedium),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // ===== STATES =====
          Text('States', style: t.titleMedium),
          const SizedBox(height: 12),

          const AppBodyText('Disabled button example:'),
          const SizedBox(height: 8),
          const PrimaryButton(title: 'Disabled', onPressed: null),

          const SizedBox(height: 24),
          GlowCircleImage(image: AppImages.backgroundImage),
          const SizedBox(height: 24),
          SizedBox(
            width: 260,
            height: 520,
            child: DeviceFrame(
              device: Devices.android.samsungGalaxyS25,
              screen: Image.asset(AppImages.backgroundImage, fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            width: 260,
            height: 520,
            child: DeviceFrame(
              device: Devices.ios.iPadPro13InchesM4,
              orientation: Orientation.landscape,
              screen: Image.asset(AppImages.backgroundImage, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
