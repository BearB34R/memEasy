//
//  ContentView.swift
//  memEasy
//
//  Created by Andy Do on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack {
                    Text("MemEasy")
                        .foregroundColor(Color("TextColor"))
                        .font(.largeTitle)
                        .padding()

                    // NavigationLink with button styling
                    NavigationLink(destination: createNewDeckView()) {
                        Text("Go to Flashcards")
                            .padding()
                            .background(Color("MainColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}

