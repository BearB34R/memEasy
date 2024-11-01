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
        List {
            // PDF Import section
            Section {
                Button(action: { showingFilePicker = true }) {
                    Label("Import from PDF", systemImage: "doc.fill")
                }
            }
            
            // Add new flashcard section
            Section {
                Button(action: { isAddingCard.toggle() }) {
                    Label("Add New Flashcard", systemImage: "plus.circle")
                }
                
                if isAddingCard {
                    VStack(spacing: 10) {
                        TextField("Question", text: $newQuestion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Answer", text: $newAnswer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
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
            
            // List of existing flashcards
            Section("Flashcards") {
                ForEach(deck.flashcards) { card in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Q: \(card.question)")
                            .font(.headline)
                        Text("A: \(card.answer)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteFlashcard)
            }
        }
        .navigationTitle(deck.name)
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

