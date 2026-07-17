# Codebase Documentation: ShifaTime (Medicine & Water Reminder App)

This file serves as a comprehensive system guide and instructions manual for the **ShifaTime** Flutter project. If you are an AI assistant, an agent, or a new developer starting work on this codebase, **read this file first** to understand the architecture, data flow, dependencies, and code guidelines before making any changes.

---

## 🗺️ Project Overview
**ShifaTime** is a mobile Flutter application designed to help users track and take their medicine on time, and stay hydrated throughout the day. Key capabilities include:
- Scheduling **exact-time local notifications** for medicine reminders (using Android AlarmManager via `flutter_local_notifications`).
- Managing a local list of medicines (11 types: Tablet, Capsule, Syrup, Injection, Cream, Eye Drop, Ear Drop, Nasal Spray, Inhaler, Patch, Other).
- Tracking **daily water intake** with configurable reminder windows and smart stop.
- Persisting all data locally using **Hive** (medicines, dose records, activity logs).
- Lightweight preferences and settings stored via **GetStorage**.

**Offline-First Architecture**: The application operates **100% locally**. It contains no Firebase configurations, no external backend integrations, and no network API clients. All data lives on the device.

---

## 🛠️ Tech Stack & Key Libraries

| Library | Version | Role in Project |
| :--- | :--- | :--- |
| **`get`** | `^4.6.5` | State management, dependency injection, and named routing. |
| **`get_storage`** | `^2.1.1` | Lightweight key-value store for settings, water logs, streaks, notification preferences. |
| **`hive`** / **`hive_flutter`** | `^2.2.3` / `^1.1.0` | Local NoSQL database for Medicine and DoseRecord models. |
| **`flutter_local_notifications`** | `21.0.0` | Schedules exact medicine alarms + water reminders via Android AlarmManager. |
| **`timezone`** | `0.11.0` | Provides `TZDateTime` needed by `zonedSchedule()`. |
| **`flutter_timezone`** | `^3.0.0` | Reads the real device IANA timezone (e.g. `Asia/Dhaka`) at runtime. |
| **`permission_handler`** | `^11.0.0` | Requests `POST_NOTIFICATIONS` (Android 13+) at runtime. |
| **`device_info_plus`** | `^10.0.0` | Reads Android SDK version to decide which permissions to request. |
| **`google_fonts`** | `8.0.2` | Outfit font family for all typography. |
| **`hive_generator`** | `^2.0.1` | (dev) Generates `*.g.dart` Hive adapters from `@HiveType` annotations. |
| **`build_runner`** | latest | (dev) Runs code generation for Hive adapters. |

> ❌ **Do NOT add**: `firebase_messaging`, `workmanager`, `background_fetch`, `android_alarm_manager_plus` — none are needed for a local alarm app and they were previously removed.

---

## 🗂️ Codebase Directory Structure

```
shifatime-app/
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml       # Permissions + flutter_local_notifications receivers
│       └── kotlin/.../MainActivity.kt
├── lib/
│   ├── main.dart                     # Entry point: calls AppInitial.init() then runApp()
│   ├── app_initial.dart              # Startup: GetStorage, Hive, NotificationService.init()
│   └── app/
│       ├── core/
│       │   ├── constants/            # AppColors, AppSizes, AppStrings
│       │   ├── theme/                # AppTheme (light + dark, Google Fonts)
│       │   ├── utils/                # ResponsiveHelper, barrel imports, logger, shimmer
│       │   └── services/
│       │       ├── local_storage_service.dart   # All GetStorage read/write helpers
│       │       ├── notification_service.dart    # ← Core alarm engine (see details below)
│       │       └── app_snackbar.dart
│       ├── data/
│       │   └── models/
│       │       ├── medicine_model.dart          # @HiveType(typeId:0)
│       │       ├── medicine_model.g.dart        # ← Auto-generated, do NOT edit
│       │       ├── dose_record_model.dart       # @HiveType(typeId:1)
│       │       └── dose_record_model.g.dart     # ← Auto-generated, do NOT edit
│       ├── routes/
│       │   ├── app_pages.dart        # GetPage list
│       │   └── app_routes.dart       # Routes abstract class (named route strings)
│       ├── widgets/                  # Reusable UI components (see widget catalogue below)
│       └── modules/
│           ├── splash/               # Animated splash → routes to profileSetup or medicine
│           ├── profile/              # Profile setup + BMI dashboard
│           ├── medicine/             # Medicine home, add/edit form, details, full-screen alarm
│           ├── water_intake/         # Water tracker dashboard + weekly chart
│           ├── health_tips/          # Offline health blog (category accordion)
│           └── menu/                 # Menu hub: stock, streaks, badges, notification settings
├── abirdev_flutter_structure.py      # Scaffold script — generates module boilerplate
├── claude.md                         # ← You are reading this
└── projectConcept.md                 # Product feature spec & UX philosophy
```

