//
//  listOfFlashcards.swift
//  memEasy
//
//  Created by Andy Do on 10/28/24.
//

import SwiftUI
import SwiftData

// View for managing flashcards within a deck
struct listOfFlashcardsView: View {
    // Environment and data model connections
    @Environment(\.modelContext) private var context
    let deck: Deck
    
    // State for adding new cards
    @State private var newQuestion: String = ""
    @State private var newAnswer: String = ""
    @State private var isAddingCard: Bool = false
    @State private var showingFilePicker = false
    @Environment(\.dismiss) private var dismiss
    
    // State for editing existing cards
    @State private var editingCard: Flashcard?
    @State private var editQuestion: String = ""
    @State private var editAnswer: String = ""
    
    var body: some View {
        // Main container
        ZStack {
            // Background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                // Top action buttons
                HStack {
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
                    
                    // Add Card button
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
                .padding()
                
                // Scrollable content
                List {
                    // Add new card form
                    if isAddingCard {
                        VStack(spacing: 10) {
                            // Question input
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
                            
                            // Answer input
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
                            
                            // Save button
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
                        .listRowBackground(Color.clear)
                    }
                    
                    // Existing cards list
                    Section(header: Text("Flashcards")
                        .foregroundColor(Color("TextColor"))
                    ) {
                        ForEach(deck.flashcards) { card in
                            // Card view/edit form
                            VStack(alignment: .leading, spacing: 8) {
                                if editingCard?.id == card.id {
                                    // Edit form
                                    VStack(spacing: 10) {
                                        // Question input
                                        Text("Question:")
                                            .foregroundColor(Color("TextColor"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        TextEditor(text: $editQuestion)
                                            .frame(minHeight: 60)
                                            .foregroundColor(Color("TextColor"))
                                            .scrollContentBackground(.hidden)
                                            .background(Color("BackgroundColor"))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color("MainColor"), lineWidth: 1)
                                            )
                                        
                                        // Answer input
                                        Text("Answer:")
                                            .foregroundColor(Color("TextColor"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        TextEditor(text: $editAnswer)
                                            .frame(minHeight: 60)
                                            .foregroundColor(Color("CorrectColor"))
                                            .scrollContentBackground(.hidden)
                                            .background(Color("BackgroundColor"))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color("MainColor"), lineWidth: 1)
                                            )
                                        
                                        // Save/Cancel buttons
                                        HStack {
                                            Button(action: updateFlashcard) {
                                                Text("Save")
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 8)
                                                    .background(Color("MainColor"))
                                                    .foregroundColor(Color("TextColor"))
                                                    .cornerRadius(8)
                                            }
                                            .disabled(editQuestion.isEmpty || editAnswer.isEmpty)
                                            
                                            Button(action: cancelEdit) {
                                                Text("Cancel")
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 8)
                                                    .background(Color("BackgroundColor"))
                                                    .foregroundColor(Color("MainColor"))
                                                    .cornerRadius(8)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color("MainColor"), lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                } else {
                                    // Regular card display
                                    VStack(alignment: .leading, spacing: 8) {
                                        // Question and answer text
                                        Text("Q: \(card.question)")
                                            .font(.headline)
                                            .foregroundColor(Color("TextColor"))
                                        Text("A: \(card.answer)")
                                            .font(.subheadline)
                                            .foregroundColor(Color("CorrectColor"))
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        editingCard = card
                                        editQuestion = card.question
                                        editAnswer = card.answer
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        // Enable deletion
                        .onDelete(perform: deleteFlashcard)
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
        }
        // Navigation configuration
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("MainColor"))
                        .imageScale(.large)
                }
            }
            
            // Deck title
            ToolbarItem(placement: .principal) {
                Text(deck.name)
                    .font(.title2.bold())
                    .foregroundColor(Color("MainColor"))
            }
            
            // Study button
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: flashcardView(deck: deck)) {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
        // PDF file picker
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
    
    // Add new flashcard
    private func addFlashcard() {
        // Create and save new card
        let flashcard = Flashcard(question: newQuestion, answer: newAnswer, deck: deck)
        deck.flashcards.append(flashcard)
        
        // Reset input fields
        newQuestion = ""
        newAnswer = ""
    }
    
    // Delete flashcard
    private func deleteFlashcard(at offsets: IndexSet) {
        // Remove card from deck and context
        for index in offsets {
            let flashcard = deck.flashcards[index]
            context.delete(flashcard)
            deck.flashcards.remove(at: index)
        }
    }
    
    // Import PDF
    private func importPDF(from url: URL) {
        // Load and parse PDF
        guard let pdfText = loadPDFText(url: url) else {
            print("Failed to load PDF text")
            return
        }
        
        print("PDF Text Loaded: \(pdfText)")
        
        let qaPairs = parseQuestionsAndAnswers(text: pdfText)
        print("Number of parsed Q&A pairs: \(qaPairs.count)")
        
        // Create flashcards from content
        for pair in qaPairs {
            let flashcard = Flashcard(
                question: pair.question,
                answer: pair.answer,
                deck: deck
            )
            deck.flashcards.append(flashcard)
            context.insert(flashcard)
            print("Created flashcard: Q: \(pair.question), A: \(pair.answer)")
        }
        
        // Save to context
        try? context.save()
        print("Final flashcard count: \(deck.flashcards.count)")
    }
    
    // Update existing flashcard
    private func updateFlashcard() {
        // Save changes to edited card
        if let card = editingCard {
            card.question = editQuestion
            card.answer = editAnswer
            editingCard = nil
            editQuestion = ""
            editAnswer = ""
        }
    }
    
    // Cancel card editing
    private func cancelEdit() {
        // Reset edit state
        editingCard = nil
        editQuestion = ""
        editAnswer = ""
    }
}

#Preview {
    // Create test container and sample deck
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Deck.self, configurations: config)
    
    let sampleDeck = Deck(name: "Sample Deck")
    
    // Return preview view
    return listOfFlashcardsView(deck: sampleDeck)
        .modelContainer(container)
}

