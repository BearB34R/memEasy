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


func parseQuestionsAndAnswers(text: String) -> [(question: String, answer: String)] {
    
    // "Q: What is ...?"
    // "A: The answer is ..."
    let questionAnswerPattern = #"Q:\s*(.+?)\nA:\s*(.+?)(?=\nQ:|\n?$)"#
    let regex = try? NSRegularExpression(pattern: questionAnswerPattern, options: [.dotMatchesLineSeparators])
    
    var flashcards = [(question: String, answer: String)]()
    let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
    
    matches?.forEach { match in
        if let questionRange = Range(match.range(at: 1), in: text),
           let answerRange = Range(match.range(at: 2), in: text) {
            let question = String(text[questionRange])
            let answer = String(text[answerRange])
            flashcards.append((question: question, answer: answer))
        }
    }
    
    return flashcards
}

