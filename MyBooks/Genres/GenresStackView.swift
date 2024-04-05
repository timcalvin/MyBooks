//
//  GenresStackView.swift
//  MyBooks
//
//  Created by Timothy Bryant on 4/4/24.
//

import SwiftUI

struct GenresStackView: View {
    var genres: [Genre]
    
    var body: some View {
        HStack {
            ForEach(genres.sorted(using: KeyPathComparator(\Genre.name))) { genre in
                Text(genre.name)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 5).fill(genre.hexColor))
            }
        }
    }
}
