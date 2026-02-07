import 'package:flutter_riverpod/legacy.dart';

class SkillsExpandedNotifier extends StateNotifier<Map<String, bool>> {
  SkillsExpandedNotifier() : super(const {});

  bool isOpen(String skillId) => state[skillId] ?? false;

  void toggle(String skillId) {
    final current = state[skillId] ?? false;
    state = {...state, skillId: !current};
  }

  void setOpen(String skillId, bool open) {
    state = {...state, skillId: open};
  }

  void closeAll() => state = const {};
}

final skillsExpandedProvider =
    StateNotifierProvider<SkillsExpandedNotifier, Map<String, bool>>(
      (ref) => SkillsExpandedNotifier(),
    );
