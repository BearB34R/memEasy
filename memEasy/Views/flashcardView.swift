//
//  flashcardView.swift
//  memEasy
//
//  Created by Andy Do on 11/7/24.
//

import SwiftUI
import SwiftData

struct flashcardView: View {
    let deck: Deck
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var isFlipped = false
    @State private var degree: Double = 0
    @State private var backgroundColor: Color = Color("BackgroundColor")
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            if currentIndex < deck.flashcards.count {
                // Card View
                VStack {
                    Spacer()
                    
                    ZStack {
                        // Back of card (Answer)
                        CardFace(text: deck.flashcards[currentIndex].answer, backgroundColor: backgroundColor)
                            .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
                            .opacity(isFlipped ? 1 : 0)
                            .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
                        
                        // Front of card (Question)
                        CardFace(text: deck.flashcards[currentIndex].question, backgroundColor: backgroundColor)
                            .rotation3DEffect(.degrees(degree - 180), axis: (x: 0, y: 1, z: 0))
                            .opacity(isFlipped ? 0 : 1)
                            .scaleEffect(x: isFlipped ? 1 : -1, y: 1)
                    }
                    .frame(width: 320, height: 400)
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation.width
                                if gesture.translation.width > 0 {
                                    let progress = gesture.translation.width / 300
                                    let opacity = pow(progress, 2)
                                    backgroundColor = Color("CorrectColor").opacity(min(1, opacity))
                                } else if gesture.translation.width < 0 {
                                    let progress = abs(gesture.translation.width) / 300
                                    let opacity = pow(progress, 2)
                                    backgroundColor = Color("IncorrectColor").opacity(min(1, opacity))
                                } else {
                                    backgroundColor = Color("BackgroundColor")
                                }
                            }
                            .onEnded { gesture in
                                withAnimation {
                                    if gesture.translation.width > 100 {
                                        offset = 500
                                        backgroundColor = Color("CorrectColor")
                                        nextCard()
                                    } else if gesture.translation.width < -100 {
                                        offset = -500
                                        backgroundColor = Color("IncorrectColor")
                                        nextCard()
                                    } else {
                                        offset = 0
                                        backgroundColor = Color("BackgroundColor")
                                    }
                                }
                            }
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            degree += 180
                            isFlipped.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    Text("\(currentIndex + 1) of \(deck.flashcards.count)")
                        .foregroundColor(Color("TextColor"))
                        .padding(.bottom)
                }
            } else {
                // Deck completed view
                VStack {
                    Text("Deck Completed!")
                        .font(.title)
                        .foregroundColor(Color("TextColor"))
                    Button("Start Over") {
                        currentIndex = 0
                        isFlipped = false
                        degree = 0
                    }
                    .foregroundColor(Color("MainColor"))
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func nextCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            offset = 0
            isFlipped = false
            degree = 0
            backgroundColor = Color("BackgroundColor")
        }
    }
}

// Helper view for card face
struct CardFace: View {
    let text: String
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .shadow(radius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("MainColor"), lineWidth: 1)
                )
            
            Text(text)
                .font(.title2)
                .foregroundColor(Color("TextColor"))
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    // Create a test configuration
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    // Create sample data
    let sampleDeck = Deck(name: "Sample Deck")
    let flashcard1 = Flashcard(question: "What is the capital of France?", answer: "Paris")
    let flashcard2 = Flashcard(question: "What is the capital of Germany?", answer: "Berlin")
    let flashcard3 = Flashcard(question: "What is the capital of Italy?", answer: "Rome")
    
    sampleDeck.flashcards = [flashcard1, flashcard2, flashcard3]
    container.mainContext.insert(sampleDeck)
    
    return NavigationStack {
        flashcardView(deck: sampleDeck)
    }
    .modelContainer(container)
}
