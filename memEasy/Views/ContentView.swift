//
//  ContentView.swift
//  memEasy
//
//  Created by Andy Do on 10/23/24.
//

import SwiftUI


// Main app view components
struct ContentView: View {
    // Configure navigation bar appearance
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        
        // Apply appearance settings to all nav bar states
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        // Main navigation container
        NavigationView {
            // Root view stack
            ZStack {
                // Background color
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                // Main content stack
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: 50)
                    
                    // Interactive logo card
                    LogoCard()
                        .padding(.bottom, 40)
                    
                    // App title
                    Text("MemEasy")
                        .foregroundColor(Color("TextColor"))
                        .font(.largeTitle)
                        .padding()
                    
                    // Navigation buttons stack
                    VStack(spacing: 20) {
                        // Study button
                        NavigationLink(destination: studyFlashcardsView()) {
                            Text("Study")
                                .font(.headline.bold())
                                .frame(width: 200)
                                .padding()
                                .background(Color("MainColor"))
                                .foregroundColor(Color("TextColor"))
                                .cornerRadius(10)
                        }
                        
                        // Flashcards button
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
            // Navigation bar configuration
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
        }
        // Navigation style settings
        .navigationViewStyle(.stack)
        .configureNavigationBar()
    }
}

// Interactive logo card component
struct LogoCard: View {
    // State for tracking card position and appearance
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var backgroundColor: Color = Color("BackgroundColor")
    
    var body: some View {
        // Card container
        ZStack {
            // Background
            Color("BackgroundColor")
                .frame(width: 280, height: 170)
            
            // Interactive card
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 100, height: 150)
                .shadow(radius: 5)
                .offset(offset)
                .rotationEffect(.degrees(rotation))
                // Drag gesture handling
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Update card position and rotation
                            offset = gesture.translation
                            rotation = Double(gesture.translation.width / 20)
                            
                            // Update card color based on swipe direction
                            if gesture.translation.width > 0 {
                                let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                backgroundColor = Color("CorrectColor").opacity(progress)
                            } else if gesture.translation.width < 0 {
                                let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                backgroundColor = Color("IncorrectColor").opacity(progress)
                            }
                        }
                        // Reset card on release
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                offset = .zero
                                rotation = 0
                                backgroundColor = Color("BackgroundColor")
                            }
                        }
                )
                // Card border
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("MainColor"), lineWidth: 1)
                )
        }
        .fixedSize()
    }
}

#Preview {
    ContentView()
}

