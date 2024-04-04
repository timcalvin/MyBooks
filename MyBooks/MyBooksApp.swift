//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/3/24.
//

import SwiftData
import SwiftUI

@main
struct MyBooksApp: App {
    // Allows us to configure the ModelContainer to our liking, such as storing in a custom location
    // or using a custom file name.
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        // OPTION + CLICK on a method to get more information on it
        // The following commented line is the standard way of creating a ModelContainer
        // .modelContainer(for: Book.self) // Create model container
        // The following is how to create a custome configured container
        .modelContainer(container)
    }
    
    init() {
        // Configure the model container with a custom name but keep in in the Application Support folder
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        
        /* Configure the model container and place in a custom location
        let config = ModelConfiguration(url: URL.documentsDirectory.appending(path: "MyBooks.store"))
        do {
            container = try ModelContainer(for: Book.self, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        } */
        
        // Print the location of the data to the console which you can use to view the data file
        // A free editor is https://sqlitebrowser.org
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        // The following commented out line would work in conjunction with the custom name and location method above
        // print(URL.documentsDirectory.path())
    }
}

// QUESTIONS:
// 1. How do you perform queries and filters on child entities?
// 2. How do you show only the children of a parent?
// 3. How do you allow iCloud sharing?
