//
//  CharactersGridView.swift
//  picklerick
//
//  Created by Miki on 16/7/25.
//

import SwiftUI
struct CharactersGridView: View {
    @StateObject private var viewModel: CharactersGridViewModelImpl
    @State private var showFilters = false
    
    init() {
        let vm = CharactersGridViewModelImpl()
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Search character by \(viewModel.searchType)", text: $viewModel.query)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button {
                            withAnimation {
                                showFilters.toggle()
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .padding(.leading, 8)
                        }
                    }.padding()
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.characters, id: \.id) { character in
                                VStack(spacing: 8) {
                                    AsyncImage(url: URL(string: character.imageURL)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 160, height: 160)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
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
                                        await viewModel.loadMoreIfNeeded(after: character)
                                    }
                                }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Characters")
                .task {
                    await viewModel.loadFirstCharactersPage()
                }
            }
            
            if showFilters {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                
                FiltersView(onApply: {
                    withAnimation {
                        showFilters = false
                    }
                }, isPresented: $showFilters, seachType: $viewModel.searchType, filters: $viewModel.appliedFilters)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        
    }
}

#Preview {
    CharactersGridView()
}

