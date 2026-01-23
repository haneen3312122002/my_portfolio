import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:cross_file/cross_file.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/profile_service_provider.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';

final imagePickerProvider = Provider<ip.ImagePicker>((ref) => ip.ImagePicker());

final profileImageUploadProvider =
    AsyncNotifierProvider<ProfileImageUploadViewModel, void>(
      ProfileImageUploadViewModel.new,
    );

class ProfileImageUploadViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> pickAndUploadProfileImage() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final picker = ref.read(imagePickerProvider);

      final file = await picker.pickImage(
        source: ip.ImageSource.gallery,
        imageQuality: 85,
      );

      if (file == null) return;

      // ✅ حوّليه لنوع cross_file (نفس المسار)
      final XFile xfile = XFile(file.path);

      final useCase = ref.read(profileUseCaseProvider);
      final url = await useCase.uploadImage(xfile);

      if (url == null || url.isEmpty) return;

      final draft = {...ref.read(profileDraftProvider)};
      draft['image'] = url;
      ref.read(profileDraftProvider.notifier).state = draft;
    });
  }
}
