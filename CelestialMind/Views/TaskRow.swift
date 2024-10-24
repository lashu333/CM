//
//  TaskRow.swift
//  CelestialMind
//
//  Created by Lasha Tavberidze on 24.10.24.
//

import SwiftUI

struct AnimatedCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                configuration.isOn.toggle()
            }
        }) {
            ZStack {
                Circle()
                    .fill(configuration.isOn ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(configuration.isOn ? Color.green : Color.gray, lineWidth: 2)
                    )
                    .shadow(color: configuration.isOn ? Color.green.opacity(0.3) : Color.clear, radius: 5)
                
                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .bold))
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}
// Animate task card's appearance
struct TaskRowView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    let task: Task
    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var offset: CGFloat = 0
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { task.isCompleted },
                set: { _ in viewModel.toggleTask(task) }
            ))
            .toggleStyle(AnimatedCheckboxStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                if isEditing {
                    TextField("Edit task", text: $editedTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            viewModel.editTask(task, newTitle: editedTitle)
                            isEditing = false
                        }
                } else {
                    Text(task.title)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .gray : .primary)
                }
                
                Group {
                    if task.isCompleted, let completedAt = task.completedAt {
                        Text("Completed: \(completedAt.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("Created: \(task.createdAt.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    editedTitle = task.title
                    isEditing = true
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .scaleEffect(isHovered ? 1.2 : 1.0)
                }
                
                Button {
                    withAnimation(.spring()) {
                        viewModel.deleteTask(task)
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .scaleEffect(isHovered ? 1.2 : 1.0)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(task.isCompleted ? Color.green.opacity(0.1) : Color.white)
                .shadow(color: isHovered ? Color.green.opacity(0.3) : Color.gray.opacity(0.2),
                       radius: isHovered ? 8 : 4)
        )
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation.width
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if abs(value.translation.width) > 100 {
                            viewModel.deleteTask(task)
                        }
                        offset = 0
                    }
                }
        )
        .onHover { hovering in
            withAnimation(.spring()) {
                isHovered = hovering
            }
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(), value: isHovered)
    }
}

