//
//  CodeTextView.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-17.
//

import SwiftUI

struct CodeTextView: UIViewRepresentable{
   
    @EnvironmentObject var model: ContentModel
    
    func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = false
        
        return textView
    }
    
    func updateUIView(_ textView: UIViewType, context: Context) {
        
        // Set the atributed Text for the lesson
        textView.attributedText = model.codeText
        
        // Scroll back to the top
        textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
}

struct CodeTextView_Previews: PreviewProvider {
    static var previews: some View {
        CodeTextView()
    }
}
