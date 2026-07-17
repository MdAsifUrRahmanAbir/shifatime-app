# ShifaTime - Product Concept & Feature Specification

## 🌟 Executive Summary
**ShifaTime** is a patient-centric, offline-first mobile companion application designed to simplify daily health routines. It helps users manage two critical pillars of daily wellness:
1. **Medication Adherence**: Timely exact reminder alarms for prescriptions.
2. **Daily Hydration**: Statistics, logging, and scheduled notification reminders for consistent water intake.

The application operates **100% locally** on the user's mobile device, ensuring absolute data privacy and allowing it to work seamlessly without cellular service, internet access, or cloud account setups.

---

## 💡 Value Proposition
Consistency is a vital element of recovery and general wellness. ShifaTime makes tracking health targets effortless. 

By avoiding complex online account registrations, network latency, or data privacy risks, the application serves as a rapid, reliable health utility that remains functional in any situation.

---

## 🎨 User Experience & Design Philosophy
ShifaTime is designed to feel clean, friendly, and visually rewarding:
- **Calm, High-Contrast Interface**: Built on a soft off-white background with distinct dark text readability.
- **Brand Highlights**: Important selections, selected weekdays, progress charts, and active cards are highlighted using a saturated pastel **lime-green** accent color (`0xFF2FAC66` in dark mode).
- **Engaging Visuals**: Custom-built stats charts, progress indicators, responsive layouts, and simple actions make logging feel engaging.

---

## 🚀 Core Features & Business Logic

### 1. Personalized Health Profiles
Upon launching the app for the first time, the user is guided to create an offline health profile. This profile drives all health calibrations in the app.
*   **Flexible Measurement Inputs**: Users can enter their height using either **centimeters (cm)** or **feet and inches (ft/in)**. The application automatically normalizes this information in the background.
*   **Automatic BMI Calculator**: Instantly computes the user's Body Mass Index (BMI) using their height and weight.
*   **Dynamic Category Badging**: Classifies the user's weight profile under standard medical guidelines (*Underweight*, *Normal Weight*, *Overweight*, *Obese*).
*   **Actionable Health Suggestions**: Displays dietary and lifestyle suggestions tailored to the computed BMI category.
*   **Calibrated Water Targets**: Uses the profile data to automatically calculate a recommended daily water intake volume target.

---

### 2. Smart Medication Reminder System
The medicine scheduler allows users to catalog and organize their prescription details.
*   **11 Supported Form Types**: Supports Tablets (💊), Capsules (🟢), Syrups (🧴), Injections (💉), Creams/Gels (🩹), Eye Drops (💧), Ear Drops (👂), Nasal Sprays (👃), Inhalers (🌫), Patches (🩹), and Others (💊).
*   **Dynamic Dosage & Sizing**: Automatically adapts intake choices based on the chosen form type (e.g. tablet counts, milliliter logs, thin/thick application layers, drop sizes, and puffs), plus allows entering custom dosage specifications.
*   **Application Area**: Optionally tracks where creams, drops, sprays, or patches should be applied on the body (e.g., Face, Forehead, Eye, Ear, Hands).
*   **Meal Relation Context**: Groups schedules based on meal times (*Before Meal*, *After Meal*, *Empty Stomach*, *With Meal*, *Not Related*) to align reminders with proper medical instructions.
*   **Usage Instructions & Presets**: Allows logging quick notes or instructions (e.g., "Shake well before use", "Apply only at night", "Take with warm water").
*   **Flexible Recurrence Schedules**:
    *   *Daily*: Standard daily reminders.
    *   *Specific Duration*: Reminders that automatically stop after a set number of days, weeks, or months.
    *   *Selected Weekdays*: Alarms that only sound on chosen days (e.g., Mondays, Wednesdays, and Fridays).
*   **On-Time Customized Notifications**: Dispatches push alerts at reminder times. The notification titles automatically display custom emoji icons based on the medicine type (e.g., 💊 for tablets, 🧴 for syrups) and detailed application steps.
*   **Direct Lock Screen Action**: Allows users to quickly mark a reminder as "Taken" or "Snoozed" directly from the notification block without launching the full app.

---

### 3. Hydration Statistics (Water Tracker)
A dashboard focused on building consistent water drinking habits.
*   **Intake Target Tracker**: Compares the user's logged intake against their customized daily target.
*   **Quick Logging Buttons**: Offers tap-to-log containers for standard drink sizes:
    *   *Cup* (150 ml)
    *   *Glass* (250 ml)
    *   *Bottle* (500 ml)
    *   *Custom*: A keypad entry option for logging custom amounts.
