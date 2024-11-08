//
//  studyFlashcardsView.swift
//  memEasy
//
//  Created by Andy Do on 11/2/24.
//

import SwiftUI

struct studyFlashcardsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // ... rest of your view content ...
        }
        .navigationTitle("Study")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("MainColor"))
                        Text("Back")
                            .foregroundColor(Color("MainColor"))
                    }
                }
            }
        }
    }
}

#Preview {
    studyFlashcardsView()
}
