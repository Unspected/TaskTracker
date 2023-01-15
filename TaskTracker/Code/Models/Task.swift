//
//  Task.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import Foundation

struct TaskType {
    let symbolName: String
    let typeName: String
    
}

struct Task {
    var taskName: String
    var taskDescription: String
    var seconds: Int
    var taskType: TaskType
    
    var timeStemp: Double
    
}

enum CountDownState {
    case suspended
    case running
    case paused
}
