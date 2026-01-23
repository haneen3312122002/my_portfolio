import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/constants/images/images_paths.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/core/shared/widgets/images/circle_image.dart';
import 'package:my_portfolio/core/shared/widgets/texts/title_text.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile_viewmodle.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/mode_switcher.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/view/about_me_card.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/edit/about_me_card_edit.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_actions.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/social_skills_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final isEitVm = ref.read(isEditProvider.notifier);
    final profile = ref.watch(profileProvider);

    return AppScaffold(
      body: profile.when(
        data: (profileData) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= LEFT SECTION =================
                      ProfileHeader(
                        onEdit: () {
                          isEitVm.state = !isEdit;
                        },
                        isEdit: isEdit,
                        onSave: () async {
                          final draft = ref.read(profileDraftProvider);

                          if (draft.isEmpty) {
                            isEitVm.state = false;
                            return;
                          }

                          // تجهيز fields للفايرستور
                          final fields = <String, dynamic>{};

                          if (draft.containsKey('about'))
                            fields['about'] = draft['about'];
                          if (draft.containsKey('education'))
                            fields['education'] = draft['education'];

                          if (draft.containsKey('skills')) {
                            final text = (draft['skills'] as String);
                            fields['skills'] = text
                                .split('\n')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                          }

                          if (draft.containsKey('name'))
                            fields['name'] = draft['name'];
                          if (draft.containsKey('image'))
                            fields['image'] = draft['image'];

                          await ref
                              .read(profileProvider.notifier)
                              .updateProfileFields(fields);

                          // صفّر المسودة واطلع من edit
                          ref.read(profileDraftProvider.notifier).state = {};
                          isEitVm.state = false;
                        },
                      ),

                      ProfileSection(profile: profileData),
                      const SizedBox(width: 48),

                      // ================= RIGHT SECTION =================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------- ABOUT CARD --------
                            EditableSection(
                              view: AboutMeCard(profile: profileData),
                              edit: AboutMeEditCard(profile: profileData),
                            ),

                            const SizedBox(height: 32),

                            // -------- SKILLS / SOCIAL --------
                            const SocialSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => SingleChildScrollView(
          child: Text(
            'ERROR: $e\n\n$st',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class _AboutMeForm extends StatelessWidget {
  const _AboutMeForm();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('About me', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: 12),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write something about you...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
