import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/core/shared/widgets/animations/switcher.dart';
import 'package:my_portfolio/core/shared/widgets/lists/card.dart';
import 'package:my_portfolio/core/shared/widgets/texts/body_text.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/profile/domain/entites/card_item.dart';

final cardsProvider = StateProvider<int>((ref) => 0);

class AboutMeCard extends ConsumerWidget {
  const AboutMeCard({super.key});

  static const aboutSections = <CardItem>[
    CardItem(title: 'about', content: 'hh'),
    CardItem(title: 'education', content: 'edu'),
    CardItem(title: 'skills', content: 'skills'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
