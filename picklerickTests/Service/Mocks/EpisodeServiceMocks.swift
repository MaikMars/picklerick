//
//  EpisodeServiceMocks.swift
//  picklerickTests
//
//  Created by Miki on 20/7/25.
//

import Foundation

enum EpisodeServiceMocks {
    static let episodesJSONString = """
        [
          {
            "id": 1,
            "name": "Close Rick-counters of the Rick Kind",
            "air_date": "April 7, 2014",
            "episode": "S01E10",
            "characters": [
              "https://rickandmortyapi.com/api/character/1",
              "https://rickandmortyapi.com/api/character/2"
            ],
            "url": "https://rickandmortyapi.com/api/episode/10",
            "created": "2017-11-10T12:56:34.747Z"
          },
          {
            "id": 2,
            "name": "The Ricklantis Mixup",
            "air_date": "September 10, 2017",
            "episode": "S03E07",
            "characters": [
              "https://rickandmortyapi.com/api/character/1",
              "https://rickandmortyapi.com/api/character/2"
            ],
            "url": "https://rickandmortyapi.com/api/episode/28",
            "created": "2017-11-10T12:56:36.618Z"
          }
        ]
        """.data(using: .utf8)!
    
    static let episodesJSONString2 = """
        {
            "id": 5,
            "name": "Close Rick-counters of the Rick Kind",
            "air_date": "April 7, 2014",
            "episode": "S01E10",
            "characters": [
              "https://rickandmortyapi.com/api/character/1",
              "https://rickandmortyapi.com/api/character/2",
            ],
            "url": "https://rickandmortyapi.com/api/episode/10",
            "created": "2017-11-10T12:56:34.747Z"
          }
        """.data(using: .utf8)!
}
