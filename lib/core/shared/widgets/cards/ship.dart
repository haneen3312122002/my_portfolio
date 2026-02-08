import 'package:flutter/material.dart';

class SkillsChips extends StatelessWidget {
  final List<String> skills;
  final double spacing;
  final double runSpacing;

  /// ✅ لون الشيبس
  final Color chipColor;

  const SkillsChips({
    super.key,
    required this.skills,
    required this.chipColor,
    this.spacing = 6,
    this.runSpacing = 6,
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
      children: items
          .map((skill) => _SkillChip(label: skill, color: chipColor))
          .toList(),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SkillChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.55)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.92),
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
