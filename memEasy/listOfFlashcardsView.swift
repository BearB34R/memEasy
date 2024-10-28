//
//  listOfFlashcards.swift
//  memEasy
//
//  Created by Andy Do on 10/28/24.
//

import SwiftUI

struct listOfFlashcardsView: View {
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea()
            Text("Testing")
                .foregroundStyle(Color("TextColor"))
        }
    }
}

#Preview {
    listOfFlashcardsView()
}
