# Architecture & Project Structure

This project follows a **Modular MVVM** architecture with **GetX** for state management, dependency injection, and routing. The structure is designed to be scalable, maintainable, and easy to navigate.

## 1. Naming Conventions

We strictly follow **Professional Usage** for naming:

1.  **Singular** for **Features/Modules**:
    - Represents a single concept or domain.
    - Examples: `auth`, `dashboard`, `profile`, `core`.
2.  **Plural** for **Categories/Types**:
    - Represents a collection or group of similar files/entities.
    - Examples: `models` (contains many models), `views`, `controllers`, `services`, `utils`.

## 2. Directory Structure

The project structure is divided into `core` (shared resources), `modules` (features), and `routes`. All structural folder names are **plural** (e.g., `models`, `views`).

```
lib/
├── main.dart                 # Application Entry point (Minimal logic)
├── routes/                   # Centralized Route Definitions
│   └── app_pages.dart        # Page list mapping Routes to Views/Bindings
├── core/                     # Shared resources available app-wide
│   ├── base/                 # Base classes (e.g., BaseController)
│   ├── constants/            # App constants (API, Storage Keys)
│   ├── localization/         # Localization files and logic
│   ├── network/              # Network Layer (Dio, Interceptors)
│   ├── services/             # Core Services (AppInitializer)
│   ├── theme/                # App theme, colors, fonts, styles
│   └── utils/                # Shared utility functions and extensions
└── modules/                  # Feature-based modules
    └── [module_name]/        # e.g., auth, dashboard
        ├── data/             # Data Layer
        │   ├── models/       # Data Models (serialization: fromJson/toJson)
        │   ├── datasources/  # Data Sources (Remote API / Local DB)
        │   └── repositories/ # Repository Implementation & Logic
        └── presentation/     # Presentation Layer
            ├── bindings/     # GetX Dependency Injection Bindings
            ├── controllers/  # ViewModels / GetxControllers
            └── views/        # UI Screens and Widgets
```

## 3. Initialization Flow

We separate initialization logic from `main.dart` to keep the entry point clean.

- **`AppInitializer`** (`core/services/`): Handles all startup logic.
    - Preserves Native Splash.
    - Loads Environment Variables (`.env`).
    - Performs Authentication Check.
    - Determines `initialRoute`.
    - Removes Native Splash.
- **`main.dart`**: Calls `AppInitializer.init()` and passes the result to `MyApp`.

## 4. Layer Definitions

### Data Layer (`data/`)
Responsible for handling data operations.
- **models**: Plain Dart objects (POJOs) with `fromJson` and `toJson` methods.
    - **Note**: Strict separation between Request and Response models is enforced.
    - **Models**: Should expect unwrapped data (the `Result` object), as the Network Layer handles the envelope.
- **datasources**: Directly communicates with external sources.
    - Uses `DioService` for HTTP requests.
    - **Error Handling**: Should **NOT** catch exceptions. Let `DioException` propagate to the controller for global handling.
- **repositories**: The single source of truth for features. It coordinates data sources and exposes a clean API to the controller.

### Presentation Layer (`presentation/`)
Responsible for the UI and user interaction.
- **bindings**: Managing dependencies. Uses `Get.lazyPut(() => MyController())`.
- **controllers**: The ViewModel. Extends `BaseController`.
    - **`call()` Method**: Use the inherited `call()` method for async operations to get automatic Loading Dialogs and Global Error Handling.
    - Manages state (using reactive `Rx` variables).
- **views**: The UI. StatelessWidgets that consume state.
    - **Routes**: Each View class defines its own route constant (e.g., `static const String route = '/login';`).

### Core Layer (`core/`)
- **BaseController**: Provides global error handling (SnackBar), loading indicators, and safe async execution.
- **DioService**: Centralized HTTP client configuration.
    - **PrettyDioLogger**: Enhanced logging in Debug mode.
    - **AuthInterceptor**: Automatically injects Bearer Token from SharedPreferences.
    - **ResponseInterceptor**: Automatically unwraps standard API envelopes (`{ data: ... }`), allowing models to focus on the actual data payload.

## 5. State Management (GetX)

We use **GetX** for state management.

- **Reactive State**: Use `.obs` variables and wrap widgets in `Obx(() => ...)` for granular updates.
  ```dart
  // Controller
  var count = 0.obs;
  
  // View
  Obx(() => Text('${controller.count}'));
  ```

## 6. Routing

Routing is handled by **GetX** and centralized in `AppPages`.

1.  **Define Route**: In the View Class.
    ```dart
    class LoginView extends GetView<AuthController> {
      static const String route = '/login';
      // ...
    }
    ```
2.  **Register Page**: In `lib/routes/app_pages.dart`.
    ```dart
    static final pages = [
      GetPage(
        name: LoginView.route,
        page: () => const LoginView(),
        binding: AuthBinding(),
      ),
    ];
    ```
3.  **Navigate**:
    ```dart
    Get.toNamed(DashboardView.route);
    Get.offAllNamed(LoginView.route);
    ```

## 7. Environment & Constants

- **Environment**: Use `.env` file for secrets and config (e.g., `BASE_URL`).
- **Constants**: Store app-wide constants in `core/constants/` (e.g., `api_endpoints.dart`, `storage_keys.dart`).
