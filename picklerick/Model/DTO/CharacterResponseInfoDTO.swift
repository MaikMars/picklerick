//
//  CharacterResponseInfoDTO.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

struct CharacterResponseInfoDTO: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
