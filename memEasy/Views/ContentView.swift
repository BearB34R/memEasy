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
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: studyFlashcardsView()) {
                            Text("Study")
                                .font(.headline.bold())
                                .frame(width: 200)
                                .padding()
                                .background(Color("MainColor"))
                                .foregroundColor(Color("TextColor"))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: createNewDeckView()) {
                            Text("Flashcards")
                                .font(.headline.bold())
                                .frame(width: 200)
                                .padding()
                                .background(Color("MainColor"))
                                .foregroundColor(Color("TextColor"))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ContentView()
}

