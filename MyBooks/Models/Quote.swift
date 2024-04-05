//
//  Quote.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//

import Foundation
import SwiftData

@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    // Establish a relationship to the parent Model
    var book: Book?
}
