//
//  Character.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

struct Character: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let imageURL: String
    let originName: String
    let episodes: [Int]
}
