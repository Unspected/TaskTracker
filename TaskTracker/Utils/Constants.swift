//
//  Constants.swift
//  TaskTracker
//
//  Created by Pavel Andreev on 1/13/23.
//

import Foundation
import UIKit

struct Constants {
    
    static var hasToNotch: Bool {
        guard #available(iOS 11, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first  else { return false }
        return window.safeAreaInsets.top >= 44
    }
}
