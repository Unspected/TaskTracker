//
//  TaskViewModel.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import Foundation

class TaskViewModel {
    
    
    // MARK: - variables
    private var task: Task!
    
    private let taskType: [TaskType] = [
        TaskType(symbolName: "star", typeName: "Priority"),
        TaskType(symbolName: "macbook.and.iphone", typeName: "Develop"),
        TaskType(symbolName: "gamecontroller", typeName: "Gaming"),
        TaskType(symbolName: "wand.and.stars.inverse", typeName: "Editing")
    ]
    
    private var selectedIndex = -1 {
        didSet {
            //set type task here
            self.task.taskType = self.getTaskTypes()[selectedIndex]
        }
    }
    
    private var hours = Box(0)
    private var minutes = Box(0)
    private var seconds = Box(0)
    
    init() {
        task = Task(taskName: "", taskDescription: "", seconds: 0, taskType: .init(symbolName: "", typeName: ""), timeStemp: 0)
    }
    
    // MARK: - functions
    
    func setSelectedIndex(to value: Int) {
        self.selectedIndex = value
    }
    
    func setTaskName(to value: String) {
        self.task.taskName = value
    }
    
    func setTaskDescription(to value: String) {
        self.task.taskDescription = value
    }
    
    func getSelectedIndex() -> Int {
        self.selectedIndex
    }
    
    func getTask() -> Task {
        return self.task
    }
    
    func getTaskTypes() -> [TaskType] {
        return self.taskType
    }
    
    func setHours(to value: Int) {
        hours.value = value
    }
    
    func setMinutes(to value: Int) {
        minutes.value = value
    }
    
    func setSeconds(to value: Int) {
        seconds.value = value
    }
    
    func getHours() -> Box<Int> {
        return self.hours
    }
    
    func getMinutes() -> Box<Int> {
        return self.minutes
    }
    
    func getSeconds() -> Box<Int> {
        return self.seconds
    }
    
    
}
