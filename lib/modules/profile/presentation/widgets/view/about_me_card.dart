import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/core/shared/widgets/animations/switcher.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/card_item.dart';
import 'package:my_portfolio/modules/profile/domain/entites/profile_entity.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

class AboutMeCard extends ConsumerWidget {
  const AboutMeCard({super.key, required this.profile});
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutSections = <CardItem>[
      CardItem(title: 'about', content: profile.about),
      CardItem(title: 'education', content: profile.education),
      CardItem(title: 'skills', content: profile.skills.join('\n')),
    ];
    final index = ref.watch(cardsProvider);
    final item = aboutSections[index];

    return SlideFadeSwitcher(
      switchKey: ValueKey(item),
      child: AppCard(
        title: AppSubtitle(item.title),
        onNext: () => ref.read(cardsProvider.notifier).state =
            (index + 1) % aboutSections.length,
        child: AppBodyText(item.content, softWrap: true),
      ),
    );
  }
}
