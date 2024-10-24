//
//  CelestialMindApp.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

@main
struct CelestialMindApp: App {
    @StateObject private var taskVM = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TaskListView()
            }
           
        }
    }
}
