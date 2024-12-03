//
//  ContentView.swift
//  memEasy
//
//  Created by Andy Do on 10/23/24.
//

import SwiftUI

struct CarouselLogo: View {
    @State private var cardPositions: [CGFloat] = [0, 80, 160, 240]
    @State private var cardOpacities: [Double] = [1, 0.8, 0.6, 0.4]
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .frame(width: 280, height: 170)
            
            ZStack {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("MainColor"))
                        .frame(width: 100, height: 150)
                        .offset(x: cardPositions[index])
                        .opacity(cardOpacities[index])
                }
            }
            .frame(width: 280, height: 150)
        }
        .fixedSize()
        .onAppear {
            withAnimation(
                Animation
                    .linear(duration: 3)
                    .repeatForever(autoreverses: false)
            ) {
                var newPositions = cardPositions
                var newOpacities = cardOpacities
                
                for i in 0..<cardPositions.count {
                    newPositions[i] = cardPositions[i] - 320
                    if i == 0 {
                        newOpacities[i] = 0.4
                    } else {
                        newOpacities[i] = cardOpacities[i-1]
                    }
                }
                
                cardPositions = newPositions
                cardOpacities = newOpacities
            }
        }
    }
}

struct LogoCard: View {
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var backgroundColor: Color = Color("BackgroundColor")
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .frame(width: 280, height: 170)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .frame(width: 100, height: 150)
                .shadow(radius: 5)
                .offset(offset)
                .rotationEffect(.degrees(rotation))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                            rotation = Double(gesture.translation.width / 20)
                            
                            if gesture.translation.width > 0 {
                                let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                backgroundColor = Color("CorrectColor").opacity(progress)
                            } else if gesture.translation.width < 0 {
                                let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                backgroundColor = Color("IncorrectColor").opacity(progress)
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.spring()) {
                                offset = .zero
                                rotation = 0
                                backgroundColor = Color("BackgroundColor")
                            }
                        }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("MainColor"), lineWidth: 1)
                )
        }
        .fixedSize()
    }
}

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
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 50)
                        
                    LogoCard()  // Replace CarouselLogo with LogoCard
                        .padding(.bottom, 40)
                    
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

