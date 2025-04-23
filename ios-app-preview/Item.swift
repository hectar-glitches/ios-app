//
//  Item.swift
//  ios-app-preview
//
//  Created by Hectar Carson on 3/16/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
