import 'package:flutter/material.dart';
import 'package:my_portfolio/core/shared/widgets/texts/subtitle_text.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/widgets/project_images.dart';

class ProjectGridItem extends StatelessWidget {
  final ProjectEntity project;
  const ProjectGridItem({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final cover = project.coverImage;
    final imgs = project.projectImages;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        debugPrint('Open project: ${project.id}');
      },
      child: Card(
        color: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== PROJECT TITLE (ABOVE IMAGE) ======
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: AppSubtitle(
                project.title,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),

            // ====== COVER + PHONES ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProjectShowcaseStack(
                coverUrl: cover,
                projectImageUrls: imgs,
                height: 240,
              ),
            ),

            // ====== ACTION BUTTONS AREA ======
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              child: Row(children: [
                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
