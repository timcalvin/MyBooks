//
//  EditBookView.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/3/24.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) var dismiss
    
    let book: Book
    
    // If you want SwiftData to instantly update entries as soon as changes are made, then you
    // would wrape the book property above with the @Bindable property wrapper and use bindings
    // to the books properties. If you don't want instant updates, create @State properties
    // for each of the books properties and update manually
    @State private var status = Status.onShelf
    @State private var rating: Int?
    @State private var title = ""
    @State private var author = ""
    @State private var synopsis = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var recommendedBy = ""
    
    // Setting the dates in onAppear can mess up the onChange method. To Fix that add this property
    // and use this property to check that it's not the first view in the onChange(of: status) call.
    @State private var firstView = true
    
    var body: some View {
        VStack {
            Text("Status")
            
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
            
            VStack(alignment: .leading) {
                GroupBox {
                    LabeledContent {
                        DatePicker("", selection: $dateAdded, displayedComponents: .date)
                    } label: {
                        Text("Date Added")
                    }
                    
                    if status == .inProgress || status == .completed {
                        LabeledContent {
                            DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                        } label: {
                            Text("Date Started")
                        }
                    }
                    
                    if status == .completed {
                        LabeledContent {
                            DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                        } label: {
                            Text("Date Completed")
                        }
                    }
                }
                .foregroundStyle(.secondary)
                .onChange(of: status) { oldValue, newValue in
                    if !firstView {
                        if newValue == .onShelf {
                            dateStarted = Date.distantPast
                            dateCompleted = Date.distantPast
                        } else if newValue == .inProgress && oldValue == .completed {
                            // From completed to inProgress
                            dateCompleted = Date.distantPast
                        } else if newValue == .inProgress && oldValue == .onShelf {
                            // Book has been started
                            dateStarted = Date.now
                        } else if newValue == .completed && oldValue == .onShelf {
                            // Forgot to start book
                            dateCompleted = Date.now
                            dateStarted = dateAdded
                        } else {
                            // Completed
                            dateCompleted = Date.now
                        }
                        firstView = false
                    }
                }
                
                Divider()
                
                LabeledContent {
                    RatingsView(maxRating: 5, currentRating: $rating, width: 30)
                } label: {
                    Text("Rating")
                }
                
                LabeledContent {
                    TextField("", text: $title)
                } label: {
                    Text("Title").foregroundStyle(.secondary)
                }
                
                LabeledContent {
                    TextField("", text: $author)
                } label: {
                    Text("Author").foregroundStyle(.secondary)
                }
                
                LabeledContent {
                    TextField("", text: $recommendedBy)
                } label: {
                    Text("Recommended By").foregroundStyle(.secondary)
                }
                
                Divider()
                
                Text("Synopsis").foregroundStyle(.secondary)
                TextEditor(text: $synopsis)
                    .padding(5)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if changed {
                    Button("Update") {
                        // If anything changed, update and persist the values
                        book.status = status.rawValue
                        book.rating = rating
                        book.title = title
                        book.author = author
                        book.synopsis = synopsis
                        book.dateAdded = dateAdded
                        book.dateStarted = dateStarted
                        book.dateCompleted = dateCompleted
                        book.recommendedBy = recommendedBy
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                status = Status(rawValue: book.status)! // force unwrapping is ok here
                rating = book.rating
                title = book.title
                author = book.author
                synopsis = book.synopsis
                dateAdded = book.dateAdded
                dateStarted = book.dateStarted
                dateCompleted = book.dateCompleted
                recommendedBy = book.recommendedBy
            }
        }
        
        var changed: Bool {
            // Option + Click and drag to drag out multiple cursors at the beginning of a line
            // Control + Shift + Click to individually place multiple cursors
            status != Status(rawValue: book.status)
            || rating != book.rating
            || title != book.title
            || author != book.author
            || synopsis != book.synopsis
            || dateAdded != book.dateAdded
            || dateStarted != book.dateStarted
            || dateCompleted != book.dateCompleted
            || recommendedBy != book.recommendedBy
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    return NavigationStack {
        EditBookView(book: Book.sampleBooks[4])
            .modelContainer(preview.container)
    }
}

