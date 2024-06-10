# Flutter MVVM Template

This is a Flutter project template that follows the MVVM (Model-View-ViewModel) architectural pattern. It provides a starting point for building scalable and maintainable Flutter applications using the Provider state management library.

## Project Structure

The project structure is organized as follows:

```sql
lib
├── data
│   ├── local
│   ├── remote
│   │   ├── network
│   │   └── response
│   └── app.exceptions.dart
├── models
├── repository
├── res
│   ├── colors
│   ├── dimensions
│   ├── app.context.extension.dart
│   └── resources.dart
├── utils
├── view
│   ├── screens
│   └── shared
├── view_model
└── main.dart
```


- `lib/data`: Contains data-related classes and modules.
  - `local`: Contains local data storage implementations.
  - `remote`: Contains remote data-related classes and modules.
    - `network`: Contains network-related classes and modules.
    - `response`: Contains response model classes for network requests.
  - `app.exceptions.dart`: Provides custom exception classes for the application.

- `lib/models`: Contains data models used throughout the application.

- `lib/repository`: Contains the repository layer, which acts as a mediator between the data layer and the view models.

- `lib/res`: Contains resource-related files such as colors, dimensions, and context extension.
  - `colors`: Defines color constants for the application.
  - `dimensions`: Contains dimension constants used for layout and styling.
  - `app.context.extension.dart`: Contains extension methods for the `BuildContext` class.
  - `resources.dart`: Imports and exports all the resource files for easy access.

- `lib/utils`: Contains utility classes and functions used across the application.

- `lib/view`: Contains the UI-related files.
  - `screens`: Contains individual screens or pages of the application.
  - `shared`: Contains shared UI components used across multiple screens.

- `lib/view_model`: Contains the view models that handle the business logic for each screen.

- `lib/main.dart`: Entry point of the application.

