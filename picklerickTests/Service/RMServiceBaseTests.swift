//
//  RMServiceBaseTests.swift
//  picklerickTests
//
//  Created by Miki on 19/7/25.
//

import Foundation

import XCTest
@testable import picklerick

final class RMBaseServiceTests: XCTestCase {
    
    private var service: RMBaseService!
    private var session: URLSession!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        service = RMBaseService(session: session, baseURL: "https://rickandmortyapi.com/api/character")
    }
    
    override func tearDown() {
        service = nil
        session = nil
        super.tearDown()
    }
    
    func testFetchData_returnsCachedData_whenCacheHit() async throws {
        let url = URL(string: "https://test.com")!
        let cacheKey = "cached_key"
        let cachedData = "cached".data(using: .utf8)!
        service.dataCache[cacheKey] = cachedData
        
        let data = try await service.fetchData(from: url, cacheKey: cacheKey)
        
        XCTAssertEqual(data, cachedData, "Should return cached data without network call")
    }
    
    func testFetchData_fetchesFromNetwork_whenCacheMiss() async throws {
        let expectedData = "network response".data(using: .utf8)!
        MockURLProtocol.mockResponseData = expectedData
        
        let url = URL(string: "https://test.com")!
        let data = try await service.fetchData(from: url, cacheKey: "new_key")
        
        XCTAssertEqual(data, expectedData, "Should return network response when cache misses")
        XCTAssertEqual(service.dataCache["new_key"], expectedData, "Should store in cache after network fetch")
    }
    
    func testFetchData_throwsNetworkError_whenRequestFails() async {
        MockURLProtocol.mockError = URLError(.badServerResponse)
        let url = URL(string: "https://test.com")!
        
        do {
            _ = try await service.fetchData(from: url, cacheKey: "fail_key")
            XCTFail("Should throw error")
        } catch let error as RMServiceError {
            XCTAssertEqual(error, .networkError(URLError(.badServerResponse)))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
