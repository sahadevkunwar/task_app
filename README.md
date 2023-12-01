Flutter Task App
A simple Flutter task app that utilizes the BLoC state management pattern for efficient and predictable state changes. The app interacts with a RESTful API to fetch, update, delete, and add tasks. Additionally, the app provides a search functionality to easily find tasks.

Features
Fetch Data: The app fetches task data from the Mock API.

Update Task: Users can update the title and status of existing tasks.

Delete Task: Tasks can be deleted with a simple user interaction.

Add Task: Users can add new tasks by providing a title and status.

Search Task: The app includes a search functionality to filter and find tasks based on their titles.

State Management
The app uses the BLoC (Business Logic Component) state management pattern to manage and control the flow of data within the application. This pattern helps in separating the business logic from the UI, making the codebase more maintainable and scalable.

Dependency Injection
For dependency injection, the app utilizes the get_it package. This package helps in managing and accessing instances of objects in a clean and organized manner. It ensures a centralized location for all dependencies, making the codebase more modular.
