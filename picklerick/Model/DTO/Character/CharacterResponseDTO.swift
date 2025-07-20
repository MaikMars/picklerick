//
//  CharacterResponseDTO.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

struct CharacterResponseDTO: Codable {
    let info: CharacterResponseInfoDTO
    let results: [CharacterDTO]
}
