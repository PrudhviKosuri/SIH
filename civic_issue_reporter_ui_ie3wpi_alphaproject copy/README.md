# Civic Issue Reporter - Flutter App

A modern, feature-rich Flutter application for reporting civic issues with an intuitive UI, smooth animations, and comprehensive multimedia support.

## 🎯 Project Overview

This is a cutting-edge civic issue reporting application designed to make community engagement effortless and engaging. The app features a modern Material 3 design, smooth animations, and comprehensive multimedia support for reporting various civic issues.

## ✨ Key Features

### 🏠 **Enhanced Home Page**
- **Interactive Menu Bar**: Modern drawer-style navigation with smooth animations
- **Menu Options**: Profile, Logout, Help, Settings with Material Icons
- **Smart Logout**: Redirects to login with confirmation dialog
- **Consistent Theming**: Blue/teal color scheme with white backgrounds and accent colors
- **Real-time Updates**: Recent reports appear immediately after submission

### 👤 **Enhanced Profile Page**
- **Demo Profile**: Pre-populated with realistic user data (Alex Johnson)
- **Profile Photo**: Customizable avatar with camera integration
- **Editable Fields**: Name, Email, Phone, Address, and Bio
- **Real-time Updates**: Changes reflect immediately in the UI
- **Card-based UI**: Modern cards with rounded corners and shadows
- **Floating Action Button**: Easy access to edit mode
- **Animated Transitions**: Smooth fade and slide animations

### 📋 **Advanced Report Management**
- **Recent Reports Section**: Displays latest 5 reports with beautiful cards
- **List View**: Full reports screen with filtering and search
- **Real-time Addition**: New reports appear immediately with animations
- **Status Tracking**: Visual indicators for Sent, In Progress, and Resolved
- **Category Icons**: Color-coded icons for different issue types
- **Provider State Management**: Centralized report state using Provider package

### 📷 **Enhanced Camera Feature**
- **Full-screen Camera**: Immersive camera experience
- **Live Preview**: Real-time camera preview with controls
- **Photo Preview**: Confirm/retake functionality before adding
- **Flash Control**: Toggle flash on/off
- **Camera Switching**: Front/back camera toggle
- **High Quality**: Optimized image capture settings
- **Clean UI**: Professional camera interface with overlay controls

### 🎤 **Advanced Voice Recording**
- **Beautiful UI**: Full-screen voice recording interface
- **Visual Feedback**: Animated waveform visualization during recording
- **Recording Controls**: Large, intuitive record/stop button
- **Progress Indicator**: Real-time duration display
- **Smooth Animations**: Pulsing animations and transitions
- **Audio Preview**: Confirmation before attachment
- **Quality Recording**: High-quality audio capture

### 🎥 **Professional Video Upload**
- **Video Selection**: File picker with size validation (up to 100MB)
- **Video Preview**: Full video player with play/pause controls
- **Upload Progress**: Animated progress indicators
- **File Info Display**: Shows video size and duration
- **Thumbnail Generation**: Video preview thumbnails
- **Professional UI**: Clean, modern video upload interface

### 🎨 **Modern UI/UX Design**
- **Material 3**: Latest Material Design guidelines
- **Google Fonts**: Poppins font for modern typography
- **Custom Animations**: Smooth page transitions and micro-interactions
- **Color Palette**: Professional blue/teal theme with accent colors
- **Rounded Design**: Modern rounded corners and shadows
- **Gradient Effects**: Beautiful gradient backgrounds
- **Smooth Navigation**: Custom page transition animations

### 📱 **Navigation & Animations**
- **Smooth Transitions**: Custom page route transitions
  - Slide from right/left
  - Scale animations
  - Fade transitions
  - Bottom sheet presentations
- **Interactive Elements**: Hover effects and press states
- **Loading States**: Beautiful loading indicators
- **Error Handling**: User-friendly error messages

## 🛠 Technical Implementation

### **Architecture**
- **Provider Pattern**: Centralized state management
- **Clean Architecture**: Separated concerns with models, services, and widgets
- **Custom Widgets**: Reusable UI components
- **Service Layer**: Location services and backend integration ready

