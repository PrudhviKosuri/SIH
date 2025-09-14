# Civic Issue Reporter - Flutter App

A Flutter mobile application for reporting civic issues, converted from the original React + TypeScript project.

## Features

- **Dashboard**: Quick access to report form and recent reports
- **Reports Management**: View, search, and filter all submitted reports
- **Report Form**: Submit new issues with photos, location, and detailed descriptions
- **Status Tracking**: Track the progress of submitted reports (Sent → Received → Resolved)
- **Profile**: User profile and settings (placeholder for future implementation)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── report.dart          # Report data model
├── screens/
│   ├── dashboard_screen.dart
│   ├── reports_screen.dart
│   ├── profile_screen.dart
│   └── login_screen.dart
├── widgets/
│   ├── header_widget.dart
│   ├── bottom_nav_widget.dart
│   ├── status_bar_widget.dart
│   ├── report_item_widget.dart
│   ├── report_form_widget.dart
│   └── recent_reports_widget.dart
├── styles/
│   └── app_theme.dart       # App theme and colors
└── utils/
    └── mock_data.dart       # Sample data for development
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

### Building the App

```bash
# Build APK for Android
flutter build apk

# Build iOS app (requires macOS and Xcode)
flutter build ios
```

## Dependencies

- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `http`: HTTP requests
- `image_picker`: Camera and gallery access
- `permission_handler`: Runtime permissions

## Design System

The app uses a custom design system with:

- **Primary Color**: #5259D0 (Purple)
- **Accent Color**: #F15A2A (Orange)
- **Success Color**: #35A852 (Green)
- **Warning Color**: #FFD300 (Yellow)
- **Typography**: Inter (body) and League Spartan (headings)

## Features Implemented

### ✅ Completed
- Complete UI conversion from React to Flutter
- Navigation system with bottom navigation
- Report form with image upload capability
- Status tracking system
- Search and filter functionality
- Responsive design for mobile devices
- Material Design 3 implementation

### 🔄 In Progress / Future
- Backend integration
- User authentication
- Push notifications
- Offline support
- Advanced image editing
- Location services integration

## Architecture

The app follows Flutter best practices:

- **State Management**: Uses StatefulWidget for local state
- **Navigation**: Named routes with Navigator
- **Widget Composition**: Reusable widgets for consistent UI
- **Theme System**: Centralized theming with Material Design 3
- **Data Models**: Strongly typed models with enums

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.