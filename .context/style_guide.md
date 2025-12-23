# Code Style & Guidelines

This document outlines the coding standards and style guidelines for this project. All contributors (including AI agents) must adhere to these rules to maintain code quality and consistency.

## 1. Linter Rules

We strictly follow the rules defined in `analysis_options.yaml`, which extends `package:flutter_lints/flutter.yaml`.

- **DO NOT** disable linter rules unless absolutely necessary and with a documented reason (`// ignore:`).
- **Fix all lint warnings** before committing code.

## 2. Naming Conventions

Follow standard Dart naming conventions:

- **Classes, Enums, Typedefs**: `UpperCamelCase`
  ```dart
  class UserProfile {}
  enum UserStatus {}
  ```
- **Variables, Parameters, Functions, Methods**: `lowerCamelCase`
  ```dart
  var userName = 'John';
  void fetchUserData() {}
  ```
- **Libraries, Packages, Directories, Source Files**: `snake_case`
  ```
  lib/src/user_profile/user_profile_screen.dart
  ```
- **Constants**: `lowerCamelCase` (Preferred over `SCREAMING_SNAKE_CASE` for non-primitive constants, though Dart allows both. Stick to `lowerCamelCase` for consistency with variables unless it's a truly static primitive constant).

## 3. File Structure & Ordering

Organize the content of a file in the following order:

1.  **Imports**:
    - Dart imports (`dart:async`)
    - Package imports (`package:flutter/material.dart`)
    - Relative imports (`../models/user.dart`) -> *Prefer relative imports for files within the same feature, package imports for shared core modules.*
2.  **Constants** (Top-level)
3.  **Enums**
4.  **Classes**:
    - Fields
    - Constructor
    - Lifecycle methods (e.g., `initState`, `dispose`)
    - Public methods
    - Private methods
    - Build method (for Widgets)

## 4. Widget Best Practices

- **Extract Widgets**: Break down large build methods into smaller, stateless widgets. Avoid helper methods (`_buildHeader()`) if the widget is complex; use a separate `StatelessWidget` class instead to benefit from the framework's optimization.
- **Const Constructors**: Always use `const` constructors where possible to improve performance.
- **Typedefs / Callbacks**: Define specific types for callbacks rather than `Function` to improve type safety.

## 5. Comments & Documentation

- **Public APIs**: Document public classes and methods using `///` doc comments.
- **Complex Logic**: Add `//` comments to explain *why* something is done, not just *what* is done.
- **TODOs**: Use `// TODO: ` format to track technical debt or missing features.

## 6. State Management

- (See `architecture.md` for specific state management approach).
- Consistently use the chosen state management solution. Do not mix patterns (e.g., sticking logic in `setState` when a Bloc/Provider is expected).

## 7. Strings & Internationalization

- Avoid hardcoding strings in the UI.
- Use a central localization approach (or a `AppStrings` class for now if l10n is not set up).

## 8. Asynchronous Programming

- Prefer `async` / `await` over raw `Future` chains (`.then()`).
- Always handle errors in `try-catch` blocks for async operations.
