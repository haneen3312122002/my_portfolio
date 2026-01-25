import 'package:flutter_riverpod/legacy.dart';

//to know if i can edit the profile or not:
final isEditProvider = StateProvider<bool>((ref) {
  return false;
});
//the index of the current card
final cardsProvider = StateProvider<int>((ref) => 0);
//the profile draft data showed kn the screen before uploading
final profileDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});
