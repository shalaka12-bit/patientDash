# MedAlert - Patient Emergency Dashboard

A comprehensive Flutter app for emergency healthcare management built from your handwritten notes.

---

## 📱 App Screens

### 1. Splash Screen
- Animated logo with pulsing effect
- Auto-redirects to Login after 3 seconds

### 2. Login Screen
- Email + Password fields
- Form validation
- Forgot password link
- Navigate to Register

### 3. Register Screen (3-Step)
**Step 1 - Personal Info:**
- Full Name, Age, Gender (dropdown), Blood Group (dropdown)

**Step 2 - Contact Info:**
- Mobile Number, Address, Emergency Contact

**Step 3 - Account Setup:**
- Email, Password

### 4. Dashboard (Bottom Navigation)
5 tabs with animated indicator:

#### 🚨 Tab 1: Emergency Report Form
- Emergency Type Dropdown:
  - Accident, Heart Problem, Breathing Difficulty
  - Fever, Surgery, Trauma, Pregnancy, Poisoning, Others
  - If "Others" → text box to type custom type
- Describe Injury/Disease → text area
- Upload Documents:
  - Prescription, Doctor Referral, Medical Report
- Auto Location Detection (Allow button)
- Submit Button → Shows current symptoms dialog:
  - Chest Pain, Breathing Difficulty, Severe Injury
  - Heavy Bleeding, High Fever, Unconscious, Low Oxygen

#### 🏥 Tab 2: Nearest Hospitals List
- Search bar
- Filter chips (ICU, Oxygen, Nearest)
- Hospital cards with:
  - Name, Rating, Distance
  - ICU Available badge
  - Oxygen Available badge
  - Bed count
- Tap hospital → Bottom sheet with:
  - Full details
  - Resource availability (ICU, O₂, Beds)
  - Map/Route view (distance + drive time)
  - "Get Directions" button → opens maps
  - "Book Appointment" button → sends request to admin

#### 🤖 Tab 3: Chatbot Support
- Topics:
  - Hospital resource availability
  - Admission process queries
  - Emergency symptoms guidance
  - General doubts based on emergency
- Quick reply chips
- Typing indicator
- Conversation history

#### 📋 Tab 4: Admission Status
- Overview cards (Total Visits, Admitted, Pending)
- Per record:
  - Hospital name
  - Emergency type
  - Status badge (Pending/Admitted/Discharged/Rejected)
  - Doctor name
  - Admit Date + Time
  - Discharge Date + Time
  - Timeline steps visualization
- Status updated by Admin:
  - Accept Admission / Reject Admission
  - Admit / Discharge with date & time

#### 👤 Tab 5: Profile
- Patient avatar + ID
- Blood group, Gender, Age badges
- All personal details
- Medical Reports history:
  - All reports of that patient
  - Past admitted reports
  - After discharge → visible in profile
  - Each visit generates a report
- Settings (Notifications, Privacy, Help, About)
- Sign Out

---

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android Emulator or Physical Device

### Steps

```bash
# 1. Navigate to project
cd emergency_app

# 2. Install dependencies
flutter pub get

# 3. Run on device/emulator
flutter run

# 4. Build APK
flutter build apk --release

# 5. Build App Bundle (Play Store)
flutter build appbundle --release
```

### iOS Setup
Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>MedAlert needs location to find nearest hospitals</string>
<key>NSCameraUsageDescription</key>
<string>MedAlert needs camera to upload medical documents</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>MedAlert needs gallery access to upload medical documents</string>
```

---

## 📂 Project Structure

```
lib/
├── main.dart                         # App entry point
├── models/
│   ├── app_colors.dart               # Theme colors & gradients
│   └── models.dart                   # Data models (User, Hospital, etc.)
└── screens/
    ├── splash_screen.dart            # Animated splash
    ├── login_screen.dart             # Login with validation
    ├── register_screen.dart          # 3-step registration
    ├── dashboard_screen.dart         # Bottom nav container
    ├── emergency_report_screen.dart  # Emergency form
    ├── hospitals_screen.dart         # Nearest hospitals list
    ├── chatbot_screen.dart           # AI chatbot support
    ├── admission_status_screen.dart  # Admission tracking
    └── profile_screen.dart           # User profile & reports
```

---

## 🔌 Backend Integration Points

Replace these with your actual API calls:

| Feature | Location | Replace |
|---------|----------|---------|
| Login | `login_screen.dart` | `_handleLogin()` |
| Register | `register_screen.dart` | `_handleRegister()` |
| Location | `emergency_report_screen.dart` | `_detectLocation()` |
| Hospitals | `hospitals_screen.dart` | `_loadHospitals()` |
| Submit Report | `emergency_report_screen.dart` | `_submitForm()` |

---

## 🎨 Design System

- **Primary Color:** `#E63946` (Emergency Red)
- **Secondary:** `#1D3557` (Navy Blue)
- **Success:** `#2D9D78` (Medical Green)
- **Font:** Google Fonts - Poppins
- **Border Radius:** 12-16px (cards), 20-24px (sheets)

---

## 📦 Dependencies Used

| Package | Purpose |
|---------|---------|
| `google_fonts` | Poppins typography |
| `geolocator` | GPS location detection |
| `image_picker` | Camera/gallery upload |
| `file_picker` | Document upload |
| `url_launcher` | Open maps, phone calls |
| `shared_preferences` | Local storage |

---

## 🏥 Admin Panel Note
This is the **Patient Dashboard**. The Admin Panel (separate app/web) handles:
- Accept/Reject Appointments
- Admit/Discharge patients with date & time
- These updates reflect in the patient's Admission Status tab
