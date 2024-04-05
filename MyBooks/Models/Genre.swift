//
//  Genre.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//

import SwiftData
import SwiftUI

@Model
class Genre {
    var name: String
    var color: String
    var books: [Book]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }
}
