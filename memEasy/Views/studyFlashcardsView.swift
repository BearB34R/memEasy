//
//  studyFlashcardsView.swift
//  memEasy
//
//  Created by Andy Do on 11/2/24.
//

import SwiftUI
import SwiftData

// View for studying flashcard decks
struct studyFlashcardsView: View {
    // Environment properties
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Deck.dateCreated, order: .reverse) var decks: [Deck]
    
    // UI state properties 
    @State private var searchText: String = ""
    @State private var showTopElements = true
    @State private var sortByAlphabet = false
    @FocusState private var isSearchFocused: Bool
    
    // Filtered and sorted deck list
    var sortedAndFilteredDecks: [Deck] {
        // Filter by search text
        let filtered = searchText.isEmpty ? decks : decks.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        // Optional alphabetical sort
        if sortByAlphabet {
            return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
        return filtered
    }
    
    var body: some View {
        // Main container
        ZStack {
            // Background with tap gesture
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    isSearchFocused = false
                }
            
            // Content layout
            VStack(spacing: 0) {
                // Search bar (conditional)
                if showTopElements {
                    HStack {
                        // Search field container
                        HStack {
                            // Search icon and text field
                            Image(systemName: "magnifyingglass")
                            TextField("Search Decks", text: $searchText)
                        }
                        // Search styling
                        .foregroundColor(Color("TextColor"))
                        .tint(Color("TextColor"))
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isSearchFocused)
                        .submitLabel(.done)
                        .foregroundStyle(Color("TextColor"))
                        .padding(8)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("MainColor"), lineWidth: 1)
                        )
                        
                        // Clear button (conditional)
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                isSearchFocused = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                    .padding()
                }
                
                // Deck list
                List {
                    ForEach(sortedAndFilteredDecks) { deck in
                        // Navigation to flashcard view
                        NavigationLink {
                            flashcardView(deck: deck)
                        } label: {
                            // Deck row content
                            VStack(alignment: .leading) {
                                Text(deck.name)
                                    .font(.headline)
                                    .foregroundColor(Color("TextColor"))
                                Text("Cards: \(deck.flashcards.count)")
                                    .font(.caption)
                                    .foregroundColor(Color("MainColor"))
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color("BackgroundColor"))
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }
        // Navigation configuration
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("MainColor"))
                        .imageScale(.large)
                }
            }
            
            // Title
            ToolbarItem(placement: .principal) {
                Text("Study")
                    .font(.title2.bold())
                    .foregroundColor(Color("MainColor"))
            }
            
            // Sort toggle
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        sortByAlphabet.toggle()
                    }
                }) {
                    Image(systemName: sortByAlphabet ? "textformat.abc" : "calendar")
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
    }
}

// Preview with sample data
#Preview {
    // Test configuration setup
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    // Create sample decks
    let deck1 = Deck(name: "Spanish Vocabulary")
    deck1.flashcards = [
        Flashcard(question: "Hello", answer: "Hola"),
    ]
    
    let deck2 = Deck(name: "Math Formulas")
    deck2.flashcards = [
        Flashcard(question: "Area of a circle", answer: "πr²"),
        Flashcard(question: "Pythagorean theorem", answer: "a² + b² = c²")
    ]
    
    let deck3 = Deck(name: "Empty Deck", flashcards: [])
    
    // Add decks to container
    container.mainContext.insert(deck1)
    container.mainContext.insert(deck2)
    container.mainContext.insert(deck3)
    
    // Return preview view
    return NavigationStack {
        studyFlashcardsView()
    }
    .modelContainer(container)
}
