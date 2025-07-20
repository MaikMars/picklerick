//
//  EpisodeDTO.swift
//  picklerick
//
//  Created by Miki on 18/7/25.
//

import Foundation


struct EpisodeDTO: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url
        case airDate = "air_date"
        case created
    }
}
