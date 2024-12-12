//
//  flashcardView.swift
//  memEasy
//
//  Created by Andy Do on 11/7/24.
//

import SwiftUI
import SwiftData

// View for displaying and interacting with flashcards
struct flashcardView: View {
    // Properties for deck and card management
    let deck: Deck
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @State private var isFlipped = false
    @State private var degree: Double = 0
    @State private var backgroundColor: Color = Color("BackgroundColor")
    
    // Properties for tracking incorrect answers
    @State private var incorrectCards: [Flashcard] = []
    @State private var isStudyingIncorrect = false
    @State private var currentIncorrectCards: [Flashcard] = []
    @State private var rotation: Double = 0
    @Environment(\.dismiss) private var dismiss
    
    // Current set of cards being studied
    var currentCards: [Flashcard] {
        isStudyingIncorrect ? incorrectCards : deck.flashcards
    }
    
    var body: some View {
        // Main container
        ZStack {
            // Background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                // Exit button
                Button(action: { dismiss() }) {
                    Circle()
                        .fill(Color("MainColor"))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "xmark")
                                .foregroundColor(Color("TextColor"))
                                .font(.system(size: 16, weight: .bold))
                        )
                }
                .padding(.top)
                
                Spacer()
                
                // Main content area
                if currentIndex < currentCards.count {
                    // Active study card
                    VStack {
                        Spacer()
                        
                        ZStack {
                            // Answer side of card
                            CardFace(text: currentCards[currentIndex].answer, backgroundColor: backgroundColor)
                                .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
                                .opacity(isFlipped ? 1 : 0)
                                .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
                                .offset(offset)
                                .rotationEffect(.degrees(rotation))
                            
                            // Question side of card
                            CardFace(text: currentCards[currentIndex].question, backgroundColor: backgroundColor)
                                .rotation3DEffect(.degrees(degree - 180), axis: (x: 0, y: 1, z: 0))
                                .opacity(isFlipped ? 0 : 1)
                                .scaleEffect(x: isFlipped ? 1 : -1, y: 1)
                                .offset(offset)
                                .rotationEffect(.degrees(rotation))
                        }
                        .frame(width: 320, height: 400)
                        // Card gestures and interactions
                        .gesture(
                            DragGesture()
                                // Handle drag
                                .onChanged { gesture in
                                    offset = gesture.translation
                                    rotation = Double(gesture.translation.width / 20)
                                    
                                    if gesture.translation.width > 0 {
                                        // Calculate progress for correct answer
                                        let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                        backgroundColor = Color("CorrectColor").opacity(progress)
                                    } else if gesture.translation.width < 0 {
                                        // Calculate progress for incorrect answer
                                        let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                        backgroundColor = Color("IncorrectColor").opacity(progress)
                                    } else {
                                        backgroundColor = Color("BackgroundColor")
                                    }
                                }
                                // Handle drag end
                                .onEnded { gesture in
                                    // Calculate final progress
                                    let progress = min(abs(gesture.translation.width) / 150, 1.0)
                                    
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        // Only trigger card removal if color is at full saturation (progress == 1.0)
                                        if gesture.translation.width > 0 && progress >= 1.0 {
                                            offset = CGSize(width: 500, height: 0)
                                            rotation = 20
                                            backgroundColor = Color("CorrectColor")
                                            nextCard()
                                        } else if gesture.translation.width < 0 && progress >= 1.0 {
                                            offset = CGSize(width: -500, height: 0)
                                            rotation = -20
                                            backgroundColor = Color("IncorrectColor")
                                            nextCard()
                                        } else {
                                            // Return to center if not at full saturation
                                            offset = .zero
                                            rotation = 0
                                            backgroundColor = Color("BackgroundColor")
                                        }
                                    }
                                }
                        )
                        // Card tap to flip
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                degree += 180
                                isFlipped.toggle()
                            }
                        }
                        
                        Spacer()
                        
                        // Progress tracker
                        Text("\(currentIndex + 1) of \(currentCards.count)")
                            .foregroundColor(Color("TextColor"))
                            .padding(.bottom)
                    }
                } else {
                    // Completion view
                    VStack(spacing: 20) {
                        Spacer()
                        
                        // Completion message
                        Text("Deck Completed!")
                            .font(.title)
                            .foregroundColor(Color("TextColor"))
                        
                        // Incorrect cards study options
                        if !isStudyingIncorrect && !incorrectCards.isEmpty {
                            // First round completion
                            Text("You got \(incorrectCards.count) cards incorrect")
                                .foregroundColor(Color("TextColor"))
                            
                            Button("Study Incorrect Cards") {
                                isStudyingIncorrect = true
                                currentIndex = 0
                                isFlipped = false
                                degree = 0
                                currentIncorrectCards = []
                            }
                            .foregroundColor(Color("MainColor"))
                        } else if isStudyingIncorrect {
                            // Reviewing incorrect cards
                            if currentIncorrectCards.isEmpty {
                                Text("Great job! You got all cards correct this time!")
                                    .foregroundColor(Color("TextColor"))
                            } else {
                                Text("You still got \(currentIncorrectCards.count) cards incorrect")
                                    .foregroundColor(Color("TextColor"))
                                
                                Button("Study Incorrect Cards Again") {
                                    incorrectCards = currentIncorrectCards
                                    currentIndex = 0
                                    isFlipped = false
                                    degree = 0
                                    currentIncorrectCards = []
                                }
                                .foregroundColor(Color("MainColor"))
                            }
                        }
                        
                        // Reset button
                        Button("Start Over") {
                            currentIndex = 0
                            isFlipped = false
                            degree = 0
                            incorrectCards = []
                            currentIncorrectCards = []
                            isStudyingIncorrect = false
                        }
                        .foregroundColor(Color("MainColor"))
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        // Navigation configuration
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    // Advance to next card
    private func nextCard() {
        // Delay to allow animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Track incorrect cards
            if offset.width < 0 {
                if isStudyingIncorrect {
                    currentIncorrectCards.append(currentCards[currentIndex])
                } else {
                    incorrectCards.append(currentCards[currentIndex])
                }
            }
            
            // Reset card state
            currentIndex += 1
            offset = .zero
            isFlipped = false
            degree = 0
            rotation = 0
            backgroundColor = Color("BackgroundColor")
        }
    }
}

// Card face view component
struct CardFace: View {
    let text: String
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(radius: 10)
                .overlay(
                    // Card border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("MainColor"), lineWidth: 1)
                )
            
            // Card text
            Text(text)
                .font(.title2)
                .foregroundColor(Color("TextColor"))
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

// Preview with sample data
#Preview {
    // Setup test environment
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    // Create sample deck and cards
    let sampleDeck = Deck(name: "Sample Deck")
    let flashcard1 = Flashcard(question: "What is the capital of France?", answer: "Paris")
    let flashcard2 = Flashcard(question: "What is the capital of Germany?", answer: "Berlin")
    
    sampleDeck.flashcards = [flashcard1, flashcard2]
    container.mainContext.insert(sampleDeck)
    
    // Return preview view
    return NavigationStack {
        flashcardView(deck: sampleDeck)
    }
    .modelContainer(container)
}
