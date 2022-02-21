//
//  TestView.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        if model.currentQuestion != nil {
            VStack {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                // Answers
                
                // Button
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else{
            // Test hasn't loaded yet
            ProgressView()
        }
    }
}

