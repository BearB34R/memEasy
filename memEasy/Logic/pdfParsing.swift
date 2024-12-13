//
//  pdfParsing.swift
//  memEasy
//
//  Created by Quan Khong on 10/31/24.
//

import Foundation
import SwiftUI
import PDFKit

/// Loads the text content from a PDF file located at the specified URL.
/// - Parameter url: The file URL of the PDF.
/// - Returns: A concatenated string containing the text from all pages of the PDF, or nil if the PDF cannot be loaded.
func loadPDFText(url: URL) -> String? {
    // Try to create a PDFDocument from the URL. Return nil if it fails.
    guard let pdfDocument = PDFDocument(url: url) else { return nil }
    
    var fullText = ""
    
    // Loop through all pages in the PDF document.
    for pageIndex in 0..<pdfDocument.pageCount {
        // Get the page at the current index and extract its text content.
        if let page = pdfDocument.page(at: pageIndex), let pageText = page.string {
            // Append the text to the fullText string, with a newline for separation.
            fullText += pageText + "\n"
        }
    }
    return fullText
}

/// Parses questions and answers from a string using a specific format.
/// The text should follow the format:
/// Q: Question
/// A: Answer
/// - Parameter text: The input string containing questions and answers.
/// - Returns: An array of tuples where each tuple contains a question and its corresponding answer.
func parseQuestionsAndAnswers(text: String) -> [(question: String, answer: String)] {
    // Regular expression pattern for matching questions and answers.
    let questionAnswerPattern = #"Q:\s*(.+?)\nA:\s*(.+?)(?=\nQ:|\n?$)"#
    // Try to create a regex object with the pattern.
    let regex = try? NSRegularExpression(pattern: questionAnswerPattern, options: [.dotMatchesLineSeparators])
    
    var flashcards = [(question: String, answer: String)]()
    // Find matches of the regex in the input text.
    let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
    
    // Print the content of the PDF text for debugging purposes.
    print("PDF Text Content: \(text)")
    print("Matches found: \(matches?.count ?? 0)")
    
    matches?.forEach { match in
        // Extract the question and answer using the captured groups from the regex.
        if let questionRange = Range(match.range(at: 1), in: text),
           let answerRange = Range(match.range(at: 2), in: text) {
            let question = String(text[questionRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            let answer = String(text[answerRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            // Append the parsed question and answer to the flashcards array.
            flashcards.append((question: question, answer: answer))
            print("Parsed Flashcard - Question: \(question), Answer: \(answer)")
        }
    }
    
    return flashcards
}

/// Test function for loading and parsing a PDF file.
/// This function demonstrates the process of loading a PDF file, extracting its text, and parsing questions and answers.
func testPDFParsing() {
    // Get the URL of a test PDF file included in the app bundle.
    if let pdfURL = Bundle.main.url(forResource: "Flashcardpdf", withExtension: "pdf") {
        // Attempt to load the text content from the PDF.
        if let pdfText = loadPDFText(url: pdfURL) {
            print("Successfully loaded PDF text:")
            print(pdfText)
            
            // Parse the text content into flashcards.
            let flashcards = parseQuestionsAndAnswers(text: pdfText)
            print("\nParsed \(flashcards.count) flashcards:")
            flashcards.forEach { card in
                print("\nQuestion: \(card.question)")
                print("Answer: \(card.answer)")
            }
        } else {
            print("Failed to load PDF text")
        }
    } else {
        print("Could not find PDF in bundle")
    }
}

// Usage Instructions:
// 1. Add a PDF file to your project in Xcode.
// 2. Ensure "Target Membership" is checked for the PDF file.
// 3. Call the testPDFParsing() function where needed, e.g., in a test view's onAppear.
