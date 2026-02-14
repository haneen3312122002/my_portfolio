import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/android_only.dart';
import 'package:my_portfolio/core/shared/errors/error_mapper.dart';
import 'package:my_portfolio/core/shared/utils/device_helper.dart';
import 'package:my_portfolio/core/shared/widgets/animations/animated_visibility.dart';
import 'package:my_portfolio/core/shared/widgets/animations/fadein.dart';
import 'package:my_portfolio/core/shared/widgets/common/scaffold.dart';
import 'package:my_portfolio/core/shared/widgets/texts/copyright.dart';
import 'package:my_portfolio/modules/messages/presentation/widgets/contact_form.dart';
import 'package:my_portfolio/modules/messages/presentation/widgets/messages_list.dart';
import 'package:my_portfolio/modules/messages/presentation/widgets/services_section.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/skills_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/profile/presentation/viewmodles/profile/profile_viewmodle.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/profile_section/profile_section.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/skills_section/skills.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/admin_actions.dart';
import 'package:my_portfolio/modules/profile/presentation/widgets/social_links_section.dart';
import 'package:my_portfolio/modules/project/presentation/screens/projects_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = ref.watch(isEditProvider);
    final profileAsync = ref.watch(profileProvider);
    final profileVm = ref.read(profileProvider.notifier);
    final skillsService = ref.read(skillServiceProvider);
    final isMobile = DeviceHelper.isMobile(context);
    final isDesktop = DeviceHelper.isDesktop(context);

    return AppScaffold(
      overlayOnlyOnWeb: false, // ✅ نخليه يظهر على الكل لأنك بدك موبايل كمان
      overlayAlignment: isDesktop
          ? Alignment.bottomCenter
          : Alignment.bottomRight, // ✅ تحت بالنص
      overlayPadding: const EdgeInsets.only(bottom: 16),
      overlay: LayoutBuilder(
        builder: (context, c) {
          final isMobile = c.maxWidth < 650;

          return IgnorePointer(
            ignoring: false,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: isMobile ? 10 : 8,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.transparent, // ✅ بدون خلفية (إذا بدك خليها خفيفة)
                  borderRadius: BorderRadius.circular(999),
                ),
                child: SocialLinksSection(
                  iconSize: isMobile ? 26 : 28, // ✅ صغار
                ),
              ),
            ),
          );
        },
      ),
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
                        visibleFraction: 0.03, // بدل 0.35

                        onReplay: () {
                          ref.read(skillsReplayProvider.notifier).state++;
                        },
                        child: const SkillsSection(),
                      ),
                      const SizedBox(height: 48),
                      AnimateOnVisible(
                        visibleFraction: 0.03, // بدل 0.35
                        child: const ProjectsGridSection(),
                      ),
                      const SizedBox(height: 48),
                      // AnimateOnVisible(
                      //   visibleFraction: 0.03, // بدل 0.35
                      //   child: ServicesSection(),
                      // ),
                      const SizedBox(height: 48),

                      AnimateOnVisible(
                        replay: true, // ok: شغله مرة للفورم
                        protectFocus: true, // ✅ لازم
                        protectKeyboard: true, // ✅ لازم
                        visibleFraction: 0.08,
                        child: LayoutBuilder(
                          builder: (context, c) {
                            final isWebLayout = c.maxWidth >= 650;

                            if (!isWebLayout) {
                              // ✅ Mobile/Small: تحت بعض
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: const [
                                  SizedBox(height: 18),
                                  ContactMessageForm(),
                                  SizedBox(height: 18),
                                  // SocialLinksSection(),
                                ],
                              );
                            }

                            // ✅ Web/Desktop:
                            // 1) الفورم بعرضه الطبيعي (هو أصلاً Align left + constrained)
                            // 2) الروابط تحت الفورم ومتمركزة بالمنتصف
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ContactMessageForm(),
                                const SizedBox(height: 18),

                                // Center(
                                //   child: ConstrainedBox(
                                //     constraints: const BoxConstraints(
                                //       maxWidth: 720,
                                //     ),
                                //     child: const SocialLinksSection(),
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ),
                      ),

                      AndroidOnly(child: const MessagesAdminList()),
                      AppCopyright(),
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
