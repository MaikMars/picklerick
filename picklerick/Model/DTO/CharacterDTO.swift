//
//  CharacterDTO.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

struct CharacterDTO: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationDTO
    let location: LocationDTO
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

