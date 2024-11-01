//
//  createNewDeckView.swift
//  memEasy
//
//  Created by Andy Do on 10/29/24.
//

import SwiftUI
import SwiftData

struct createNewDeckView: View {
    @Environment(\.modelContext) var context
    @Query var decks: [Deck]
    
    // Add state for the new deck name
    @State private var newDeckName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                // Input field for new deck
                Section {
                    HStack {
                        TextField("New Deck Name", text: $newDeckName)
                        Button(action: addDeck) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newDeckName.isEmpty)
                    }
                }
                
                // List of existing decks
                Section {
                    ForEach(decks) { deck in
                        NavigationLink(destination: listOfFlashcardsView(deck: deck)) {
                            VStack(alignment: .leading) {
                                Text(deck.name)
                                    .font(.headline)
                                Text("Cards: \(deck.flashcards.count)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteDeck)
                }
            }
            .navigationTitle("My Flashcards")
        }
    }
    
    func addDeck() {
        let deck = Deck(name: newDeckName)
        context.insert(deck)
        newDeckName = "" // Reset the text field
    }
    
    func deleteDeck(at offsets: IndexSet) {
        for index in offsets {
            context.delete(decks[index])
        }
    }
}

#Preview {
    createNewDeckView()
}
