//
//  CharacterDTO+Mapper.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

extension CharacterDTO {
    func toDomain() -> Character {
        
        let episodeIDs: [Int] = episode.compactMap { urlString in
            guard let idString = urlString.split(separator: "/").last,
                  let id = Int(idString) else { return nil }
            return id
        }
        
        return Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type.isEmpty ? nil : type,
            gender: gender,
            imageURL: image,
            originName: origin.name,
            episodes: episodeIDs
        )
    }
}
