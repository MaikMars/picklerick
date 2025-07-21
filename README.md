📱 Rick & Morty Explorer
A SwiftUI application that displays Rick & Morty characters using Rick and Morty API. Built following clean architecture principles, async/await, Combine, with unit tests, caching, and a strong focus on user experience.

🚀 Features
✅ Browse all characters in a responsive grid.
✅ Search characters by name, species, status, and gender.
✅ Filter results in a sleek overlay.
✅ Character detail view with image and episode breakdown.
✅ Episodes grouped by season with collapsible sections.
✅ Image caching to optimize performance.
✅ Pagination with infinite scroll.
✅ Toast notifications for errors.
✅ Fully localized (English 🇬🇧 & Spanish 🇪🇸).
✅ Modular architecture (Service, ViewModel, View, DTO, Model).
✅ Unit tests for services and view models.
✅ Integration tests with live API.


📂 Project Structure
├── Services/
│   ├── CharacterService
│   └── EpisodeService
├── ViewModels/
├── Views/
├── Models/
├── DTOs/
├── Utils/ (Caching, Extensions, Toasts, Localization)
├── Tests/
│   ├── Unit/
│   └── Integration/
└── Resources/ (Localizations, AppIcon)

🛠️ Tech Stack
Swift 5.9
SwiftUI + Async/Await
Combine (for debouncing)
XCTest (Unit & Integration Tests)
Localizations (EN & ES)
