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
    @Environment(\.dismiss) private var dismiss
    
    // Add these new state variables
    @State private var editingCard: Flashcard?
    @State private var editQuestion: String = ""
    @State private var editAnswer: String = ""
    
    var body: some View {
        ZStack {
            // Add background color
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed buttons section
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
                .padding()
                
                // Scrollable content
                List {
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
                        .listRowBackground(Color.clear) // Add this line
                    }
                    
                    // List of existing flashcards
                    Section(header: 
                        Text("Flashcards")
                            .foregroundColor(Color("TextColor"))
                    ) {
                        ForEach(deck.flashcards) { card in
                            VStack(alignment: .leading, spacing: 8) {
                                if editingCard?.id == card.id {
                                    // Edit form
                                    VStack(spacing: 10) {
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
                                    // Regular card view
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Q: \(card.question)")
                                            .font(.headline)
                                            .foregroundColor(Color("TextColor"))
                                        Text("A: \(card.answer)")
                                            .font(.subheadline)
                                            .foregroundColor(Color("CorrectColor"))
                                    }
                                    .contentShape(Rectangle()) // Make entire area tappable
                                    .onTapGesture {
                                        editingCard = card
                                        editQuestion = card.question
                                        editAnswer = card.answer
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteFlashcard)
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden) // This hides the default List background
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Changes to inline to remove large title
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("MainColor"))
                        .imageScale(.large)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(deck.name)
                    .font(.title2.bold())
                    .foregroundColor(Color("MainColor"))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: flashcardView(deck: deck)) {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
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
        let flashcard = Flashcard(question: newQuestion, answer: newAnswer, deck: deck)
        deck.flashcards.append(flashcard)
        
        // Reset input fields but don't close the form
        newQuestion = ""
        newAnswer = ""
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
        
        print("PDF Text Loaded: \(pdfText)") // Check the loaded text
        
        let qaPairs = parseQuestionsAndAnswers(text: pdfText)
        
        // Create flashcards from the parsed Q&A pairs
        for pair in qaPairs {
            let flashcard = Flashcard(
                question: pair.question,
                answer: pair.answer,
                deck: deck
            )
            deck.flashcards.append(flashcard)
        }
        
        print("Parsed Flashcards: \(qaPairs)") // Check parsed Q&A pairs
    }
    
    // Add these new functions
    private func updateFlashcard() {
        if let card = editingCard {
            card.question = editQuestion
            card.answer = editAnswer
            editingCard = nil
            editQuestion = ""
            editAnswer = ""
        }
    }
    
    private func cancelEdit() {
        editingCard = nil
        editQuestion = ""
        editAnswer = ""
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

