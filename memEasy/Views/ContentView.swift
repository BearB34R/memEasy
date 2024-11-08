//
//  ContentView.swift
//  memEasy
//
//  Created by Andy Do on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        
        // Apply to all navigation bar styles
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Make the navigation bar transparent
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea(.all, edges: .all)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
        .configureNavigationBar()
    }
}

#Preview {
    ContentView()
}

