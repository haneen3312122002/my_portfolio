import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
import 'package:my_portfolio/core/shared/widgets/animations/animated_visibility.dart';
import 'package:my_portfolio/core/shared/widgets/animations/fadein.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/skills_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/profile_viewmodle.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section/profile_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/skills_section/skills.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/admin_actions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final profileAsync = ref.watch(profileProvider);
    final profileVm = ref.read(profileProvider.notifier);
    final skillsService = ref.read(skillServiceProvider);
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //HACK  i used this for one time to backfill the createdAt field for old skills that were created before adding this field, after running it once, you can remove this button
                      // AppIconButton(
                      //   icon: Icons.add,
                      //   onPressed: () {
                      //     skillsService.backfillCreatedAt();
                      //   },
                      // ),
                      // ================= LEFT SECTION =================
                      ProfileHeader(
                        onEdit: profileVm.onEdit,

                        isEdit: isEdit,
                        onSave: profileVm.onSave,
                      ),

                      AnimateOnVisible(
                        child: ProfileSection(profile: profileData),
                      ),

                      const SizedBox(width: 48),

                      AnimateOnVisible(
                        onReplay: () {
                          ref.read(skillsReplayProvider.notifier).state++;
                        },
                        child: const SkillsSection(),
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
}
