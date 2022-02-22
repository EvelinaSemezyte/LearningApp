//
//  TestView.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var selectedAnswerIndex: Int?
    @State var submitted = false
    
    @State var numCorrect = 0
    @State var showResults = false
    
    var body: some View {
        
        if model.currentQuestion != nil && showResults == false {
            
            VStack (alignment: .leading) {
                
                // MARK: - Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // MARK: - Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // MARK: - Answers
                ScrollView {
                    
                    VStack {
                        
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button{
                                
                                // Track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack{
                                    
                                    if submitted == false {
                                        
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        
                                        // Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the right answer
                                            // Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            // User has selected the wrong answer
                                            // Show a red background
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        }
                                        else if index == model.currentQuestion!.correctIndex {
                                            // This button is the correct answer
                                            // Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        else {
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    Text(model.currentQuestion!.answers[index])
                                    
                                }
                            }
                            .disabled(submitted)
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                
                // MARK: - Submit Button
                Button{
                    
                    // Check if answer has been submitted
                    if submitted == true {
                        
                        // Check if it's last question
                        if model.currentQuestionIndex + 1 == model.currentModule?.test.questions.count {
                          
                            // Show the results
                            showResults = true
                        }
                        else {
                            // Answer has already been submitted, move to nex question
                            model.nextQuestion()
                            
                            // Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    }
                    else {
                        // Submit the answer
                        
                        // Change submitted state to true
                        submitted = true
                    }
                    
                    
                    // Check the answer and increment the counter if correct
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1                    }
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                .disabled(selectedAnswerIndex == nil)
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else if showResults == true {
           
            
            // If current question is nil, we show the result view
            TestResultView(numCorrect: numCorrect)
        }
        else {
            // Test hasn't loaded yet
            ProgressView()
        }
    }
    
    var buttonText: String {
        
        // Check if answer has been submitted
        if submitted == true {
            if model.currentQuestionIndex + 1 == model.currentModule?.test.questions.count {
                // This is the last question
                return "Finish"
            }
            else {
                // There is the next question
                return "Next"
            }
        }
        else {
            return "Submit"
        }
    }
}

