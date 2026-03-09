/// Barrel import file for all App screens.
/// Import this single file at the top of any View to get everything needed.
///
/// Usage:
///   import 'package:my_structure/app/core/utils/app_screen_imports.dart';
///
library;
export 'package:flutter/material.dart';
export 'package:get/get.dart';

// ── Core constants ────────────────────────────────────────────────────────────
export '../constants/app_colors.dart';
export '../constants/app_sizes.dart';
export '../constants/app_strings.dart';

// ── Common widgets ────────────────────────────────────────────────────────────
export '../../widgets/primary_appbar_widget.dart';
export '../../widgets/primary_button.dart';
export '../../widgets/primary_input_field.dart';
export '../../widgets/primary_dropdown.dart';
export '../../widgets/rich_text_widget.dart';

// ── Services ──────────────────────────────────────────────────────────────────
export '../services/app_snackbar.dart';
export '../services/local_storage_service.dart';

// ── Utils ─────────────────────────────────────────────────────────────────────
export 'responsive_layout.dart';
