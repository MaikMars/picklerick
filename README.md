📱 Rick & Morty iOS App
A clean and modern iOS app built with SwiftUI, Async/Await, and following Clean Architecture and SOLID principles. The app consumes the Rick and Morty API to display a list of characters with filtering, search, and detailed episode information organized by seasons.


🏗️ Architecture
The project follows a MVVM architecture with a clear separation of concerns and clean layers:


📂 Project Structure

📁 Models - Models	Domain models (Character, Episode), DTOs, and mapping logic.
📁 Services - Services	Networking layer (CharacterService, EpisodeService, caching).
📁 ViewModels - ViewModels	View-specific logic, pagination, filtering, data fetching.
📁 Views - Views	SwiftUI views with grid, search, filters, and details.
📁 Utils (Cache, Helpers)


✅ MVVM + Clean Architecture structure
✅ SOLID principles applied throughout the codebase
✅ Protocols for abstraction and testing
✅ Modular design for easy maintenance and scaling


⚙️ Tech Stack
✅ SwiftUI (UI framework)
✅ Async/Await for async networking
✅ URLSession (no third-party dependencies)
✅ In-memory cache for data and images
✅ Localization (English 🇺🇸 and Spanish 🇪🇸)
✅ Dark/Light Mode support
✅ Unit Testing with XCTest


🎨 Features
🟢 Responsive grid layout with pagination.
🟢 Search and filter functionality.
🟢 Character details view with episodes grouped by seasons.
🟢 Localized in English and Spanish.
🟢 Dark Mode compatible UI.
🟢 Clean code with architectural best practices.
