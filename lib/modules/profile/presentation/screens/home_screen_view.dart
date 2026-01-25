import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
import 'package:my_portfolio/core/shared/widgets/buttons/icon_button.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile_viewmodle.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/social_image_viewmodel.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/dialogs/add_social_dialog.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/mode_switcher.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/social_skills_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/view/about_me_card.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/edit/about_me_card_edit.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_actions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final profileAsync = ref.watch(profileProvider);
    final profileVm = ref.read(profileProvider.notifier);

    return AppScaffold(
      body: profileAsync.when(
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
                        onEdit: profileVm.onEdit,

                        isEdit: isEdit,
                        onSave: profileVm.onSave,
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
                            Row(
                              children: [
                                const SocialSection(),
                                const SizedBox(width: 100),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: isEdit
                                      ? AppIconButton(
                                          icon: Icons.add_link_outlined,
                                          onPressed: () {
                                            _openAddSocialDialog(context);
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
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
        error: (e, st) {
          final msg = AppErrorMapper.map(e);
          return Center(child: Text('${msg.title}\n${msg.message}'));
        },
      ),
    );
  }

  void _openAddSocialDialog(BuildContext context) =>
      showDialog(context: context, builder: (_) => const AddSocialLinkDialog());
}
