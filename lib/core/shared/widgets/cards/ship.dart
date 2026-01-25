import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class SkillsChips extends StatelessWidget {
  final List<String> skills;
  final double spacing;
  final double runSpacing;

  const SkillsChips({
    super.key,
    required this.skills,
    this.spacing = 10,
    this.runSpacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final items = skills
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: items.map((skill) => _SkillChip(label: skill)).toList(),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card, // خلفية الكارد الشفافة
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.heading.withOpacity(0.14), // glow خفيف
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.body,
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
        ),
      ),
    );
  }
}
