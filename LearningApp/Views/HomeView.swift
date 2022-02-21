//
//  ContentView.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-14.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("What would you like to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                NavigationLink (
                                    destination :
                                        ContentView()
                                        .onAppear {
                                            model.beginModule(module.id)
                                        },
                                    tag: module.id,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        
                                        // Learning Card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    })
                                
                                // Test Card
                                NavigationLink(
                                    destination:
                                        TestView()
                                        .onAppear(perform: {
                                            model.beginTest(module.id)
                                            
                                        }),
                                    tag: module.id,
                                    selection: $model.currentTestSelected){
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                                    }
                                NavigationLink(destination: EmptyView()) {
                                    EmptyView()
                                }
                            }
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
            }
            .navigationTitle("Get Started")
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
