import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/core/shared/widgets/animations/switcher.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/core/helpers/image_picker.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

class CardControllerArgs {
  final int index;
  final String initialText;
  const CardControllerArgs({required this.index, required this.initialText});
}

class AboutMeEditCard extends ConsumerWidget {
  const AboutMeEditCard({super.key, required this.profile});
  final ProfileEntity profile;

  static const sections = ['about', 'education', 'skills'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(cardsProvider);
    final key = sections[index];
    final draft = ref.watch(profileDraftProvider);

    String initialText() {
      switch (key) {
        case 'about':
          return draft['about'] ?? profile.about;
        case 'education':
          return draft['education'] ?? profile.education;
        case 'skills':
          return draft['skills'] ?? profile.skills.join('\n');
        default:
          return '';
      }
    }

    return SlideFadeSwitcher(
      switchKey: ValueKey('${key}_edit'),
      child: AppCard(
        title: AppSubtitle('Edit $key'),
        onNext: () => ref.read(cardsProvider.notifier).state =
            (index + 1) % sections.length,
        child: TextFormField(
          initialValue: initialText(),
          maxLines: key == 'skills' ? 6 : 8,
          decoration: InputDecoration(
            hintText: 'Type your $key...',
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setDraft(ref, key, value);
          },
        ),
      ),
    );
  }
}
