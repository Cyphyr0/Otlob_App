# Technical Preferences - Flutter Otlob App

## Flutter Development Standards

### Architecture Pattern
- **Clean Architecture** with Feature-based Folder Structure
- Data → Domain → Presentation layers
- Separation of concerns with clear boundaries

### State Management **(UPDATED BASED ON 2025 ANALYSIS)**
- **✅ Riverpod First**: Dominant choice for modern Flutter apps in 2025 - use for all standard state management
- **✅ BLoC Supplement**: Only for ultra-complex business logic where Riverpod feels insufficient
- **✅ Riverpod + BLoC Hybrid**: Use Riverpod for 90% of cases, BLoC only for enterprise-level complexity
- **Provider pattern for widget-level state** (built into Riverpod)
- **PersistentProvider** for app-level state (via Riverpod)

### Coding Standards
- Dart null safety enabled
- Immutable data patterns where possible
- Error handling with Either/Failure patterns
- Dependency injection via Service Locator

### UI/UX Preferences
- Material Design 3 specifications
- Custom Otlob color palette and branding
- Consistent spacing using AppSpacing
- Card-based layouts with shadows and radius
- Animation-first approach with Lottie animations

### Testing Strategy
- Unit tests for business logic (domain layer)
- Widget tests for UI components
- Integration tests for feature flows
- Flutter test framework with Mockito for mocking

### Project Structure
```
lib/
├── core/           # App-wide utilities, themes, services
├── features/       # Feature-based modules with clean architecture
│   ├── auth/
│   ├── home/
│   ├── cart/
│   └── profile/
└── main.dart
```

### Naming Conventions
- Feature-first package names: `feature_name.presentation.screen_name`
- Method naming: camelCase
- Class naming: PascalCase
- File naming: snake_case
- Constants: SCREAMING_SNAKE_CASE

### Preferred Packages
- Riverpod for state management
- GoRouter for navigation
- CachedNetworkImage for image loading
- FlutterLints for code quality
- Firebase for backend services

## Development Workflow
- **BMAD-METHOD 6-Step Workflow:** Analyst → PM → Architect → SM → Dev → QA
- Story-driven development with detailed acceptance criteria
- Test-first approach where practical
- Code reviews with BMAD checklist validation
- Git commit messages follow conventional style with BMAD prefixes
- **Lean Agent Context:** Keep dev agents focused with minimal, targeted information
- **Agent-as-Code:** Treat development stories as executable specifications
