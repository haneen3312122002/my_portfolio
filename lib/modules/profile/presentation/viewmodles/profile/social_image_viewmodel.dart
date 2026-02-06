import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/profile_service_provider.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/profile_viewmodle.dart';

final socialIconUploadProvider =
    AsyncNotifierProvider<SocialIconUploadViewModel, void>(
      SocialIconUploadViewModel.new,
    );

class SocialIconUploadViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// 1) pick icon (FilePicker)
  /// 2) upload to Storage via usecase.uploadSocialIcon
  /// 3) add to profile.socialLinks via usecase.updateProfileFields
  Future<void> pickUploadAndSaveSocialLink({
    required String linkUrl, // رابط السوشيال اللي بدك تفتحيه
    String? displayName, // اختياري: اسم مثل "GitHub"
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final useCase = ref.read(profileUseCaseProvider);

      // --- Pick image (bytes) ---
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // مهم للويب
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final Uint8List? bytes = file.bytes;
      if (bytes == null) return;

      final fileName = file.name;

      // --- Upload to Storage (UseCase) ---
      final iconUrl = await useCase.uploadSocialIcon(
        bytes: bytes,
        originalFileName: fileName,
      );

      // --- Update profile field: socialLinks ---
      // الأفضل تجيبي الموجود وتضيفي عليه (بدون arrayUnion)
      final profileAsync = ref.read(profileProvider);
      final profile =
          profileAsync.value; // إذا profileProvider AsyncValue<ProfileEntity>
      if (profile == null) return;

      final updatedLinks = [
        ...profile.socialLinks.map((e) => e.toMap()),
        {
          'url': linkUrl.trim(),
          'iconUrl': iconUrl,
          'name': (displayName?.trim().isNotEmpty ?? false)
              ? displayName!.trim()
              : fileName,
        },
      ];

      await useCase.updateProfileFields({'socialLinks': updatedLinks});

      // (اختياري) صفّري أي draft متعلق بالديالوج
      final draft = {...ref.read(profileDraftProvider)};
      draft.remove('social_icon_name');
      draft.remove('social_icon_bytes');
      draft.remove('social_url');
      ref.read(profileDraftProvider.notifier).state = draft;
    });
  }

  //
  Future<void> uploadFromDraftAndSaveToProfile({
    required String linkUrl,
    String? displayName,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final draft = ref.read(profileDraftProvider);
      final bytes = draft['social_icon_bytes'];
      final name = draft['social_icon_name'] as String?;

      if (bytes == null || name == null) {
        throw Exception('No icon selected');
      }

      final useCase = ref.read(profileUseCaseProvider);

      // 1) Upload to storage
      final iconUrl = await useCase.uploadSocialIcon(
        bytes: bytes,
        originalFileName: name,
      );

      // 2) Save to profile (Firestore)
      final profile = ref.read(profileProvider).value;
      if (profile == null) return;

      final updated = [
        ...profile.socialLinks.map((e) => e.toMap()),
        {'url': linkUrl, 'iconUrl': iconUrl, 'name': displayName ?? name},
      ];

      await useCase.updateProfileFields({'socialLinks': updated});
      ref.invalidate(profileProvider);

      // 3) Clear draft keys
      final newDraft = {...draft}
        ..remove('social_icon_bytes')
        ..remove('social_icon_name')
        ..remove('social_url');

      ref.read(profileDraftProvider.notifier).state = newDraft;
    });
  }
}
