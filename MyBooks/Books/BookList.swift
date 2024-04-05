//
//  BookList.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//

import SwiftData
import SwiftUI

struct BookList: View {
    @Environment(\.modelContext) private var modelContext
    
    // Read items from the database
    // The sort propert tells SwiftData which key to sort on
    @Query(sort: \Book.title) private var books: [Book]
    
    // Initializer that allows us to pass in an enum to update query
    init(sortOrder: SortOrder, filterString: String) {
        // Sort Queries
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.author)]
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        }
        
        // Filter predicates
        let predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filterString)
            || book.author.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        
        _books = Query(filter:predicate, sort: sortDescriptors)
    }
    
    var body: some View {
        Group {
            // Check for an empty state and display ContentUnavailableView if so
            if books.isEmpty {
                ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink {
                            EditBookView(book: book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title2)
                                    Text(book.author).foregroundStyle(.secondary)
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(1..<rating, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                    
                                    // List of Genres
                                    if let genres = book.genres {
                                        ViewThatFits {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                GenresStackView(genres: genres)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            // Delete the item from the database
                            modelContext.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return NavigationStack {
        BookList(sortOrder: .status, filterString: "")
    }
    .modelContainer(preview.container)
    
}

