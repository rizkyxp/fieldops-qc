# Setup Guide

Follow these steps to set up the project locally.

## Prerequisites

1.  **Flutter SDK**: Ensure you have Flutter installed ( Version `3.38.5` recommended).
2.  **IDE**: VS Code or Android Studio with Flutter/Dart plugins installed.
3.  **Git**: For version control.

## Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    cd fieldops_qc
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation** (if applicable):
    If the project uses `build_runner` (for JSON serialization, Freezed, etc.):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

## Running the App

1.  **Select Device**:
    Launch an Android Emulator or iOS Simulator, or connect a physical device.

2.  **Run**:
    ```bash
    flutter run
    ```
    Or use the "Run" button in your IDE.

## Troubleshooting

- **CocoaPods Issues (iOS)**:
    ```bash
    cd ios
    pod install
    cd ..
    ```
- **Cache Issues**:
    ```bash
    flutter clean
    flutter pub get
    ```
