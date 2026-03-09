/// Barrel import file for all common widgets.
/// Import this in any widget file that needs the base shared widgets.
///
/// Usage:
///   import 'package:my_structure/app/core/utils/app_widget_imports.dart';
///
library;
export 'package:flutter/material.dart';
export 'package:get/get.dart';

// ── Core constants ────────────────────────────────────────────────────────────
export '../constants/app_colors.dart';
export '../constants/app_sizes.dart';
export '../constants/app_strings.dart';

// ── Common widgets ────────────────────────────────────────────────────────────
export '../../widgets/primary_button.dart';
export '../../widgets/primary_input_field.dart';
export '../../widgets/primary_dropdown.dart';
export '../../widgets/chip_widget.dart';
export '../../widgets/toggle_switch_widget.dart';
export '../../widgets/rich_text_widget.dart';
export '../../widgets/progress_bar_widget.dart';
export '../../widgets/pin_code_field_widget.dart';

// ── Utils ─────────────────────────────────────────────────────────────────────
export 'responsive_layout.dart';
