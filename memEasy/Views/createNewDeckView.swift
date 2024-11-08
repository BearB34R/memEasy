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
    @Query(sort: \Deck.dateCreated, order: .reverse) var decks: [Deck]
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    @State private var showTopElements = true
    @State private var scrollOffset: CGFloat = 0
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
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    isSearchFocused = false
                }
            
            VStack(spacing: 0) {
                if showTopElements {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("TextColor"))
                            
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
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                if sortedAndFilteredDecks.isEmpty {
                                    addDeck()
                                }
                                searchText = ""
                                isSearchFocused = false
                            }) {
                                Image(systemName: sortedAndFilteredDecks.isEmpty ? "plus.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                    .padding()
                }
                
                List {
                    ForEach(sortedAndFilteredDecks) { deck in
                        NavigationLink {
                            listOfFlashcardsView(deck: deck)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(deck.name)
                                        .font(.headline)
                                        .foregroundColor(Color("TextColor"))
                                    Text("Cards: \(deck.flashcards.count)")
                                        .font(.caption)
                                        .foregroundColor(Color("MainColor"))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                        .listRowBackground(Color("BackgroundColor"))
                    }
                    .onDelete(perform: deleteDeck)
                }
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
        .navigationTitle("My Flashcards")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
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
    
    func addDeck() {
        let deck = Deck(name: searchText)
        context.insert(deck)
        searchText = ""
    }
    
    func deleteDeck(at offsets: IndexSet) {
        for index in offsets {
            context.delete(sortedAndFilteredDecks[index])
        }
    }
}

#Preview {
    createNewDeckView()
}
