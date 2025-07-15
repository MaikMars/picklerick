//
//  CharacterDTO+Mapper.swift
//  picklerick
//
//  Created by Miki on 15/7/25.
//

import Foundation

extension CharacterDTO {
    func toDomain() -> Character {
           Character(
               id: id,
               name: name,
               status: status,
               species: species,
               gender: gender,
               imageURL: image
           )
       }
}
