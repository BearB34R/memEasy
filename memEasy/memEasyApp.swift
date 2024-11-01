//
//  memEasyApp.swift
//  memEasy
//
//  Created by Andy Do on 10/23/24.
//

import SwiftUI
import SwiftData

@main
struct memEasyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Deck.self)
        .modelContainer(for: Flashcard.self)
    }
}
