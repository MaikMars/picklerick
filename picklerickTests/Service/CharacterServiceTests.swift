//
//  CharacterServiceTests.swift
//  
//
//  Created by Miki on 15/7/25.
//

import Testing
import XCTest
@testable import picklerick


final class CharacterServiceTests: XCTestCase {

    var service: CharacterServiceImpl!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        service = CharacterServiceImpl(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }

    func testFetchCharacters_Success() async throws {
        // Given
        let mockJSON = CharacterServiceMocks.mockJSONPage1
        MockURLProtocol.mockResponseData = mockJSON

        //When
        let characters = try await service.fetchCharacters(page: 1)

        //Then
        XCTAssertEqual(characters.count, 1)
        XCTAssertEqual(characters.first?.name, "Rick Sanchez")
    }
    
    func testFetchCharacters_throwsDecodeError() async throws {
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
            _ = try await service.fetchCharacters(page: 1)
            XCTFail("Expected Error")
        } catch let error as RMServiceError {
            // Then
            XCTAssertEqual(error, .decodingError, "Expected decodingError")
        } catch {
            XCTFail("Expected ServiceError")
        }
    }
    
    func testFetchCharacters_throwsNetworkError() async throws {
        // Given
        MockURLProtocol.mockError = URLError(.badServerResponse)

        // When
        do {
            _ = try await service.fetchCharacters(page: 1)
            XCTFail("Expected Error")
        } catch let error as RMServiceError {
            // Then
            XCTAssertEqual(error, .networkError(URLError(.badServerResponse)), "Expected networkError")
        } catch {
            XCTFail("Expected ServiceError")
        }
    }
    
    func testFetchCharacters_usesCacheAfterFirstCall() async throws {
        // Given
        MockURLProtocol.mockResponseData = CharacterServiceMocks.mockJSONPage1
        
        // When
        let firstCall = try await service.fetchCharacters(page: 1)
        MockURLProtocol.mockResponseData = nil
        let secondCall = try await service.fetchCharacters(page: 1)
        
        // Then
        XCTAssertEqual(firstCall.count, secondCall.count)
    }
    
    func testFetchCharacters_differentPage_noCacheHit() async throws {
        let mockJSONPage1  = CharacterServiceMocks.mockJSONPage1
        MockURLProtocol.mockResponseData = mockJSONPage1
        _ = try await service.fetchCharacters(page: 1)
    
        MockURLProtocol.mockResponseData = CharacterServiceMocks.mockJSONPage2
        let resultPage2 = try await service.fetchCharacters(page: 2)
        
        XCTAssertFalse(resultPage2.isEmpty, "Expected to fetch new data for a different page")
    }
    
    func testUrlGeneration_withoutQueryAndFilters_Success() throws {
        //When
        let url = try service.url(for: 1, query: nil, filters: [:])
        
        //Then
        XCTAssertEqual(url.absoluteString, "https://rickandmortyapi.com/api/character?page=1")
    }
    
    func testUrlGeneration_withQueryAndFilters_Success() throws {
        let url = try service.url(for: 1, query: "rick", filters: ["status": "alive", "species": "human"])
        XCTAssertEqual(url.absoluteString, "https://rickandmortyapi.com/api/character?page=1&name=rick&species=human&status=alive")
    }
    
}
