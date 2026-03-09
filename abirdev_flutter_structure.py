import os

# ======================
# Project root path
# ======================
ROOT = os.getcwd()  # run in your Flutter project root
LIB_PATH = os.path.join(ROOT, "lib")

# ======================
# Folder & file structure
# ======================
structure = {
    "app": {
        "core": {
            "constants": ["app_colors.dart", "app_strings.dart", "app_sizes.dart"],
            "theme": ["app_theme.dart"],
            "utils": ["responsive_helper.dart"],
            "services": ["api_service.dart"]
        },
        "routes": ["app_pages.dart"],
        "widgets": [
            "primary_button.dart",
            "primary_input_field.dart",
            "primary_appbar_widget.dart",
            "primary_dropdown.dart",
            "primary_date_picker.dart",
            "pin_code_field_widget.dart",
            "rich_text_widget.dart",
            "toggle_switch_widget.dart",
            "chip_widget.dart",
            "calendar_widget.dart",
            "progress_bar_widget.dart"
        ],
        "modules": {
            "splash": ["bindings/splash_binding.dart", "controllers/splash_controller.dart",
                       "views/splash_view.dart", "views/splash_mobile.dart", "views/splash_tablet.dart",
                       "views/splash_desktop.dart", "widgets/splash_widgets.dart"],
            "onboard": ["bindings/onboard_binding.dart", "controllers/onboard_controller.dart",
                        "views/onboard_view.dart", "views/onboard_mobile.dart", "views/onboard_tablet.dart",
                        "views/onboard_desktop.dart", "widgets/onboard_widgets.dart"],
            "home": ["bindings/home_binding.dart", "controllers/home_controller.dart",
                     "views/home_view.dart", "views/home_mobile.dart", "views/home_tablet.dart",
                     "views/home_desktop.dart", "widgets/home_widgets.dart"],
            "profile": ["bindings/profile_binding.dart", "controllers/profile_controller.dart",
                        "views/profile_view.dart", "views/profile_mobile.dart", "views/profile_tablet.dart",
                        "views/profile_desktop.dart", "widgets/profile_widgets.dart"],
            "update_profile": ["bindings/update_profile_binding.dart", "controllers/update_profile_controller.dart",
                               "views/update_profile_view.dart", "views/update_profile_mobile.dart",
                               "views/update_profile_tablet.dart", "views/update_profile_desktop.dart",
                               "widgets/update_profile_widgets.dart"],
            "bottom_nav": ["bindings/bottom_nav_binding.dart", "controllers/bottom_nav_controller.dart",
                           "views/bottom_nav_view.dart", "views/bottom_nav_mobile.dart",
                           "views/bottom_nav_tablet.dart", "views/bottom_nav_desktop.dart",
                           "widgets/bottom_nav_widgets.dart"]
        }
    },
    "auth": {
        "login": ["bindings/login_binding.dart", "controllers/login_controller.dart",
                  "views/login_view.dart", "views/login_mobile.dart", "views/login_tablet.dart",
                  "views/login_desktop.dart", "widgets/login_widgets.dart"],
        "registration": ["bindings/registration_binding.dart", "controllers/registration_controller.dart",
                         "views/registration_view.dart", "views/registration_mobile.dart",
                         "views/registration_tablet.dart", "views/registration_desktop.dart",
                         "widgets/registration_widgets.dart"]
    },
    "settings": {
        "change_password": ["bindings/change_password_binding.dart", "controllers/change_password_controller.dart",
                            "views/change_password_view.dart", "views/change_password_mobile.dart",
                            "views/change_password_tablet.dart", "views/change_password_desktop.dart",
                            "widgets/change_password_widgets.dart"],
        "twofa_security": ["bindings/twofa_security_binding.dart", "controllers/twofa_security_controller.dart",
                           "views/twofa_security_view.dart", "views/twofa_security_mobile.dart",
                           "views/twofa_security_tablet.dart", "views/twofa_security_desktop.dart",
                           "widgets/twofa_security_widgets.dart"]
    }
}

# ======================
# Template code for Dart files
# ======================
template_code = {
    "default": "// TODO: Implement {filename}\n",
    "view": """import 'package:flutter/material.dart';
import 'responsive_helper.dart';  // adjust import if needed

class {classname} extends StatelessWidget {{
  const {classname}({{super.key}});

  @override
  Widget build(BuildContext context) {{
    // TODO: Implement {classname}
    return Container();
  }}
}}
""",
    "controller": """import 'package:get/get.dart';

class {classname} extends GetxController {{
  // TODO: Implement {classname}
}}
""",
    "binding": """import 'package:get/get.dart';
import '../controllers/{controller_file}.dart';

class {classname} extends Bindings {{
  @override
  void dependencies() {{
    Get.lazyPut<{controller_class}>(() => {controller_class}());
  }}
}}
"""
}

# ======================
# Helper functions
# ======================
def create_file(path, file_type=None):
    if not os.path.exists(path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        filename = os.path.basename(path)
        classname = "".join([w.capitalize() for w in filename.replace(".dart", "").split("_")])
        if file_type == "view":
            content = template_code["view"].format(classname=classname)
        elif file_type == "controller":
            content = template_code["controller"].format(classname=classname)
        elif file_type == "binding":
            controller_class = classname.replace("Binding", "Controller")
            controller_file = filename.replace("_binding.dart", "_controller")
            content = template_code["binding"].format(classname=classname,
                                                      controller_class=controller_class,
                                                      controller_file=controller_file)
        else:
            content = template_code["default"].format(filename=filename)
        with open(path, "w") as f:
            f.write(content)
        print(f"Created: {path}")


def create_structure(base_path, struct):
    for key, value in struct.items():
        if isinstance(value, dict):
            create_structure(os.path.join(base_path, key), value)
        elif isinstance(value, list):
            for file_path in value:
                full_path = os.path.join(base_path, key, file_path)
                if "view" in file_path:
                    create_file(full_path, "view")
                elif "controller" in file_path:
                    create_file(full_path, "controller")
                elif "binding" in file_path:
                    create_file(full_path, "binding")
                else:
                    create_file(full_path)
        else:
            # If it's a single file string
            full_path = os.path.join(base_path, key, value)
            create_file(full_path)


# ======================
# Run
# ======================
print("Creating Flutter structure...")
create_structure(LIB_PATH, structure)
print("Done! All folders and template files are created.")