*   **Weekly Statistics Chart**: Displays a 7-day bar chart showing logged water intake percentages. The current weekday is highlighted in a distinct green color, helping users easily monitor compliance streaks over the week.
*   **Active Logging History**: Lists all logs saved today chronologically with single-tap deletion options to correct accidental logs.
*   **Smart Rescheduling Loop**: Water reminders are scheduled for defined intervals within the user's start/end hours. To prevent drift and ensure accurate timezone adjustments, they do not repeat indefinitely; instead, individual one-shot notifications are scheduled dynamically each day, and automatically cancel once the daily goal is reached (Smart Stop).

---

### 4. Medicine Stock & Refill Reminders
Prevents users from unexpectedly running out of critical medications.
*   **Total Inventory Tracking**: When configuring a medicine schedule, users can enter their starting inventory quantity (e.g. "30 tablets").
*   **Automatic Depletion**: Every time the user marks a reminder dose as "Taken", the remaining stock count is automatically reduced by the dosage amount.
*   **Low Stock Threshold Alarms**: Users can set an alert threshold limit (e.g. "Warn me when only 5 tablets remain"). When stock drops to or below this threshold, a local push notification immediately prompts the user to refill their supply.
*   **Quick Refill Controls**: The menu inventory list features direct button options to replenish stock levels quickly (e.g. adding 10, 30, or 50 to the remaining count).

---

### 5. Daily Health Streaks & Achievements
Drives positive behavioral reinforcement by rewarding consistent daily adherence.
*   **Daily Hydration Streak**: Tracks the consecutive number of days the user met their recommended water target.
*   **Medicine Intake Streak**: Tracks consecutive active days of taking scheduled medications without missing.
*   **Achievement Badge Milestones**: Provides unlockable virtual badges representing consistency and hydration milestones.

---

### 6. Offline Health Library & Tip of the Day
Educates users on vital daily health practices completely offline.
*   **Daily Random Health Tips**: Every day, the Home Dashboard highlights a random health tip selected from the app's local repository.
*   **Category-Based Health Blog**: Users can browse essential categories (Medicine, Hydration, Sleep, Exercise, Diet, Heart Health, Diabetes, BP, General Wellness). Expanding a category reveals useful tips and practices.

---

## 7. Modern Bottom Navigation
Organizes features cleanly across a premium bottom navigation bar:
*   **Home (Dashboard)**: Daily schedules list, calendar strips, and the Today's Health Tip widget.
*   **Progress**: Weekly water statistic charts, BMI cards, and intake ratios.
*   **Central Quick Add Button**: A central lime-green button for quick medication setups.
*   **Blog**: The offline Health Tips Library.
*   **Menu**: A centralized utilities dashboard containing Profile Settings, Stock Inventory controls, Streak summaries, Badge checklists, and a Light/Dark Theme switcher.

---

## 🛠️ Technical Architecture & Implementation Spec

### 100% Offline Architecture
*   **Storage**: State & user options are stored in **GetStorage**. The main structured entities (Medicines and Dose Records) use **Hive** boxes, structured as high-performance NoSQL tables.
*   **No Firebase**: The app features no external servers, FCM push servers, or polling loops.
*   **No Redundant Background Tasks**: Removed `android_alarm_manager_plus`, `workmanager`, or manual `Timer` loops. All scheduling is managed by the OS's native alarm systems via `flutter_local_notifications`.

### Alarm Engine (NotificationService)
*   **Notification Engine**: Backed by `flutter_local_notifications` using `zonedSchedule()`.
*   **Device Timezone Synchronization**: Handled at runtime using `flutter_timezone`. The actual device IANA timezone identifier (e.g. `Asia/Dhaka`) is resolved at app initialization, handling daylight saving changes correctly.
*   **Exact Alarm Approvals**: Required exact alarm scheduling uses `SCHEDULE_EXACT_ALARM` permissions. If the permission is missing (Android 12+), the scheduling logic gracefully falls back to inexact (`AndroidScheduleMode.inexact`) to avoid crashes.
*   **Startup Notification Bootstrap**: Every time the app boots, a bootstrap task executes:
    1. Generates today's dose records.
    2. Marks doses that have passed by more than 1 hour as missed.
    3. Reschedules all pending medicine alarms for today and tomorrow.
    4. Reschedules remaining water reminders for the day.
*   **Device Reboot Recovery**: Declared native OS receivers (`BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`, `QUICKBOOT_POWERON`) in `AndroidManifest.xml` routing to `ScheduledNotificationBootReceiver`. The plugin automatically restores the OS alarms matching local database states upon restart.
