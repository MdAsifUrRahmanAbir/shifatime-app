import os

# ======================
# Project root path
# ======================
ROOT = os.getcwd()  # Run from your Flutter project root: cd shifatime-app && python abirdev_flutter_structure.py
LIB_PATH = os.path.join(ROOT, "lib")

# ======================
# ShifaTime Project Structure
# Offline-first medicine & water intake reminder app (GetX + Hive)
# ======================
structure = {
    "app": {
        "core": {
            "constants": [
                "app_colors.dart",        # Brand palette — primary green, dark/light backgrounds
                "app_strings.dart",       # Centralized static text & localization keys
                "app_sizes.dart",         # Global spacing, radius, font-size tokens
            ],
            "theme": [
                "app_theme.dart",         # Light / Dark ThemeData with Google Fonts
            ],
            "utils": [
                "responsive_helper.dart",     # Screen-size breakpoint helpers
                "responsive_layout.dart",     # ResponsiveLayout widget (mobile/tablet/desktop)
                "app_widget_imports.dart",    # Barrel import for all shared widgets
                "app_screen_imports.dart",    # Barrel import for all screen views
                "app_logger.dart",            # Typed per-class logger wrapper
                "shimmer_extension.dart",     # Shimmer loading skeleton helper
            ],
            "services": [
                "local_storage_service.dart",    # GetStorage wrapper — settings, water logs, streaks
                "notification_service.dart",     # flutter_local_notifications + timezone + permissions
                "app_snackbar.dart",             # Reusable GetX snackbar helpers
            ],
        },
        "data": {
            "models": [
                "medicine_model.dart",          # @HiveType(typeId:0) — Medicine schedule entity
                "medicine_model.g.dart",        # Generated Hive adapter (do NOT edit manually)
                "dose_record_model.dart",       # @HiveType(typeId:1) — Daily dose tracking record
                "dose_record_model.g.dart",     # Generated Hive adapter (do NOT edit manually)
            ],
        },
        "routes": [
            "app_pages.dart",   # GetPage route list + AppPages.initial
            "app_routes.dart",  # Routes abstract class (all named route strings)
        ],
        "widgets": [
            "primary_button.dart",          # Branded elevated button with loading state
            "primary_input_field.dart",     # Styled TextFormField with label + validation
            "primary_appbar_widget.dart",   # Consistent AppBar with back/action buttons
            "primary_dropdown.dart",        # Styled DropdownButton wrapper
            "primary_date_picker.dart",     # DatePicker dialog helper widget
            "chip_widget.dart",             # Selectable chip (used for meal relation, day selectors)
            "calendar_widget.dart",         # Compact calendar strip widget
            "progress_bar_widget.dart",     # Animated linear progress bar (water/medicine)
            "rich_text_widget.dart",        # Mixed-style inline text builder
            "text_widget.dart",             # Pre-styled Text variants (H1, Body, Label, Caption)
            "toggle_switch_widget.dart",    # Branded on/off toggle switch
            "water_wave_painter.dart",      # Custom painter for water wave animation
        ],
        "modules": {
            "splash": [
                "bindings/splash_binding.dart",
                "controllers/splash_controller.dart",
                "views/splash_view.dart",           # Animated logo entry point; routes to profile or medicine
                "widgets/splash_widgets.dart",
            ],
            "profile": [
                "bindings/profile_binding.dart",
                "controllers/profile_controller.dart",  # BMI calc, water target calibration, height converter
                "views/profile_view.dart",              # Full profile dashboard with BMI card & suggestions
                "views/profile_setup_view.dart",        # First-launch profile creation form
            ],
            "medicine": [
                "bindings/medicine_binding.dart",
                "controllers/medicine_controller.dart",  # Add/delete/toggle, dose records, notification bootstrap
                "views/medicine_view.dart",              # Home dashboard: today's dose list + calendar strip
                "views/add_medicine_view.dart",          # Full medicine creation / edit form (11 types)
                "views/medicine_details_view.dart",      # Single medicine detail + dose history
                "views/full_screen_alarm_view.dart",     # Lock-screen alarm UI (Taken / Snooze / Skip)
            ],
            "water_intake": [
                "bindings/water_intake_binding.dart",
                "controllers/water_intake_controller.dart",  # Log water, update target, reschedule reminders
                "views/water_intake_view.dart",              # Water tracker: progress ring, quick logs, 7-day chart
            ],
            "health_tips": [
                "views/health_tips_view.dart",   # Offline health blog: category accordion + tip cards
            ],
            "menu": [
                "views/menu_view.dart",                    # Utilities hub: stock, streaks, badges, theme switcher
                "views/notification_settings_view.dart",   # Water reminder schedule + medicine alarm settings
                "views/reminder_history_view.dart",        # Chronological dose & water activity log
            ],
        },
    },
}

