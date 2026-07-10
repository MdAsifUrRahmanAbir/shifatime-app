# Codebase Documentation: ShifaTime (Medicine Reminder App)

This file serves as a comprehensive system guide and instructions manual for the **ShifaTime** Flutter project. If you are an AI assistant, an agent, or a new developer starting work on this codebase, **read this file first** to understand the architecture, data flow, dependencies, and code guidelines before making any changes.

---

## 🗺️ Project Overview
**ShifaTime** is a mobile/multi-platform Flutter application designed to help users track and take their medicine on time. Key capabilities include:
- Scheduling notifications for medicine times (e.g., Sokal, Dupur, Bikal, Rat, and Custom times).
- Managing a local list of medicines (Tablet, Syrup, Injection, Capsule) and durations (Nonstop, Specified, Specific Days).
- Persisting medicine schedules locally using **Hive**.
- Handling status changes and automatically scheduling/canceling local notifications.

**Offline-First Architecture**: The application operates **100% locally**. It contains no Firebase configurations, no external backend integrations, and no network API clients. All user configurations, themes, and medicine databases are cached locally on the device.

---

## 🛠️ Tech Stack & Key Libraries
The application is built on **Flutter (SDK ^3.9.2)** and leverages the following core libraries (defined in [pubspec.yaml](file:///c:/Users/mdasi/StudioProjects/shifatime-app/pubspec.yaml)):

| Library | Version | Role in Project |
| :--- | :--- | :--- |
| **`get`** | `^4.6.5` | State management, dependency injection, and application routing. |
| **`get_storage`** | `^2.1.1` | Lightweight persistent key-value store (replaces SharedPreferences) for user settings, preferences, theme mode, and localization. |
| **`hive`** / **`hive_flutter`** | `^2.2.3` / `^1.1.0` | Local NoSQL database used to persist medicine schedules/models with generator support (`hive_generator`). |
| **`flutter_local_notifications`** | `21.0.0` | Handles scheduling medicine reminders (including exact zoned alarms and customized actions like "Taken" or "Snooze"). |
| **`android_alarm_manager_plus`** | `5.0.0` | Handles background execution and alarms on Android. |
| **`timezone`** | `0.11.0` | Handles zoned date-times needed by local notifications to schedule repeating daily alarms. |
| **`google_fonts`** | `8.0.2` | Typographic design system font resources. |

---

## 🗂️ Codebase Directory Structure
The workspace follows a custom modular GetX-like pattern structured as follows:

```
shifatime-app/
├── lib/
│   ├── app/
│   │   ├── core/                  # Shared core services, utils, themes, and constants
│   │   │   ├── constants/         # Styles, colors, strings, and sizes constants
│   │   │   ├── services/          # Services (Local storage, Notifications, etc.)
│   │   │   ├── theme/             # Global themes (Light, Dark, and theme configurations)
│   │   │   └── utils/             # Responsive helpers, layouts, and logger tools
│   │   ├── data/                  # Data models
│   │   │   └── models/            # Hive models and local DB data classes
│   │   ├── modules/               # Feature-based UI blocks (bindings, controllers, views)
│   │   │   ├── medicine/          # Dashboard, Details page, Add/Edit medicine form
│   │   │   └── splash/            # Animated splash screen
│   │   ├── routes/                # Navigation routes definition
│   │   └── widgets/               # Reusable UI components (Buttons, TextFields, Chips, etc.)
│   ├── main.dart                  # Application entry point
│   ├── app_initial.dart           # Startup initializers (Hive, storage, notifications)
└── abirdev_flutter_structure.py  # Automation Python script for scaffolding views/controllers
```

---

## ⚙️ App Initialization & Startup Flow
When the application starts, it boots via [main.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/main.dart). Before `runApp`, it runs the asynchronous initializer:

### 🧩 [AppInitial](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app_initial.dart)
This static class runs standard system setup procedures:
1. `WidgetsFlutterBinding.ensureInitialized()` is invoked.
2. **`GetStorage`** is initialized for local settings/caches.
3. **`Hive`** is initialized; the [MedicineAdapter](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/data/models/medicine_model.g.dart) is registered, and the `medicines` box is opened.
4. **`NotificationService`** is initialized (setting up channel specs, tapping behaviors, and initializing time zones).
5. **`AndroidAlarmManager`** is initialized for background processes.
6. Preferred device orientations are locked to portrait (`portraitUp`, `portraitDown`).
7. Theme selection (Light/Dark Mode) is resolved by fetching preference from `LocalStorage`.

---

## 💾 State Management & Data Flow
The project relies on **GetX** for dependency injection and state tracking.

### 🧪 State & Modules
Every feature module in `lib/app/modules/` is separated into:
- **Binding**: Registers controllers lazily using `Get.lazyPut()`.
- **Controller**: Manages reactive state (`Rx` properties), performs background computations, and interacts with repositories or databases.
- **Views**: Displays the UI. It usually extends `GetView<FeatureController>` to easily access the bound controller without boilerplate.
  - To support responsive styling, views are divided into `*_view.dart` (the main parent selector), `*_mobile.dart`, `*_tablet.dart`, and `*_desktop.dart`.

### 🔄 Data Models
- **[Medicine](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/data/models/medicine_model.dart)**: Annotated with `@HiveType(typeId: 0)`. Extends `HiveObject` to support active updates and deletion directly.
  - *Fields*: `id`, `name`, `type` (Tablet, Syrup, Injection, Capsule), `dosage` (quantity), `reminderTimes` (e.g. `["08:00", "Rat"]`), `mealRelation` (Before Meal, After Meal, Empty Stomach), `isActive`, `durationType` (Nonstop, Specified, Specific Days), `durationValue` (e.g. `"7"` or `"Mon,Tue"`), and `durationUnit` (Days, Weeks, Months).

---

## 📡 Core Services Details

### 🔑 [LocalStorage Service](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/services/local_storage_service.dart)
Wraps **GetStorage** caching. Provides static helpers to read/write settings securely:
- User configuration flags (`isLoggedIn`, `isOnboardDone`).
- App configuration (`isDarkMode`, `languageKey`, `locale`).
- Supports an dynamic theme switcher: `LocalStorage.switchTheme()` which toggles the cache and triggers `Get.changeThemeMode()`.

### 🔔 [NotificationService](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/services/notification_service.dart)
Wraps **FlutterLocalNotificationsPlugin**:
- Sets up channel ID `'medicine_reminders'` with High Importance and Max Priority.
- Defines standard Action buttons for notifications: **Taken** and **Snooze**.
- Exposes `scheduleNotification()` which takes `scheduledDate` (converted to a localized `TZDateTime`) and schedules alarm slots.
- Provides `cancelNotification(int id)` and `cancelAllNotifications()`.

---

## 🎨 Layout, Styles & Themes
Design tokens are centralized inside [lib/app/core/constants/](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/constants):
- **[AppColors](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/constants/app_colors.dart)**: Brand color is a soothing green (`0xFF2FAC66`) coupled with a dark background (`0xFF1C1C1E`) for dark mode.
- **[AppSizes](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/constants/app_sizes.dart)**: Global margin, padding, border radius, and font size definitions.
- **[AppStrings](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/constants/app_strings.dart)**: Centralized localizations and static texts.
- **[AppTheme](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/theme/app_theme.dart)**: Maps Material light and dark color schemas, applying fonts dynamically from Google Fonts.

---

## 💡 Guidelines for Developers & AI Agents

### 1. Adding a New Screen/Feature
- Use the scaffold structure: create a binding, a controller, and responsive view splits.
- You can run the automation script `python abirdev_flutter_structure.py` to auto-generate the binding, controller, and split views for a module.
- Register the new page route inside [app_routes.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/routes/app_routes.dart) and map the view and binding in the `routes` list inside [app_pages.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/routes/app_pages.dart).

### 2. Updating Hive Models
- If you add or modify fields in [medicine_model.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/data/models/medicine_model.dart), ensure you increment the `HiveField` indexes.
- You MUST run the build runner to regenerate the adapter files:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- If you introduce a completely new model class:
  1. Add a unique `@HiveType(typeId: X)` index.
  2. Register the generated adapter class inside the `AppInitial.init()` function in [app_initial.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app_initial.dart).

### 3. Local Storage Preferences
- When caching basic configurations (like toggles, user preferences), **always use the existing [LocalStorage](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/services/local_storage_service.dart) class**.
- Declare your storage key as a private constant at the top of [local_storage_service.dart](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/core/services/local_storage_service.dart) and expose static getters/setters. Do NOT initialize separate boxes in ad-hoc widgets.

### 4. Code and UI Consistency
- Keep code clean, type all controller outputs, and utilize the reactive `Obx()` widget where necessary.
- Ensure state fields use Rx types (e.g. `var medicines = <Medicine>[].obs;`).
- Always use the predefined widgets located in [widgets directory](file:///c:/Users/mdasi/StudioProjects/shifatime-app/lib/app/widgets/) (such as `PrimaryButton`, `PrimaryInputField`, `ProgressBarWidget`, etc.) rather than manually constructing text fields or buttons, to maintain visual styling.
