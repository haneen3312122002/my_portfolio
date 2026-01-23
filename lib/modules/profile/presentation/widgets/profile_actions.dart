import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/icon_button.dart';

class ProfileHeader extends ConsumerWidget {
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final bool isEdit;

  const ProfileHeader({
    super.key,
    required this.onEdit,
    required this.onSave,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Edit / Cancel
        Tooltip(
          message: isEdit ? 'Cancel editing' : 'Edit profile',
          child: AppIconButton(
            icon: isEdit ? Icons.cancel : Icons.edit,
            onPressed: onEdit,
          ),
        ),

        const SizedBox(width: 12),

        // Save
        if (isEdit)
          Tooltip(
            message: 'Save changes',
            child: AppIconButton(icon: Icons.check, onPressed: onSave),
          ),
      ],
    );
  }
}
