//
//  Box.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    
    var value:T {
        didSet {
            listener?(value)
        }
    }
    var listener: Listener?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func removeBinding() {
        self.listener = nil
    }
}
