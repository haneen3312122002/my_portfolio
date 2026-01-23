import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

class EditableSection extends ConsumerWidget {
  const EditableSection({super.key, required this.view, required this.edit});

  final Widget view;
  final Widget edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isEdit
          ? KeyedSubtree(key: const ValueKey('edit'), child: edit)
          : KeyedSubtree(key: const ValueKey('view'), child: view),
    );
  }
}
