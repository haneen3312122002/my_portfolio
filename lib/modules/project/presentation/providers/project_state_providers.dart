import 'package:flutter_riverpod/legacy.dart';
import 'package:my_portfolio/modules/project/domain/entities/project_entity.dart';

/// ------------------------------------------------------------
/// Project Form State (Riverpod Providers)
/// ------------------------------------------------------------
/// These providers are responsible for holding temporary UI state
/// related to creating/editing projects.
/// They are NOT persisted — only used while the user is interacting
/// with the form or navigating between pages.

/// Holds draft form values before saving.
/// Useful when:
/// - User navigates between steps
/// - Form is split into multiple sections
/// - We want to collect values before creating/updating the project
///
/// Using Map<String, dynamic> keeps it flexible and easy to extend.
final projectDraftProvider = StateProvider<Map<String, dynamic>>((ref) => {});

/// Holds the project currently being edited.
/// If null → we are in "Create Mode"
/// If not null → we are in "Edit Mode"
///
/// Storing the whole ProjectEntity instead of just ID
/// gives more flexibility (UI can directly access fields
/// without fetching again).
final editingProjectProvider = StateProvider<ProjectEntity?>((ref) => null);

/// NOTE:
/// Instead of storing only project ID (like selectedProjectIdProvider),
/// we store the entire ProjectEntity.
/// This avoids extra reads and gives more control in the UI layer.
