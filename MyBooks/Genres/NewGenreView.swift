//
//  NewGenreView.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//

import SwiftData
import SwiftUI

struct NewGenreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var color = Color.red
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                
                ColorPicker("Set the genre color", selection: $color, supportsOpacity: false)
                
                Button("Create") {
                    let newGenre = Genre(name: name, color: color.toHexString()!)
                    modelContext.insert(newGenre)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(name.isEmpty)
            }
            .padding()
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NewGenreView()
}
