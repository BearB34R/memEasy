//
//  dataStorage.swift
//  memEasy
//
//  Created by Andy Do on 10/28/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Deck: Identifiable  {
    
    var id: UUID
    var name: String
    var dateCreated: Date
    var flashcards: [Flashcard]
    
    init(name: String,  flashcards: [Flashcard] = []) {
        self.id = UUID()
        self.name = name
        dateCreated = Date()
        self.flashcards = flashcards
    }
    
}

@Model
class Flashcard: Identifiable {
    
    var id: UUID
    var question: String
    var answer: String
    var deck: Deck?
    
    init(id: UUID, question: String, answer: String, deck: Deck? = nil) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.deck = deck
    }
}
