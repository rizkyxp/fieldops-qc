# Architecture & Project Structure

This project follows a **Modular MVVM** architecture with **GetX** for state management, dependency injection, and routing. The structure is designed to be scalable, maintainable, and easy to navigate.

## 1. Directory Structure

The project structure is divided into `core` (shared resources) and `modules` (features). All structural folder names are **singular**.

```
lib/
├── main.dart                 # Application Entry point
├── core/                     # Shared resources available app-wide
│   ├── localization/         # Localization files and logic
│   ├── theme/                # App theme, colors, fonts, styles
│   └── utils/                # Shared utility functions and extensions
└── modules/                  # Feature-based modules
    └── [module_name]/        # e.g., auth, home
        ├── data/             # Data Layer
        │   ├── model/        # Data Models (serialization: fromJson/toJson)
        │   ├── datasource/   # Data Sources (Remote API / Local DB)
        │   └── repository/   # Repository Implementation & Logic
        └── presentation/     # Presentation Layer
            ├── binding/      # GetX Dependency Injection Bindings
            ├── controller/   # ViewModels / GetxControllers
            └── view/         # UI Screens and Widgets
```

## 2. Layer Definitions

### Data Layer (`data/`)
Responsible for handling data operations.
- **model**: Plain Dart objects (POJOs) with `fromJson` and `toJson` methods.
- **datasource**: Directly communicates with external sources (APIs, Firebase, shared_preferences, SQLite).
- **repository**: The single source of truth for data. It coordinates between local and remote data sources and handles error handling/exceptions before passing data to the controller.

### Presentation Layer (`presentation/`)
Responsible for the UI and user interaction.
- **binding**: managing dependencies. Uses `Get.lazyPut(() => MyController())`.
- **controller**: The ViewModel. Extends `GetxController`.
    - Manages state (using reactive `Rx` variables or simple state).
    - Contains business logic.
    - Calls Repositories to fetch/update data.
- **view**: The UI. StatelessWidgets that consume the Controller's state using `Obx(() => ...)` or `GetBuilder<MyController>`.

## 3. State Management (GetX)

We use **GetX** for state management.

- **Reactive State**: Use `.obs` variables and wrap widgets in `Obx(() => ...)` for granular updates.
  ```dart
  // Controller
  var count = 0.obs;
  
  // View
  Obx(() => Text('${controller.count}'));
  ```
- **Simple State**: Use `GetBuilder` if you prefer manual updates with `update()`.

## 4. Dependency Injection

Dependencies are managed via GetX **Bindings**.
- Create a `Binding` class for each module/page.
- Inject implementations using `Get.lazyPut`.

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl());
    Get.lazyPut(() => HomeController(repository: Get.find()));
  }
}
```

## 5. Routing

Routing is handled by **GetX**.
- Define routes in `AppPages` or separate route files.
- Use named routes: `Get.toNamed('/home')`.

```dart
GetPage(
  name: '/home',
  page: () => HomeView(),
  binding: HomeBinding(), // Ties the DI to the route
)
```
