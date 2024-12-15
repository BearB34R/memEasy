# MemEasy - Flashcard Study App

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-purple.svg)](https://developer.apple.com/xcode/swiftui/)


## Developers

- Andy Nguyen
- Quan Khong

## Goals of this Project
Create a modern iOS flashcard application built with SwiftUI for creating and studying flashcard decks with PDF import capabilities.

- Learning how to intergrate code and build projects with SwiftUI, SwiftData, and PDFKit
  - Building from scratch a database that can handle/rememeber user data
  - Creating easy to understand UI elements that can be easily interpreted by new users
  - Allow pdf document parsing for fast and efficient creation of flashcards

## Features/Functionalities

- Create and manage multiple flashcard decks
- Add cards manually with question/answer pairs
- Import flashcards from PDF files
- Study mode with:
  - Card flipping animations
  - Swipe gestures for correct/incorrect sorting
  - Progress tracking
  - Review incorrect cards
- Search and sort functionality for decks

## Architecture and Design

**Frontend**: 
- **SwiftUI**: Used for building the entire user interface with native iOS components and animations

**Backend**:
- **SwiftData**: Handles persistent storage and data management for:
  - Deck and Flashcard models
  - Relationship management between decks and cards
- **PDFKit**: Enables PDF document parsing to automatically generate flashcards from properly formatted PDFs

### PDF Import Format:
- PDFs must follow this format for successful parsing:
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

## How to get it running:
1. Clone the repository
```
git clone https://github.com/BearB34R/memEasy.git
```
3. Open `memEasy.xcodeproj` in Xcode
4. Build and run on iOS 17.0+ device/simulator

## Requirements
- IOS 17.0+
- Xcode 15.0+
- Swift 6.0+
