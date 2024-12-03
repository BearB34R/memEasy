//
//  pdfParsing.swift
//  memEasy
//
//  Created by Quan Khong on 10/31/24.
//

import Foundation
import SwiftUI
import PDFKit

func loadPDFText(url: URL) -> String? {
    guard let pdfDocument = PDFDocument(url: url) else { return nil }
    var fullText = ""
    
    for pageIndex in 0..<pdfDocument.pageCount {
        if let page = pdfDocument.page(at: pageIndex), let pageText = page.string {
            fullText += pageText + "\n"
        }
    }
    return fullText
}

// func parseQuestionsAndAnswers(text: String) -> [(question: String, answer: String)] {
//     let questionAnswerPattern = #"Q:\s*(.+?)\nA:\s*(.+?)(?=\nQ:|\n?$)"#
//     let regex = try? NSRegularExpression(pattern: questionAnswerPattern, options: [.dotMatchesLineSeparators])
    
//     var flashcards = [(question: String, answer: String)]()
//     let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
    
//     print("Matches found: \(matches?.count ?? 0)")
    
//     matches?.forEach { match in
//         if let questionRange = Range(match.range(at: 1), in: text),
//            let answerRange = Range(match.range(at: 2), in: text) {
//             let question = String(text[questionRange])
//             let answer = String(text[answerRange])
//             flashcards.append((question: question, answer: answer))
//             print("Parsed Flashcard - Question: \(question), Answer: \(answer)")
//         }
//     }
    
//     return flashcards
// }

func parseQuestionsAndAnswers(text: String) -> [(question: String, answer: String)] {
    let questionAnswerPattern = #"Q:\s*(.+?)\nA:\s*(.+?)(?=\nQ:|\n?$)"#
    let regex = try? NSRegularExpression(pattern: questionAnswerPattern, options: [.dotMatchesLineSeparators])
    
    var flashcards = [(question: String, answer: String)]()
    let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
    
    print("PDF Text Content: \(text)")
    print("Matches found: \(matches?.count ?? 0)")
    
    matches?.forEach { match in
        if let questionRange = Range(match.range(at: 1), in: text),
           let answerRange = Range(match.range(at: 2), in: text) {
            let question = String(text[questionRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            let answer = String(text[answerRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            flashcards.append((question: question, answer: answer))
            print("Parsed Flashcard - Question: \(question), Answer: \(answer)")
        }
    }
    
    return flashcards
}

// Add test function in pdfParsing.swift
func testPDFParsing() {
    // Get URL of bundled test PDF
    if let pdfURL = Bundle.main.url(forResource: "Flashcardpdf", withExtension: "pdf") {
        if let pdfText = loadPDFText(url: pdfURL) {
            print("Successfully loaded PDF text:")
            print(pdfText)
            
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

// To use:
// 1. Add PDF file to project in Xcode
// 2. Make sure "Target Membership" is checked for the PDF
// 3. Call testPDFParsing() where needed, like in a test view's onAppear