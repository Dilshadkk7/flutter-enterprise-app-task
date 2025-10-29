# Flutter Enterprise App - Product Catalog

This application fulfills the requirements of the Flutter Machine Coding Task.

## Architecture

This project uses **Clean Architecture** divided into three layers:
- **Presentation:** Contains UI (Widgets) and State Management (Bloc).
- **Domain:** Contains business logic (UseCases) and abstract contracts (Repositories).
- **Data:** Contains Repository implementations and Data Sources (Remote API and Local Cache).

## Key Features

- **State Management:** `flutter_bloc` and `equatable` for clean and predictable state logic.
- **Dependency Injection:** `get_it` for decoupling components.
- **Networking:** `dio` for handling REST API calls.
- **Persistence:** `hive` for local caching of products and shopping cart data.
- **UI Helpers:**
    - `cached_network_image` for efficient image loading and caching.
    - `flutter_spinkit` for smooth loading animations.
- **Functional Programming:** `dartz` for robust error handling with `Either`.
- **Theming:** Dynamic support for both Light and Dark modes.
- **Testing:** Unit tests for core business logic.

## Setup Instructions

1.  **Get Dependencies:**
    ```sh
    flutter pub get
    ```

2.  **Run Code Generator (IMPORTANT):**
    This is required to generate Hive `TypeAdapters`.
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

3.  **Run the App:**
    ```sh
    flutter run
    ```
