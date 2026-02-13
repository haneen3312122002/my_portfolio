import 'package:cross_file/cross_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/helpers/image_picker.dart';
import 'package:my_portfolio/modules/profile/domain/entites/social_link.dart';
import 'package:my_portfolio/modules/profile/presentation/providers/state_providers.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';
import 'package:my_portfolio/modules/project/presentation/providers/project_state_providers.dart';
import 'package:my_portfolio/modules/project/presentation/viewmodels/project_viewmodel.dart';

class ProjectUpsertState {
  final XFile? coverFile;
  final List<XFile> imageFiles;
  final List<XFile> iconFiles;

  final List<String> existingImages;
  final List<String> existingIcons;

  final List<SocialItem> links;
  final bool deleteOldFiles;

  final bool isVertical;

  const ProjectUpsertState({
    this.coverFile,
    this.imageFiles = const [],
    this.iconFiles = const [],
    this.existingImages = const [],
    this.existingIcons = const [],
    this.links = const [],
    this.deleteOldFiles = true,
    this.isVertical = true,
  });

  ProjectUpsertState copyWith({
    XFile? coverFile,
    bool coverFileToNull = false,
    List<XFile>? imageFiles,
    List<XFile>? iconFiles,
    List<String>? existingImages,
    List<String>? existingIcons,
    List<SocialItem>? links,
    bool? deleteOldFiles,
    bool? isVertical,
  }) {
    return ProjectUpsertState(
      coverFile: coverFileToNull ? null : (coverFile ?? this.coverFile),
      imageFiles: imageFiles ?? this.imageFiles,
      iconFiles: iconFiles ?? this.iconFiles,
      existingImages: existingImages ?? this.existingImages,
      existingIcons: existingIcons ?? this.existingIcons,
      links: links ?? this.links,
      deleteOldFiles: deleteOldFiles ?? this.deleteOldFiles,
      isVertical: isVertical ?? this.isVertical,
    );
  }
}

// ✅ أهم تعديل: autoDispose عشان الستيت ينمسح لما الدايالوج يختفي
final projectUpsertProvider =
    NotifierProvider.autoDispose<ProjectUpsertNotifier, ProjectUpsertState>(
      ProjectUpsertNotifier.new,
    );

class ProjectUpsertNotifier extends Notifier<ProjectUpsertState> {
  @override
  ProjectUpsertState build() {
    final editing = ref.read(editingProjectProvider);
    if (editing == null) return const ProjectUpsertState();

    return ProjectUpsertState(
      existingImages: List.of(editing.projectImages),
      existingIcons: List.of(editing.projectIcons),
      links: List.of(editing.links),
      deleteOldFiles: true,
      isVertical: editing.isVertical,
    );
  }

  // ---------- picking ----------
  Future<void> pickCover() async {
    final picker = ref.read(imagePickerProvider);
    final f = await pickOneImageXFile(picker);
    if (f == null) return;
    state = state.copyWith(coverFile: f);
  }

  Future<void> pickImages() async {
    final picker = ref.read(imagePickerProvider);
    final files = await pickManyImagesXFile(picker);
    if (files.isEmpty) return;
    state = state.copyWith(imageFiles: [...state.imageFiles, ...files]);
  }

  Future<void> pickIcons() async {
    final picker = ref.read(imagePickerProvider);
    final files = await pickManyImagesXFile(picker);
    if (files.isEmpty) return;
    state = state.copyWith(iconFiles: [...state.iconFiles, ...files]);
  }

  // ---------- simple mutations ----------
  void clearCover() => state = state.copyWith(coverFileToNull: true);

  void removeImageFile(XFile f) => state = state.copyWith(
    imageFiles: state.imageFiles.where((e) => e != f).toList(),
  );

  void clearImageFiles() => state = state.copyWith(imageFiles: []);

  void removeIconFile(XFile f) => state = state.copyWith(
    iconFiles: state.iconFiles.where((e) => e != f).toList(),
  );

  void clearIconFiles() => state = state.copyWith(iconFiles: []);

  void addLink(SocialItem item) =>
      state = state.copyWith(links: [...state.links, item]);

  void removeLinkAt(int index) {
    final list = [...state.links]..removeAt(index);
    state = state.copyWith(links: list);
  }

  void setDeleteOldFiles(bool v) => state = state.copyWith(deleteOldFiles: v);

  void setIsVertical(bool v) => state = state.copyWith(isVertical: v);

  // ✅ reset اختياري (مفيد لو بدك تمسحي الستيت يدويًا بدون invalidate)
  void reset() => state = const ProjectUpsertState();

  // ---------- submit ----------
  Future<void> submit({
    required bool isEdit,
    required String title,
    required String description,
    required String coverUrl,
  }) async {
    final vm = ref.read(projectsProvider.notifier);
    final editing = ref.read(editingProjectProvider);

    final canEdit = isEdit && editing != null;

    final entity = ProjectEntity(
      id: canEdit ? editing.id : '',
      title: title.trim(),
      description: description.trim(),
      coverImage: coverUrl.trim(),
      links: List.unmodifiable(state.links),
      projectImages: List.unmodifiable(state.existingImages),
      projectIcons: List.unmodifiable(state.existingIcons),
      isVertical: state.isVertical,
    );

    if (canEdit) {
      await vm.updateProject(
        oldProject: editing,
        newProject: entity,
        newCoverFile: state.coverFile,
        newImageFiles: state.imageFiles,
        newIconFiles: state.iconFiles,
        deleteOldFiles: state.deleteOldFiles,
      );
    } else {
      await vm.addProject(
        project: entity,
        coverFile: state.coverFile,
        imageFiles: state.imageFiles,
        iconFiles: state.iconFiles,
      );
    }
  }
}
