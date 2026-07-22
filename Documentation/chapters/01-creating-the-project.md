---
title: Creating the Project
summary: Xcode setup, targets, and the Discover app structure.
chapter: 1
status: done
---
# Creating the Project

Blueprint starts as a standard Xcode project with a single app target called **Discover** (product name: `blueprint`).

## Key decisions

- **Minimum deployment target:** iOS 17
- **UI framework:** SwiftUI
- **Architecture:** layered (Presentation → Domain → Data)

The app target is organized by concern:

```
blueprint/
├── App/
├── Navigation/
├── DI/
├── Domain/
├── Data/
└── Presentation/
```

Each folder maps to a layer or cross-cutting concern. Nothing enters the project without a didactic reason.

## Next

The project is modularized with local Swift Packages from the start — covered in the next chapter.