# ======================
# Template code for Dart files
# ======================
PACKAGE_NAME = "my_structure"  # ← Change to your actual package name (found in pubspec.yaml > name)

template_code = {
    "default": "// TODO: Implement {filename}\n",

    "view": """\
import 'package:flutter/material.dart';
import 'package:{package}/app/core/utils/responsive_helper.dart';

class {{classname}} extends StatelessWidget {{
  const {{classname}}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    // TODO: Implement {{classname}}
    return const Scaffold(
      body: Center(child: Text('{{classname}}')),
    );
  }}
}}
""".replace("{package}", PACKAGE_NAME),

    "controller": """\
import 'package:get/get.dart';

class {classname} extends GetxController {{
  @override
  void onInit() {{
    super.onInit();
    // TODO: Initialize state
  }}
}}
""",

    "binding": """\
import 'package:get/get.dart';
import '../controllers/{controller_file}.dart';

class {{classname}} extends Bindings {{
  @override
  void dependencies() {{
    Get.lazyPut<{{controller_class}}>(() => {{controller_class}}());
  }}
}}
""",
}

# ======================
# Helper functions
# ======================
def to_class_name(filename: str) -> str:
    """Converts snake_case filename to PascalCase class name."""
    return "".join(w.capitalize() for w in filename.replace(".dart", "").split("_"))


def create_file(path: str, file_type: str = None):
    """Creates a Dart file with appropriate boilerplate if it does not already exist."""
    if os.path.exists(path):
        return  # Never overwrite existing files

    os.makedirs(os.path.dirname(path), exist_ok=True)
    filename = os.path.basename(path)
    classname = to_class_name(filename)

    if file_type == "view":
        content = template_code["view"].format(classname=classname)
    elif file_type == "controller":
        content = template_code["controller"].format(classname=classname)
    elif file_type == "binding":
        controller_class = classname.replace("Binding", "Controller")
        controller_file = filename.replace("_binding.dart", "_controller")
        content = template_code["binding"].format(
            classname=classname,
            controller_class=controller_class,
            controller_file=controller_file,
        )
    else:
        content = template_code["default"].format(filename=filename)

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  Created: {path}")


def create_structure(base_path: str, struct: dict):
    """Recursively walks the structure dict and creates folders + files."""
    for key, value in struct.items():
        if isinstance(value, dict):
            create_structure(os.path.join(base_path, key), value)
        elif isinstance(value, list):
            for file_path in value:
                full_path = os.path.join(base_path, key, file_path)
                # Determine file type by its path segment
                segments = file_path.replace("\\", "/").split("/")
                leaf = segments[-1]
                if "view" in leaf and "widget" not in leaf:
                    create_file(full_path, "view")
                elif "controller" in leaf:
                    create_file(full_path, "controller")
                elif "binding" in leaf:
                    create_file(full_path, "binding")
                else:
                    create_file(full_path)
        else:
            # Single string value (shouldn't normally happen with this structure)
            full_path = os.path.join(base_path, key, value)
            create_file(full_path)


def add_module(module_name: str):
    """
    Quickly scaffold a brand-new feature module under lib/app/modules/<module_name>.

    Usage:
        python abirdev_flutter_structure.py --module my_feature

    Creates:
        lib/app/modules/my_feature/
            bindings/my_feature_binding.dart
            controllers/my_feature_controller.dart
            views/my_feature_view.dart
            widgets/my_feature_widgets.dart
    """
    module_path = os.path.join(LIB_PATH, "app", "modules", module_name)
    files = [
        ("bindings", f"{module_name}_binding.dart", "binding"),
        ("controllers", f"{module_name}_controller.dart", "controller"),
        ("views", f"{module_name}_view.dart", "view"),
        ("widgets", f"{module_name}_widgets.dart", None),
    ]
    print(f"\nScaffolding module: {module_name}")
    for folder, filename, ftype in files:
        create_file(os.path.join(module_path, folder, filename), ftype)
    print(f"Module '{module_name}' scaffolded. Remember to:")
    print(f"  1. Add route constant to lib/app/routes/app_routes.dart")
    print(f"  2. Register GetPage in lib/app/routes/app_pages.dart")


# ======================
# Entry point
# ======================
if __name__ == "__main__":
    import sys

    args = sys.argv[1:]

    if "--module" in args:
        idx = args.index("--module")
        if idx + 1 < len(args):
            add_module(args[idx + 1])
        else:
            print("Usage: python abirdev_flutter_structure.py --module <module_name>")
    else:
        print("Creating ShifaTime project structure...")
        create_structure(LIB_PATH, structure)
        print("\nDone! All folders and template files are ready.")
        print("Tip: To add a new module, run:")
        print("     python abirdev_flutter_structure.py --module <module_name>")
