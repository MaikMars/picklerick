//
//  EpisodeServiceTests.swift
//  picklerickTests
//
//  Created by Miki on 20/7/25.
//

import Foundation
import Testing
import XCTest
@testable import picklerick


final class EpisodeServiceTests: XCTestCase {

    var service: EpisodeServiceImpl!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        service = EpisodeServiceImpl(session: session)
    }
    
    override func tearDown() {
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }

    func testFetchEpisodes_Success() async throws {
        // Given
        let mockJSON = EpisodeServiceMocks.episodesJSONString
        MockURLProtocol.mockResponseData = mockJSON

        //When
        let episodes = try await service.fetchEpisodes(episodes: [1,2])

        //Then
        XCTAssertEqual(episodes.count, 2)
        XCTAssertEqual(episodes.first?.id, 1)
        XCTAssertEqual(episodes.last?.id, 2)
    }
    
    func testFetchEpisodes_throwsDecodeError() async throws {
        // Given
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
            _ = try await service.fetchEpisodes(episodes: [1,2])
            XCTFail("Expected Error")
        } catch let error as RMServiceError {
            // Then
            XCTAssertEqual(error, .decodingError, "Expected decodingError")
        } catch {
            XCTFail("Expected ServiceError")
        }
    }
    
    func testFetchEpisodes_throwsNetworkError() async throws {
        // Given
        MockURLProtocol.mockError = URLError(.badServerResponse)

        // When
        do {
            _ = try await service.fetchEpisodes(episodes: [1,2])
            XCTFail("Expected Error")
        } catch let error as RMServiceError {
            // Then
            XCTAssertEqual(error, .networkError(URLError(.badServerResponse)), "Expected networkError")
        } catch {
            XCTFail("Expected ServiceError")
        }
    }
    
    func testFetchEpisodes_usesCacheAfterFirstCall() async throws {
        // Given
        MockURLProtocol.mockResponseData = EpisodeServiceMocks.episodesJSONString
        
        // When
        let firstCall = try await service.fetchEpisodes(episodes: [1,2])
        MockURLProtocol.mockResponseData = nil
        let secondCall = try await service.fetchEpisodes(episodes: [1,2])
        
        // Then
        XCTAssertEqual(firstCall.count, secondCall.count)
    }
    
    func testFetchEpisodes_differentPage_noCacheHit() async throws {
        let mockJSONPage1  = EpisodeServiceMocks.episodesJSONString
        MockURLProtocol.mockResponseData = mockJSONPage1
        _ = try await service.fetchEpisodes(episodes: [1,2])
    
        MockURLProtocol.mockResponseData = EpisodeServiceMocks.episodesJSONString2
        let resultPage2 = try await service.fetchEpisodes(episodes: [5])
        
        XCTAssertFalse(resultPage2.isEmpty, "Expected to fetch new data for a different page")
    }
    
    
    func testUrlGeneration_Success() throws {
        let url = try service.url(for: [1])
        XCTAssertEqual(url.absoluteString, "https://rickandmortyapi.com/api/episode/1")
    }
    
}
