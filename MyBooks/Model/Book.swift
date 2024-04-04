//
//  Book.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/3/24.
//
// Data Migrations: https://youtu.be/CrWqfCDmPVI?si=fh1m5NdwPQy4Yqbi

import SwiftUI
import SwiftData

@Model
class Book {
    // SwiftData models come with a unique ID for free
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    // NOTE: When renaming a propert in future versions you need to migrate the name
    @Attribute(originalName: "summary") var synopsis: String
    var rating: Int?
    var status: Status.RawValue
    // NOTE: When adding a new property in future versions of the app, set the default value in
    // the property declaration to avoid having the app crash on anyone who has already used
    // it without this new property. The other option would be to make it optional.
    var recommendedBy: String = ""
    
    // Press Control + M to separate onto individual lines
    // Supply default values for anything you DON'T want to be required
    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        synopsis: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
    
    // Icon to represent Status
    var icon: Image {
        switch Status(rawValue: status)! { // force unwrapping is not an issue here
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
}

// Store the status of a Book item
// Int sets the type
// Codable allows it to be stored in SwiftData
// Identifiable allows it to be used in a picker
// CaseIterable allows it to be looped through
enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    
    // Satisfy the identifiable protocol
    var id: Self {
        self
    }
    
    // Display text for each case
    var descr: String {
        switch self {
        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}
