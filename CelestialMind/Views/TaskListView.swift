//
//  TaskListView.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    @State private var showingProgressCircle = false
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(#colorLiteral(red: 0.8509803922, green: 0.9215686275, blue: 0.8235294118, alpha: 1)),
                        Color(#colorLiteral(red: 0.7843137255, green: 0.8980392157, blue: 0.7647058824, alpha: 1))
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Stats View
                    HStack(spacing: 30) {
                        StatView(title: "Total", count: viewModel.totalTasks)
                
                            .transition(.scale.combined(with: .opacity))
                        StatView(title: "Completed", count: viewModel.completedTasks)
                            .transition(.scale.combined(with: .opacity))
                        StatView(title: "Remaining", count: viewModel.uncompletedTasks)
                            .transition(.scale.combined(with: .opacity))
                    }
                    .padding()
                    
                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                            .frame(width: 100, height: 100)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.progress) / 100)
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(), value: viewModel.progress)
                        
                        Text("\(Int(viewModel.progress))%")
                            .font(.title2)
                            .bold()
                    }
                    .opacity(showingProgressCircle ? 1 : 0)
                    .onAppear { showingProgressCircle = true }
                    
                    // Task Input
                    HStack {
                        TextField("Add new task", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(color: Color.green.opacity(0.2), radius: 5)
                        
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                                .symbolEffect(.bounce, value: newTaskTitle)
                        }
                    }
                    .padding()
                    
                    // Task List
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.tasks) { task in
                                TaskRowView(task: task)
                                    .transition(.asymmetric(
                                        insertion: .scale.combined(with: .opacity),
                                        removal: .scale.combined(with: .opacity)
                                    ))
                            }
                        }
                        .padding()
                    }
                    
                    // Action Buttons
                    if !viewModel.tasks.isEmpty {
                        HStack(spacing: 20) {
                            ActionButton(title: "Check All", icon: "checkmark.circle.fill", color: .green) {
                                viewModel.checkAllTasks()
                            }
                            
                            ActionButton(title: "Clear Completed", icon: "trash.circle.fill", color: .orange) {
                                viewModel.clearCompleted()
                            }
                            
                            ActionButton(title: "Clear All", icon: "xmark.circle.fill", color: .red) {
                                viewModel.clearAll()
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Tasks")
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
        .environmentObject(viewModel)
    }
    
    private func addTask() {
        withAnimation(.spring()) {
            viewModel.addTask(title: newTaskTitle)
            newTaskTitle = ""
        }
    }
}
#Preview {
    TaskListView()
}
