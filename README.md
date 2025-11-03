# Flutter Enterprise E-Commerce App

This is a sample e-commerce application built with Flutter, designed to demonstrate a scalable and maintainable enterprise-level architecture. The app includes features such as a product catalog, shopping cart, and order history.

## Development Environment

- macOS is required for development.
- Flutter installed (current version: 3.24.5)
- Android Studio is used for development.
- Xcode installed (current version: 16.1)
- Cocoapods installed (current version: 1.11.3)

## Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/flutter-enterprise-app-task.git
    cd flutter-enterprise-app-task
    ```

2.  **Install dependencies and Pods:**

    ```bash
    flutter pub get && cd ios && pod install
    ```

3.  **Run the code generator:**

    This project uses code generation for Hive models and mocks. Run the following command to generate the necessary files:

    ```bash
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**

    ```bash
    flutter run
    ```

5.  **Run the tests:**

    To run the unit tests, use the following command:

    ```bash
    flutter test
    ```

## Architecture Overview

The application follows the **Clean Architecture** principles, which separate the code into three distinct layers:

- **Domain Layer:** This is the core of the application. It contains the business logic, entities (like `Product` and `Order`), and use cases (like `GetAllProducts` and `PlaceOrder`). This layer is independent of any UI or data-sourcing frameworks.

- **Data Layer:** This layer is responsible for all data operations. It includes repositories that fetch data from various sources (like a remote API or a local database) and provides it to the domain layer. It also includes the data models that map to the API responses and database structures.

- **Presentation Layer:** This is the UI layer of the application. It uses the **BLoC (Business Logic Component)** pattern to manage state. The UI widgets dispatch events to the BLoCs and listen for state changes to update the screen. This keeps the UI clean and separated from the business logic.

### Key Principles

- **Separation of Concerns:** Each layer has a distinct responsibility, making the code easier to understand, test, and maintain.
- **Dependency Rule:** Dependencies flow inwards. The presentation layer depends on the domain layer, and the data layer depends on the domain layer. The domain layer depends on nothing.
- **Testability:** The architecture makes it easy to write unit tests for the business logic and widget tests for the UI components.

## Libraries Used

- **State Management:**
  - `flutter_bloc`: For predictable state management using the BLoC pattern.
  - `equatable`: To compare objects by value, which is useful for BLoC states.

- **Dependency Injection:**
  - `get_it`: A simple service locator for managing dependencies and decoupling code.

- **Networking:**
  - `dio`: A powerful HTTP client for making API requests.

- **Local Persistence:**
  - `hive` / `hive_flutter`: A fast and lightweight key-value database for local storage.
  - `path_provider`: To find the correct local path for storing the Hive database.

- **Functional Programming:**
  - `dartz`: For functional programming patterns, such as `Either` for error handling.

- **UI & Utilities:**
  - `cached_network_image`: To cache network images and display placeholders.
  - `flutter_spinkit`: A collection of loading indicators.
  - `flutter_animate`: For adding declarative animations.
  - `intl`: For date formatting and internationalization.

- **Testing:**
  - `bloc_test`: For easily testing BLoCs.
  - `mockito`: For creating mock dependencies for tests.

- **Code Generation:**
  - `build_runner`: The core tool for code generation in Dart.
  - `hive_generator`: To automatically generate `TypeAdapter`s for Hive.
