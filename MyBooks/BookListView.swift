//
//  BookListView.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/3/24.
//

import SwiftData
import SwiftUI

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, author
    
    var id: Self {
        self
    }
}

struct BookListView: View {
    // Property used to show a sheet for creating a new book
    @State private var createNewBook = false
    
    // Property for sorting dynamically
    @State private var sortOrder = SortOrder.status
    
    // State property for search text field
    @State private var filter = ""
    
    var body: some View {
        NavigationStack {
            // Sort order Picker
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                }
            }
            .buttonStyle(.bordered)
            
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: Text("Filter on title or author")) // creates a search box
                .navigationTitle("My Books")
                .toolbar {
                    Button {
                        createNewBook = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium]) // Present the sheet as a partial cover
                }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return BookListView()
        .modelContainer(preview.container)
}

