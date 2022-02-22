//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-15.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            
            // Only show video if we get a valid URL
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            //  Description
            CodeTextView()
            
            // Show lesson button, only if the is a next lesson
            if model.hasNextLesson() {
                
                Button {
                    
                    // Advance the lesson
                    model.nextLesson()
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
            else {
                // SHow the complete button instead
                Button {
                    
                    // Take the uder back to the homeview
                    model.currentContentSelected = nil
                    
                } label: {
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        Text("Complete")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
    }
}


struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
