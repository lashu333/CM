//
//  TaskViewModel.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let saveKey = "tasks"
    
    init() {
        loadTasks()
    }
    
    // MARK: - Task Operations
    func addTask(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert = true
            alertMessage = "Task cannot be empty"
            return
        }
        
        let task = Task(title: title)
        tasks.append(task)
        saveTasks()
    }
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            tasks[index].completedAt = tasks[index].isCompleted ? Date() : nil
            saveTasks()
        }
    }
    
    func editTask(_ task: Task, newTitle: String) {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = newTitle
            tasks[index].isCompleted = false
            tasks[index].completedAt = nil
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll(where: { $0.id == task.id })
        saveTasks()
    }
    
    func checkAllTasks() {
        tasks = tasks.map { task in
            var updatedTask = task
            updatedTask.isCompleted = true
            updatedTask.completedAt = Date()
            return updatedTask
        }
        saveTasks()
    }
    
    func clearCompleted() {
        tasks.removeAll(where: { $0.isCompleted })
        saveTasks()
    }
    
    func clearAll() {
        tasks.removeAll()
        saveTasks()
    }
    
    // MARK: - Statistics
    var totalTasks: Int {
        tasks.count
    }
    
    var completedTasks: Int {
        tasks.filter({ $0.isCompleted }).count
    }
    
    var uncompletedTasks: Int {
        tasks.filter({ !$0.isCompleted }).count
    }
    
    var progress: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks) * 100
    }
    
    // MARK: - Persistence
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}