### **Key Dependencies**
```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.5+1          # State management
  camera: ^0.11.0+2           # Enhanced camera functionality
  image_picker: ^1.1.2        # Image selection
  flutter_sound: ^9.8.3       # Voice recording
  video_player: ^2.9.1        # Video playback
  file_picker: ^8.1.2         # File selection
  geolocator: ^12.0.0         # Location services
  google_fonts: ^6.2.1        # Typography
  lottie: ^3.1.2              # Animations
  shared_preferences: ^2.3.2   # Local storage
```

### **File Structure**
```
lib/
├── main.dart                 # App entry point with Provider setup
├── models/
│   └── report.dart          # Report data model
├── providers/
│   └── reports_provider.dart # Global state management
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── dashboard_screen.dart # Enhanced home page
│   ├── profile_screen.dart  # Enhanced profile
│   ├── reports_screen.dart  # Reports listing
│   └── camera_screen.dart   # Full-screen camera
├── widgets/
│   ├── report_form_widget.dart      # Enhanced report form
│   ├── voice_recorder_widget.dart   # Voice recording UI
│   ├── video_upload_widget.dart     # Video upload UI
│   ├── recent_reports_widget.dart   # Reports display
│   └── [other widgets...]
├── services/
│   └── location_service.dart # Location handling
├── styles/
│   └── app_theme.dart       # Material 3 theme
└── utils/
    └── page_transitions.dart # Custom animations
```

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- iOS/Android device or emulator

### **Installation**
1. Clone the repository
```bash
git clone [repository-url]
cd civic_issue_reporter_ui_ie3wpi_alphaproject\ copy
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run
```

### **Building for Production**
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

## 📱 App Flow

1. **Splash Screen** → **Language Selection** → **Login**
2. **Dashboard** (Home page with recent reports and floating action button)
3. **Report Creation** (Enhanced form with camera, voice, and video)
4. **Reports List** (Filterable and searchable reports)
5. **Profile Management** (Editable user profile with photo)

## 🎯 Features Ready for Backend Integration

All frontend features are **backend-ready** with:
- ✅ Centralized state management
- ✅ Service layer architecture
- ✅ API-ready data models
- ✅ Error handling structure
- ✅ Loading states management
- ✅ File upload preparation

## 🏆 Competition Ready

This application is designed to impress judges with:
- **Modern Design**: Latest Material 3 guidelines
- **Smooth Performance**: Optimized animations and interactions
- **Feature Completeness**: All requested features implemented
- **Professional Quality**: Production-ready code structure
- **User Experience**: Intuitive and engaging interface
- **Technical Excellence**: Best practices and clean architecture

## 📋 Demo Data

The app comes with realistic demo data:
- **Profile**: Alex Johnson (alex.johnson@civicreporter.com)
- **Sample Reports**: Various civic issues with different statuses
- **Categories**: Streetlight, Road Damage, Water Leakage, etc.
- **Locations**: Realistic addresses and coordinates

## 🔧 Customization

The app is highly customizable:
- **Themes**: Easy to modify colors and styling in `app_theme.dart`
- **Categories**: Add/modify issue categories in report form
- **Animations**: Adjust timing and curves in page transitions
- **Layout**: Responsive design adapts to different screen sizes

## 🚀 Final Summary

**All requested features have been successfully implemented:**

✅ **Home Page Menu Bar** - Interactive with Profile, Logout, Help options
✅ **Profile Page** - Complete with demo data and real-time editing
✅ **Report Handling** - Recent reports section with animations
✅ **Camera Feature** - Full-screen camera with preview functionality
✅ **Voice & Media Upload** - Professional voice recording and video upload
✅ **UI Cleanup** - Removed redundant elements, added floating action button
✅ **Modern Design** - Material 3, Google Fonts, smooth animations
✅ **Backend Ready** - Provider state management and service architecture

The app is **error-free**, **visually appealing**, and **ready for presentation**!

---

**Built with ❤️ for Smart India Hackathon using Flutter & Material 3**