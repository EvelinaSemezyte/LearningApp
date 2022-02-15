//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-15.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson card
        ZStack (alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack(spacing: 30){
                 
                Text(String(index + 1))
                    .font(.body)
                    .bold()
                VStack(alignment: .leading){
                    
                    Text(lesson.title)
                        .bold()
                    
                    Text("Video - \(lesson.duration)")
                        .font(.caption)
                }
            }
            .padding()
        }
        .padding(.bottom, 5)
    }
}

