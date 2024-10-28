//
//  dataStorage.swift
//  memEasy
//
//  Created by Andy Do on 10/28/24.
//

import Foundation
import SwiftData

@Model
class Deck: Identifiable  {
    
    var id: UUID
    var name: String
    var date: Date
    var flashcards: [Flashcards]
    
    init(name: String, date: Date, flashcards: [Flashcards] = []) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.flashcards = flashcards
    }
    
}

@Model
class Flashcards: Identifiable {
    
    var id: UUID
    var name: String
    var answer: String
    var deck: Deck?
    
    init(id: UUID, name: String, answer: String, deck: Deck? = nil) {
        self.id = UUID()
        self.name = name
        self.answer = answer
        self.deck = deck
    }
}
