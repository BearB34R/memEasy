//
//  listOfFlashcards.swift
//  memEasy
//
//  Created by Andy Do on 10/28/24.
//

import SwiftUI
import SwiftData

struct listOfFlashcardsView: View {
    @Environment(\.modelContext) private var context
    @Query private var decks: [Deck]
    
    //main view
    var body: some View {
        
        let testDeck: [Int] = Array(1...30)
        
        ZStack{
            VStack{
                
                
                List(testDeck, id:\.self) { i in
                    Text(String(i))
                }
                
//                List {
//                    ForEach (decks) {deck in
//                        Text(deck.name)
//                    }
//                }
                
            }
        }
    }
    
}
#Preview {
    listOfFlashcardsView()
}

