//
//  RnMCharacterServiceTests.swift
//  
//
//  Created by Miki on 15/7/25.
//

import Testing
import XCTest
@testable import picklerick


final class RnMCharacterServiceTests: XCTestCase {

    var service: RnMCharacterServiceImpl!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        service = RnMCharacterServiceImpl(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }

    func testFetchAllCharacters_Success() async throws {
        // Given
        let mockJSON = """
            {
              "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character/?page=1",
                "prev": null
              },
              "results": [
                {
                  "id": 1,
                  "name": "Rick Sanchez",
                  "status": "Alive",
                  "species": "Human",
                  "type": "",
                  "gender": "Male",
                  "origin": {
                    "name": "Earth",
                    "url": "https://rickandmortyapi.com/api/location/1"
                  },
                  "location": {
                    "name": "Earth",
                    "url": "https://rickandmortyapi.com/api/location/20"
                  },
                  "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                  "episode": [
                    "https://rickandmortyapi.com/api/episode/1",
                    "https://rickandmortyapi.com/api/episode/2"
                  ],
                  "url": "https://rickandmortyapi.com/api/character/1",
                  "created": "2017-11-04T18:48:46.250Z"
                }
              ]
            }
            """.data(using: .utf8)!

        MockURLProtocol.mockResponseData = mockJSON

        //When
        let characters = try await service.fetchAllCharacters(page: 1)

        //Then
        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters.first?.name, "Rick Sanchez")
    }
    
    func testFetchAllCharacters_throwsDecodeError() async throws {
        // Given - intentionally invalid JSON (count should be Int)
        let mockJSON = """
            {
              "info": {
                "count": "errorDecoding",
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character/?page=1",
                "prev": null
              },
              "results": []
            }
        """.data(using: .utf8)!

        MockURLProtocol.mockResponseData = mockJSON

        // When
        do {
            _ = try await service.fetchAllCharacters(page: 1)
            XCTFail("Expected Error")
        } catch let error as CharacterServiceError {
            // Then
            XCTAssertEqual(error, .decodingError, "Expected decodingError")
        } catch {
            XCTFail("Expected CharacterServiceError")
        }
    }
    
    func testFetchAllCharacters_throwsNetworkError() async throws {
        // Given
        MockURLProtocol.mockError = URLError(.badServerResponse)

        // When
        do {
            _ = try await service.fetchAllCharacters(page: 1)
            XCTFail("Expected Error")
        } catch let error as CharacterServiceError {
            // Then
            XCTAssertEqual(error, .networkError(URLError(.badServerResponse)), "Expected networkError")
        } catch {
            XCTFail("Expected CharacterServiceError")
        }
    }
    
    func testUrlGeneration_Success() throws {
        //When
        let url = try service.url(for: 1)
        
        //Then
        XCTAssertEqual(url.absoluteString, "https://rickandmortyapi.com/api/character?page=1")
    }
    
    func testUrlGeneration_throwsInvalidURL() {
        //Given
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        let service = RnMCharacterServiceImpl(session: session, baseURL: "failUrl")
        
        //When
        do {
            _ =  try service.url(for: 1)
            XCTFail("Expected Error")
        } catch let error as CharacterServiceError {
            // Then
            XCTAssertEqual(error, .invalidURL, "Expected invalidURL")
        } catch {
            XCTFail("Expected CharacterServiceError")
        }
    }
}
