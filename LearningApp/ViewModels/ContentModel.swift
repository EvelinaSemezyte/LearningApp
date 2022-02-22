//
//  ContentModel.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-14.
//

import Foundation


class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current style explanation
    @Published var codeText = NSAttributedString()
    
    // Style Data
    var styleData: Data?
    
    // Current Selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init() {
        // Parse local included json data
        getLocalData()
        
        // Download remote json and parse data
        getRemoteData()
    }
    
    //  MARK: - Data Methods
    func getLocalData() {
        
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        }
        catch{
            // TODO log error
            print("Couldn't parse local data: \(error)")
            
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data: \(error)")
        }
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://evelinasemezyte.github.io/learningapp-data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask =  session.dataTask(with: request) { data, response, error in
            
            // Check if there's an error
            guard error == nil else {
                // There was an error
                return
            }
            
            // Handle the responce
            do {
                
                // Create json decoder
                let decoder = JSONDecoder()
                
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property
                self.modules += modules
                
            }
            catch {
                // Couldn't parse json
            }
        }
        
        // Kick off data task
        dataTask.resume()
    }
    
    // MARK: - Module navigation methods
    func beginModule(_ moduleid: Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    // MARK: - Lesson navigation methods
    func beginLesson(_ lessonIndex: Int) {
        
        // Check that the lesson index is within range of module lesson
        if lessonIndex < currentModule!.content.lessons.count {
            
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
        
    }
    
    // MARK: - Next Lesson method
    func nextLesson() {
        
        // Advance the next lesson
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }else{
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
        
    }
    
    // MARK: - Test navigation methods
    func beginTest(_ moduleId: Int){
        
        // Set current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // If there are question, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    // MARK: - Next Question method
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's within the rangeof questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
            // If not, the reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    // MARK: - Code Styling
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        return resultString
    }
}
