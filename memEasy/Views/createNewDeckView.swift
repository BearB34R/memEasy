//
//  createNewDeckView.swift
//  memEasy
//
//  Created by Andy Do on 10/29/24.
//

import SwiftUI
import SwiftData

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct createNewDeckView: View {
    @Environment(\.modelContext) var context
    @Query var decks: [Deck]
    
    @State private var newDeckName: String = ""
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            List {
                Section {
                    HStack {
                        ZStack(alignment: .leading) {
                            if newDeckName.isEmpty {
                                Text("New Deck Name")
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.horizontal, 8)
                            }
                            TextField("", text: $newDeckName)
                                .foregroundColor(Color("TextColor"))
                                .padding(8)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                                .tint(Color("TextColor"))
                                .textFieldStyle(PlainTextFieldStyle())
                                .onSubmit {
                                    if !newDeckName.isEmpty {
                                        addDeck()
                                    }
                                }
                                .submitLabel(.done)
                        }
                        
                        Button(action: addDeck) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color("MainColor"))
                        }
                        .disabled(newDeckName.isEmpty)
                    }
                }
                .listRowBackground(Color.clear)
                
                // List of existing decks
                Section {
                    ForEach(decks) { deck in
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
                    }
                    .onDelete(perform: deleteDeck)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("My Flashcards")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.large)
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
