import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/edit/about_me_card_edit.dart';

final isEditProvider = StateProvider<bool>((ref) {
  return false;
});
final cardsProvider = StateProvider<int>((ref) => 0);
final profileDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final cardControllerProvider =
    Provider.family<TextEditingController, CardControllerArgs>((ref, args) {
      final controller = TextEditingController(text: args.initialText);
      ref.onDispose(controller.dispose);
      return controller;
    });
