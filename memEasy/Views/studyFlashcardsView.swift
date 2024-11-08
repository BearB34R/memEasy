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
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            List {
                ForEach(decks) { deck in
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
        .navigationTitle("Study")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
    }
}

#Preview {
    studyFlashcardsView()
}
