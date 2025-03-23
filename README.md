# Dragon Ball, Design Patterns version

This project is a lightweight version of the previous Dragon Ball application and implements some of the most common design patterns.

It follows a modified version of **Clean Architecture** (Uncle Bob) to separate concerns into independent layers. For the **Presentation** layer, it adopts the **MVVM** design pattern. Additionally, **SOLID** principles are applied throughout the project.

## Screen
| Full App | Error Screen |
|--------|--------|
| <img src="Images/full_app.gif" width="250"/>  | <img src="Images/error_screen.png" width="250"/> |

## Project structure
**From Inner to Outer Layers:**  

- **Presentation (UI Layer)**  
	- **XIBs and Controllers** handle user interaction and display the UI. The **Adapter** pattern is used to map domain models to UI components (e.g., cells).  
	- **ViewModels** manage UI logic, update the UI using the **State** pattern, and communicate with Use Cases.  
	- **Builders** manage object creation, such as controller instances, using the **Builder** pattern.  

- **Domain (Domain and Application Layer)**  
	- **Models** encapsulate business logic.  
	- **Use Cases** encapsulate business rules and temporary request data from the **Repository Layer**, ensuring separation of concerns.  

- **Data (Repository Layer)**  
	- **Data Sources** manage data persistence and may use the **Singleton** pattern for shared instances.  
	- **Entities (DTOs)** represent API response models.  
	- **Mappers** transform DTOs into domain models using the **Mapper** pattern.  
	- **Requests** to define HTTP requests properties such as path, body, etc.
- **Infrastructure**  
	- **Networking** handles API calls and modifies requests using the **Interceptor** pattern (ej. to set a Bearer authentication header).  
	- **Logging** provides a centralized Logger for debugging.

## Testing

The coverage testing includes a Mock Test Double to write Unit Tests.

<img src="Images/coverage.png" width="600"/>