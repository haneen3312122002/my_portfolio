import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

void setDraft(WidgetRef ref, String key, dynamic value) {
  final draft = {...ref.read(profileDraftProvider)};
  draft[key] = value;
  ref.read(profileDraftProvider.notifier).state = draft;
}
