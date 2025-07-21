//
//  CharacterDetailsView.swift
//  picklerick
//
//  Created by Miki on 17/7/25.
//

import SwiftUI

struct CharacterDetailsView: View {
    let character: Character
    @State private var expandedSeasons: Set<Int> = []
    @StateObject private var viewModel: CharacterDetailsViewModelImpl

    init(character: Character) {
        self.character = character
        _viewModel = StateObject(
            wrappedValue: CharacterDetailsViewModelImpl(character: character)
        )
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    characterImage
                    characterInfo
                    Divider()
                    episodesSection
                }
                .padding()
            }
            .task {
                await viewModel.loadEpisodes()
            }
            if let message = viewModel.toastMessage {
                VStack {
                      ToastView(message: message)
                          .transition(.opacity)
                          .padding(.top, 8)
                      Spacer()
                  }
                  .animation(.easeInOut(duration: 0.3), value: viewModel.toastMessage)
            }
        }
    }

    private var characterImage: some View {
        AsyncCachedImage(
            url: URL(string: character.imageURL)!,
            width: 250,
            height: 250
        )
    }

    private var characterInfo: some View {
        VStack(spacing: 8) {
            Text(character.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 16)

            InfoRowView(
                label: String(localized: "status_title"),
                value: character.status
            )
            InfoRowView(
                label: String(localized: "species_title"),
                value: character.species
            )
            InfoRowView(
                label: String(localized: "gender_title"),
                value: character.gender
            )

            if let type = character.type, !type.isEmpty {
                InfoRowView(
                    label: String(localized: "type_title"),
                    value: type
                )
            }

            InfoRowView(
                label: String(localized: "origin_title"),
                value: character.originName
            )
        }
        .padding(.horizontal)
    }

    private var episodesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "episodes_title"))
                .font(.headline)
                .padding(.horizontal)

            if viewModel.seasonSection.isEmpty {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(viewModel.seasonSection) { section in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedSeasons.contains(section.season) },
                            set: { expanded in
                                if expanded {
                                    expandedSeasons.insert(section.season)
                                } else {
                                    expandedSeasons.remove(section.season)
                                }
                            }
                        ),
                        content: {
                            VStack() {
                                ForEach(section.episodes, id: \.id) { episode in
                                    HStack() {
                                        Text(
                                            "#\(episode.episodeNumber) \(String(localized: "season_title")) \(episode.name)"
                                        ).font(.callout)
                                            .fontWeight(.thin)
                                            .padding(.horizontal)
                                        Spacer()
                                    }.padding(.vertical, 6)
                                }
                            }.background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        },
                        label: {
                            Text(
                                "\(String(localized: "season_title")) \(section.season)"
                            )
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        }
                    )
                    .padding(.horizontal)
                }
            }
        }
        .padding(.horizontal)
    }
}




#Preview {
    CharacterDetailsView(
        character: Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            originName: "Earth",
            episodes: [1,40]
        )
    )
}

