//
//  CharactersGridView.swift
//  picklerick
//
//  Created by Miki on 16/7/25.
//

import SwiftUI

struct CharactersGridView: View {
    @StateObject private var viewModel: CharactersGridViewModelImpl
    
    init(
        viewModel: CharactersGridViewModelImpl = CharactersGridViewModelImpl()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                LazyVGrid(
                    columns: Array(
                        repeating: .init(.flexible(), spacing: 0),
                        count: 2
                    ),
                    spacing: 12
                ) {
                    ForEach(viewModel.characters, id: \.id) { character in
                        VStack(spacing: 8) {
                            AsyncImage(
                                url: URL(string: character.imageURL)
                            ) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 160, height: 160)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 12)
                                        )
                                } else {
                                    ProgressView()
                                        .frame(width: 160, height: 160)
                                }
                            }
                            Text(character.name)
                                .font(.headline)
                                .lineLimit(1)
                                .padding(.horizontal)
                        }
                        .onAppear {
                            Task {
                                await viewModel
                                    .loadMoreIfNeeded(after: character)
                            }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("Characters")
        .task {
            await viewModel.loadFirstCharactersPage()
        }
    }
}
       

#Preview {
    CharactersGridView()
}
