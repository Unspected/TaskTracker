//
//  FoundationExtansions.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import UIKit

extension Int {
    func appendZeroes() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

extension Double {
    func degreeToRadiance() -> CGFloat {
        return CGFloat(self * .pi) / 180
    }
}
