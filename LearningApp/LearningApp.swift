//
//  LearningApp.swift
//  LearningApp
//
//  Created by Evelina Semezyte on 2022-02-14.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