---

## ⚙️ App Initialization & Startup Flow

```
main()
  └─ AppInitial.init()
       ├─ GetStorage.init()
       ├─ Hive.initFlutter() + register adapters + open boxes
       ├─ NotificationService.init()
       │     ├─ tz.initializeTimeZones()
       │     ├─ FlutterTimezone.getLocalTimezone() → tz.setLocalLocation()
       │     ├─ FlutterLocalNotificationsPlugin.initialize()
       │     └─ _createNotificationChannels()
       └─ SystemChrome.setPreferredOrientations([portraitUp, portraitDown])
  └─ runApp(MyApp)
       └─ GetMaterialApp → initialRoute: Routes.splash
            └─ SplashController.onReady()
                 └─ Routes to Routes.profileSetup (first launch) OR Routes.medicine
```

On app launch, `MedicineController.onInit()` runs `_bootstrapNotifications()` which:
1. Generates today's dose records for all active medicines.
2. Reschedules ALL pending medicine alarms (repairs after OS kill or reboot).
3. Schedules today's remaining water reminders.
4. Shows the permission dialog (once per install).

---

## 💾 State Management & Data Flow

Every feature module follows this pattern:
- **Binding**: Registers controller lazily via `Get.lazyPut()`.
- **Controller**: Manages reactive state (`Rx`/`.obs`), reads/writes Hive or GetStorage, calls `NotificationService`.
- **View**: Extends `GetView<XController>`. Uses `Obx()` for reactive rebuilds.

### Key Controllers

| Controller | Location | Responsibility |
|:---|:---|:---|
| `MedicineController` | `medicine/controllers/` | CRUD for medicines, dose record generation, notification bootstrap, snooze/take/skip logic, stock deduction |
| `WaterIntakeController` | `water_intake/controllers/` | Log water amounts, delete logs, update target, trigger `rescheduleWaterReminders()` |
| `ProfileController` | `profile/controllers/` | Save user demographics, BMI calculation, water target calibration, height unit conversion |

---

## 🔔 Notification Architecture

> **Rule**: Never use `Timer`, `Future.delayed`, or `Stream.periodic` for alarms. Always use `NotificationService.scheduleNotification()` which calls `zonedSchedule()` → Android AlarmManager.

### NotificationService (`lib/app/core/services/notification_service.dart`)

**Initialization** (called once in `AppInitial.init()`):
1. `tz.initializeTimeZones()` — loads all IANA zone data.
2. `FlutterTimezone.getLocalTimezone()` → `tz.setLocalLocation()` — sets the real device timezone (e.g. `Asia/Dhaka`).
3. `FlutterLocalNotificationsPlugin.initialize()` — registers foreground + background handlers.
4. `_createNotificationChannels()` — creates 6 Android notification channels (once, idempotent).

**Notification Channels** (created once, never recreated per notification):

| Channel ID | Name | Use |
|:---|:---|:---|
| `medicine_default` | Medicine Alarms | Default system alarm sound |
| `medicine_custom` | Medicine Alarms (Custom) | Custom `alarm_sound` raw resource |
| `medicine_silent` | Medicine Alarms (Silent) | No sound, no vibration |
| `medicine_vibrate` | Medicine Alarms (Vibrate) | Vibration only |
| `water_reminders` | Water Reminders | Periodic hydration alerts |
| `stock_alerts` | Medicine Stock Alerts | Low-stock push notifications |

