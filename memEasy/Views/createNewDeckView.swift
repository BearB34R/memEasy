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
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    //Function to add new decks
    func addDeck(){
        let newDeck = Deck(name: "testDeck", date: Date())
        context.insert(newDeck)
    }
}

#Preview {
    createNewDeckView()
}
