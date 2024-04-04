//
//  PreviewContainer.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//
// Working with Previews in SwiftData: https://www.youtube.com/watch?v=jCC3yuc5MUI&t=0s

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addExamples(_ examples: [any PersistentModel]) {
        examples.forEach { examples in
            Task { @MainActor in
                container.mainContext.insert(examples)
            }
        }
    }
}
