//
//  SeasonSection.swift
//  picklerick
//
//  Created by Miki on 19/7/25.
//

import Foundation

struct SeasonSection: Identifiable {
    let id: Int
    let season: Int
    let episodes: [Episode]
}
