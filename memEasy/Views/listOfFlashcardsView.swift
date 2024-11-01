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
    let deck: Deck
    
    @State private var newQuestion: String = ""
    @State private var newAnswer: String = ""
    @State private var isAddingCard: Bool = false
    @State private var showingFilePicker = false
    
    var body: some View {
        ZStack {
            // Add background color
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            List {
                // Top buttons section
                Section {
                    HStack(spacing: 10) {
                        // PDF Import button
                        Label("Import PDF", systemImage: "doc.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color("MainColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(8)
                            .onTapGesture {
                                showingFilePicker = true
                            }
                        
                        // Add New Flashcard button
                        Label("Add Card", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color("MainColor"))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(8)
                            .onTapGesture {
                                isAddingCard.toggle()
                            }
                    }
                    
                    if isAddingCard {
                        VStack(spacing: 10) {
                            // Question TextEditor
                            Text("Question:")
                                .foregroundColor(Color("TextColor"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $newQuestion)
                                .frame(minHeight: 60)
                                .foregroundColor(Color("TextColor"))
                                .scrollContentBackground(.hidden)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                            
                            // Answer TextEditor
                            Text("Answer:")
                                .foregroundColor(Color("TextColor"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $newAnswer)
                                .frame(minHeight: 60)
                                .foregroundColor(Color("CorrectColor"))
                                .scrollContentBackground(.hidden)
                                .background(Color("BackgroundColor"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                            
                            Button(action: addFlashcard) {
                                Text("Save Flashcard")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color("MainColor"))
                                    .foregroundColor(Color("TextColor"))
                                    .cornerRadius(8)
                            }
                            .disabled(newQuestion.isEmpty || newAnswer.isEmpty)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listRowBackground(Color.clear)
                
                // List of existing flashcards
                Section(header: 
                    Text("Flashcards")
                        .foregroundColor(Color("TextColor"))
                ) {
                    ForEach(deck.flashcards) { card in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Q: \(card.question)")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                            Text("A: \(card.answer)")
                                .font(.subheadline)
                                .foregroundColor(Color("CorrectColor"))
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteFlashcard)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden) // This hides the default List background
        }
        .navigationTitle(deck.name)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.large)
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.pdf]
        ) { result in
            switch result {
            case .success(let url):
                importPDF(from: url)
            case .failure(let error):
                print("Error selecting PDF: \(error.localizedDescription)")
            }
        }
    }
    
    private func addFlashcard() {
        let flashcard = Flashcard(id: UUID(), question: newQuestion, answer: newAnswer, deck: deck)
        deck.flashcards.append(flashcard)
        
        // Reset input fields
        newQuestion = ""
        newAnswer = ""
        isAddingCard = false
    }
    
    private func deleteFlashcard(at offsets: IndexSet) {
        for index in offsets {
            let flashcard = deck.flashcards[index]
            context.delete(flashcard)
            deck.flashcards.remove(at: index)
        }
    }
    
    private func importPDF(from url: URL) {
        guard let pdfText = loadPDFText(url: url) else {
            print("Failed to load PDF text")
            return
        }
        
        let qaPairs = parseQuestionsAndAnswers(text: pdfText)
        
        // Create flashcards from the parsed Q&A pairs
        for pair in qaPairs {
            let flashcard = Flashcard(
                id: UUID(),
                question: pair.question,
                answer: pair.answer,
                deck: deck
            )
            deck.flashcards.append(flashcard)
        }
    }
}
#Preview {
    // Create a sample deck for preview
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    let sampleDeck = Deck(name: "Sample Deck")
    
    return listOfFlashcardsView(deck: sampleDeck)
        .modelContainer(container)
}