**Key Methods**:
- `scheduleNotification(id, title, body, scheduledDate, payload, isAlarm)` — schedules one medicine alarm using `zonedSchedule()`. Uses exact alarms if `SCHEDULE_EXACT_ALARM` is granted, inexact fallback otherwise.
- `rescheduleWaterReminders(current, target)` — cancels all water slots, then schedules individual one-shot notifications (IDs 9000–9059) for each time slot from now until end-of-window. **No `matchDateTimeComponents`** — reminders fire once and are re-scheduled fresh each day.
- `scheduleDailyWaterReminders()` — called at startup; reads today's current intake and calls `rescheduleWaterReminders`.
- `cancelWaterReminders()` — cancels notification IDs 9000–9059.
- `requestPermissionsWithConfirmation()` — shows a branded dialog once per install; requests `POST_NOTIFICATIONS` (Android 13+) and `SCHEDULE_EXACT_ALARM` (Android 12+).

**Background Handler** (`notificationTapBackground`):
- Annotated `@pragma('vm:entry-point')` — called in a separate isolate when notifications are tapped while app is killed.
- Handles: `taken` (marks dose, logs, deducts stock), `skip` (marks dose), `water_add_X` (logs water, reschedules).
- Initializes its own Hive + GetStorage instances since it runs in isolation.

**Boot Receiver** (AndroidManifest.xml):
```xml
com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver
```
Listens for `BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`, `QUICKBOOT_POWERON` — Android clears AlarmManager alarms on reboot; this receiver reschedules them via the plugin's own restore mechanism.

---

## 💾 Data Models

### Medicine (`@HiveType(typeId: 0)`)
Fields: `id`, `name`, `type`, `dosage`, `reminderTimes` (list of `"HH:mm"` or named slots like `"Sokal"`), `mealRelation`, `isActive`, `durationType`, `durationValue`, `durationUnit`, `totalStock`, `stockThreshold`, `isStockAlertEnabled`, `customDosage`, `applicationArea`, `usageInstruction`, `startDate`, `snoozeCount`, `snoozeUntil`.

Named time slots resolved in `MedicineController`:
| Slot | Time |
|:---|:---|
| Sokal | 08:00 |
| Dupur | 14:00 |
| Bikal | 17:00 |
| Rat | 22:00 |

### DoseRecord (`@HiveType(typeId: 1)`)
Fields: `id` (key: `medicineId_dateStr_index`), `medicineId`, `medicineName`, `timeStr`, `dateStr` (`yyyy_MM_dd`), `status` (`pending`/`taken`/`skipped`/`missed`/`snoozed`), `takenTime`, `snoozeUntil`, `customDosage`, `medicineType`, `mealRelation`.

### Hive Boxes
| Box | Type | Contents |
|:---|:---|:---|
| `medicines` | `Box<Medicine>` | All medicine schedules |
| `dose_records` | `Box<DoseRecord>` | Daily dose tracking records |
| `activity_logs` | `Box<dynamic>` | All taken/skipped/water log events |

---

## 🗝️ LocalStorage Keys (GetStorage)

All keys are private constants in `local_storage_service.dart`. Key groups:

| Group | Keys |
|:---|:---|
| Auth/Onboard | `tokenKey`, `isLoggedInKey`, `isOnBoardDoneKey` |
| User profile | `nameKey`, `userAge`, `userHeight`, `userWeight`, `userGender` |
| Water | `userWaterTarget`, `waterIntakeHistory_<date>`, `waterFreqMin`, `waterStartHour`, `waterStartMin`, `waterEndHour`, `waterEndMin`, `waterReminderEnabled`, `waterSmartStop` |
| Streaks | `waterStreak`, `medicineStreak`, `medicinesTakenCount`, `waterGlassesCount`, `lastActiveDate` |
| Alarm settings | `fsAlarmEnabled`, `repeatAlarmEnabled`, `repeatIntervalMin`, `maxRepeatCount`, `reminderSoundType` |
| Permissions | `permissions_requested` |
| Theme | `isDarkModeKey` |

---

## 🎨 Widget Catalogue

Located in `lib/app/widgets/` — always use these instead of ad-hoc construction:

