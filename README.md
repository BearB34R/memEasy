# MemEasy - Flashcard Study App

A modern iOS flashcard application built with SwiftUI for creating and studying flashcard decks with PDF import capabilities.

## Core Technologies

- **SwiftUI**: Used for building the entire user interface with native iOS components and animations
- **SwiftData**: Handles persistent storage and data management for:
  - Deck and Flashcard models
  - CRUD operations
  - Relationship management between decks and cards
- **PDFKit**: Enables PDF document parsing to automatically generate flashcards from properly formatted PDFs

## Features

- Create and manage multiple flashcard decks
- Add cards manually with question/answer pairs
- Import flashcards from PDF files
- Study mode with:
  - Card flipping animations
  - Swipe gestures for correct/incorrect sorting
  - Progress tracking
  - Review incorrect cards
- Search and sort functionality for decks
- Dark/Light mode support

## PDF Import Format
PDFs must follow this format for successful parsing:
```text
Q: Question here
A: Answer here
```

## Data Model
```swift
@Model class Deck {
    var id: UUID
    var name: String
    var dateCreated: Date
    var flashcards: [Flashcard]
}

@Model class Flashcard {
    var id: UUID
    var question: String
    var answer: String
    var deck: Deck?
}
```

## Requirements
- IOS 17.0+
- Xcode 15.0+
- Swift 6.0+