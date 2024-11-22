//
//  studyFlashcardsView.swift
//  memEasy
//
//  Created by Andy Do on 11/2/24.
//

import SwiftUI
import SwiftData

struct studyFlashcardsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Deck.dateCreated, order: .reverse) var decks: [Deck]
    
    @State private var searchText: String = ""
    @State private var showTopElements = true
    @State private var sortByAlphabet = false
    @FocusState private var isSearchFocused: Bool
    
    var sortedAndFilteredDecks: [Deck] {
        let filtered = searchText.isEmpty ? decks : decks.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        if sortByAlphabet {
            return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
        return filtered
    }
    
    var body: some View {
        ZStack {
            // Add tap gesture only to background
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    isSearchFocused = false
                }
            
            VStack(spacing: 0) {
                // Search bar
                if showTopElements {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("TextColor"))
                            
                            TextField("Search Decks", text: $searchText)
                                .foregroundColor(Color("TextColor"))
                                .tint(Color("TextColor"))
                                .textFieldStyle(PlainTextFieldStyle())
                                .focused($isSearchFocused)
                                .submitLabel(.done)
                                .foregroundStyle(Color("TextColor"))
                        }
                        .padding(8)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("MainColor"), lineWidth: 1)
                        )
                        
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
                
                // List of decks
                List {
                    ForEach(sortedAndFilteredDecks) { deck in
                        NavigationLink {
                            flashcardView(deck: deck)
                        } label: {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("MainColor"))
                        .imageScale(.large)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Study")
                    .font(.title2.bold())
                    .foregroundColor(Color("MainColor"))
            }
            
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

#Preview {
    // Create a test configuration
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    // Create sample decks with flashcards
    let deck1 = Deck(name: "Spanish Vocabulary")
    deck1.flashcards = [
        Flashcard(question: "Hello", answer: "Hola"),
        Flashcard(question: "Goodbye", answer: "Adiós"),
        Flashcard(question: "Thank you", answer: "Gracias")
    ]
    
    let deck2 = Deck(name: "Math Formulas")
    deck2.flashcards = [
        Flashcard(question: "Area of a circle", answer: "πr²"),
        Flashcard(question: "Pythagorean theorem", answer: "a² + b² = c²")
    ]
    
    let deck3 = Deck(name: "Empty Deck", flashcards: [])
    
    // Insert decks into container
    container.mainContext.insert(deck1)
    container.mainContext.insert(deck2)
    container.mainContext.insert(deck3)
    
    return NavigationStack {
        studyFlashcardsView()
    }
    .modelContainer(container)
}