| Widget | File | Description |
|:---|:---|:---|
| `PrimaryButton` | `primary_button.dart` | Branded elevated button with optional loading spinner |
| `PrimaryInputField` | `primary_input_field.dart` | Styled TextFormField with label, hint, validation |
| `PrimaryAppBarWidget` | `primary_appbar_widget.dart` | Consistent AppBar with back + action buttons |
| `PrimaryDropdown` | `primary_dropdown.dart` | Styled dropdown with label |
| `PrimaryDatePicker` | `primary_date_picker.dart` | Date picker trigger widget |
| `ChipWidget` | `chip_widget.dart` | Selectable chip (days, meal relation, types) |
| `CalendarWidget` | `calendar_widget.dart` | Horizontal date-strip selector |
| `ProgressBarWidget` | `progress_bar_widget.dart` | Animated horizontal progress bar |
| `RichTextWidget` | `rich_text_widget.dart` | Mixed-style inline text |
| `TextWidget` | `text_widget.dart` | Pre-styled Text (H1–H4, Body, Label, Caption) |
| `ToggleSwitchWidget` | `toggle_switch_widget.dart` | Branded on/off toggle |
| `WaterWavePainter` | `water_wave_painter.dart` | Custom painter for animated water fill |

---

## 🗺️ Named Routes

| Route Constant | Path | View |
|:---|:---|:---|
| `Routes.splash` | `/splash` | `SplashView` |
| `Routes.profile` | `/profile` | `ProfileView` |
| `Routes.profileSetup` | `/profile_setup` | `ProfileSetupView` |
| `Routes.medicine` | `/medicine` | `MedicineView` (home dashboard) |
| `Routes.addMedicine` | `/add_medicine` | `AddMedicineView` |
| `Routes.medicineDetails` | `/medicine_details` | `MedicineDetailsView` |
| `Routes.waterIntake` | `/water_intake` | `WaterIntakeView` |
| `Routes.healthTips` | `/health_tips` | `HealthTipsView` |
| `Routes.menu` | `/menu` | `MenuView` |
| `Routes.notificationSettings` | `/notification_settings` | `NotificationSettingsView` |
| `Routes.reminderHistory` | `/reminder_history` | `ReminderHistoryView` |
| `Routes.fullScreenAlarm` | `/full_screen_alarm` | `FullScreenAlarmView` |

---

## 💡 Developer Guidelines

### 1. Adding a New Screen / Feature
```bash
# Option A: Use the scaffold script
python abirdev_flutter_structure.py --module <module_name>

# Option B: Manually create binding + controller + view
```
Then:
1. Add route constant to `app_routes.dart`.
2. Register `GetPage` in `app_pages.dart`.

### 2. Updating Hive Models
If you add/modify fields in any `*_model.dart`:
1. Increment the `@HiveField` index (never reuse indices).
2. Regenerate adapters:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. If adding a **new model class**:
   - Assign a unique `@HiveType(typeId: N)` (next available: **2**).
   - Register its adapter in `AppInitial.init()`.
   - Open its Hive box in `AppInitial.init()`.

### 3. Scheduling Notifications
Always use `NotificationService` — never raw timers:
```dart
// ✅ Correct
await NotificationService.scheduleNotification(
  id: dose.id.hashCode,
  title: 'Time to take Medicine',
  body: 'Dosage: 1 Tablet • After Meal',
  scheduledDate: DateTime(2026, 7, 17, 8, 0),
  payload: 'med_${dose.id}',
  isAlarm: true,
);

// ❌ Wrong — stops when app is killed
Future.delayed(Duration(hours: 1), () => showNotification());
Timer.periodic(Duration(hours: 1), (_) => showNotification());
```

### 4. Local Storage Preferences
- Always use the `LocalStorage` static class — never create a new `GetStorage()` box directly.
- Declare new keys as private constants at the top of `local_storage_service.dart`.
- Expose via static getters/setters.

### 5. Android Permissions (AndroidManifest.xml)
Currently declared:
- `POST_NOTIFICATIONS` — runtime request on Android 13+
- `SCHEDULE_EXACT_ALARM` — runtime request on Android 12+ (via system settings redirect)
- `RECEIVE_BOOT_COMPLETED` — via `ScheduledNotificationBootReceiver`
- `VIBRATE`, `WAKE_LOCK`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_SPECIAL_USE`

### 6. Code & UI Consistency
- Use `Obx()` for any widget that reads `.obs` state.
- Type all controller properties explicitly (`var count = 0.obs` → `RxInt`).
- Use widgets from `lib/app/widgets/` — never construct raw `TextField` or `ElevatedButton` inline.
- Use `AppColors`, `AppSizes`, `AppStrings` constants — never hardcode colors, sizes, or user-visible strings.
- Use `GoogleFonts.outfit(...)` for all text styles — matches `AppTheme`.
