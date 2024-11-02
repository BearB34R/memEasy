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
    let container: ModelContainer
    
    init() {
        do {
            // Configure the ModelContainer with your model types
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: Deck.self, Flashcard.self, configurations: config)
        } catch {
            fatalError("Could not configure ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
