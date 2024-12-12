//
//  createNewDeckView.swift
//  memEasy
//
//  Created by Andy Do on 10/29/24.
//

import SwiftUI
import SwiftData

// View for creating and managing flashcard decks
struct createNewDeckView: View {
    // Environment and data model connections
    @Environment(\.modelContext) var context
    @Query(sort: \Deck.dateCreated, order: .reverse) var decks: [Deck]
    @Environment(\.dismiss) private var dismiss
    
    // State variables for UI control
    @State private var searchText: String = ""
    @State private var showTopElements = true
    @State private var scrollOffset: CGFloat = 0
    @State private var sortByAlphabet = false
    @FocusState private var isSearchFocused: Bool
    
    // Computed property for filtered and sorted decks
    var sortedAndFilteredDecks: [Deck] {
        // Filter decks based on search text
        let filtered = searchText.isEmpty ? decks : decks.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        // Sort alphabetically if enabled
        if sortByAlphabet {
            return filtered.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
        return filtered
    }
    
    var body: some View {
        // Main container
        ZStack {
            // Background setup
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    isSearchFocused = false
                }
            
            // Main content layout
            VStack(spacing: 0) {
                // Search bar section
                if showTopElements {
                    HStack {
                        // Search field container
                        HStack {
                            // Search icon
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("TextColor"))
                            
                            // Search/Create text field
                            TextField("Search or Create New Deck", text: $searchText)
                                .foregroundColor(Color("TextColor"))
                                .tint(Color("TextColor"))
                                .textFieldStyle(PlainTextFieldStyle())
                                .focused($isSearchFocused)
                                .onSubmit {
                                    if !searchText.isEmpty && sortedAndFilteredDecks.isEmpty {
                                        addDeck()
                                    }
                                    isSearchFocused = false
                                }
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
                        
                        // Clear/Add button
                        if !searchText.isEmpty {
                            Button(action: {
                                // Add deck if none found
                                if sortedAndFilteredDecks.isEmpty {
                                    addDeck()
                                }
                                searchText = ""
                                isSearchFocused = false
                            }) {
                                // Dynamic button icon
                                Image(systemName: sortedAndFilteredDecks.isEmpty ? "plus.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                    .padding()
                }
                
                // List of decks
                List {
                    ForEach(sortedAndFilteredDecks) { deck in
                        // Navigation link to deck details
                        NavigationLink {
                            listOfFlashcardsView(deck: deck)
                        } label: {
                            // Deck row layout
                            HStack {
                                // Deck info
                                VStack(alignment: .leading) {
                                    Text(deck.name)
                                        .font(.headline)
                                        .foregroundColor(Color("TextColor"))
                                    Text("Cards: \(deck.flashcards.count)")
                                        .font(.caption)
                                        .foregroundColor(Color("MainColor"))
                                }
                                Spacer()
                                // Navigation arrow
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .listRowBackground(Color("BackgroundColor"))
                    }
                    // Enable deck deletion
                    .onDelete(perform: deleteDeck)
                }
                // List styling
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .background(Color("BackgroundColor"))
                .onChange(of: scrollOffset) { oldValue, newValue in
                    withAnimation {
                        showTopElements = scrollOffset >= -10
                    }
                }
            }
        }
        // Navigation bar setup
        .navigationTitle("My Flashcards")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back button
            ToolbarItem(placement: .navigationBarLeading) {
                if showTopElements {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("MainColor"))
                            Text("Back")
                                .foregroundColor(Color("MainColor"))
                        }
                    }
                }
            }
            
            // Sort toggle button
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
    
    // Function to add new deck
    func addDeck() {
        let deck = Deck(name: searchText)
        context.insert(deck)
        searchText = ""
    }
    
    // Function to delete deck
    func deleteDeck(at offsets: IndexSet) {
        for index in offsets {
            context.delete(sortedAndFilteredDecks[index])
        }
    }
}

#Preview {
    createNewDeckView()
}
