import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';

import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

class AboutMeEditCard extends ConsumerWidget {
  const AboutMeEditCard({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(profileDraftProvider);

    final initialText = draft['about'] ?? profile.about;

    return AppCard(
      title: const AppSubtitle('Edit About'),
      child: TextFormField(
        initialValue: initialText,
        maxLines: 8,
        textAlign: TextAlign.start,
        decoration: const InputDecoration(
          hintText: 'Tell your story...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          final updated = {...ref.read(profileDraftProvider)};
          updated['about'] = value.trim();
          ref.read(profileDraftProvider.notifier).state = updated;
        },
      ),
    );
  }
}
