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
            NavigationStack {
                VStack {
                    HStack {
                        TextField(String(localized: "search_placeholder"),
                                  text: $viewModel.query
                        )
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
                    if viewModel.characters.isEmpty {
                        Spacer().frame(height: 60)
                        emptyCharactersView
                        Spacer()
                    } else {
                       charactersGrid
                    }
                }
                .navigationDestination(for: Character.self) { character in
                    CharacterDetailsView(character: character)
                }
                .navigationTitle(String(localized: "characters_title"))
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
                }, isPresented: $showFilters, filters: $viewModel.appliedFilters)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            if let message = viewModel.toastMessage {
                VStack {
                    ToastView(message: message)
                        .transition(.opacity)
                        .padding(.top, 8)
                    Spacer()
                }
                .animation(
                    .easeInOut(duration: 0.3),
                    value: viewModel.toastMessage
                )
            }
        }
    }
    
    private var charactersGrid: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(
                    viewModel.characters,
                    id: \.id
                ) { character in
                    NavigationLink(value: character) {
                        VStack(spacing: 8) {
                            AsyncCachedImage(
                                url: URL(
                                    string: character.imageURL
                                )!,
                                width: 160,
                                height: 160
                            )
                            Text(character.name)
                                .font(.headline)
                                .lineLimit(1)
                                .padding(.horizontal)
                        }
                        .onAppear {
                            Task {
                                await viewModel
                                    .loadMoreIfNeeded(
                                        after: character
                                    )
                            }
                        }
                    }
                    .buttonStyle(.plain)
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
    
    private var emptyCharactersView: some View {
    
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.secondary)

            Text(String(localized:"no_character_found_title"))
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)

            Text(String(localized:"no_character_found_subtitle"))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
    
}



#Preview {
    CharactersGridView()
}

