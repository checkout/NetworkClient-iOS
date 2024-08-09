//
//  RequestConfigurationTests.swift
//
//
//  Created by Alex Ioja-Yang on 20/06/2022.
//

import XCTest
@testable import CheckoutNetwork

final class RequestConfigurationTests: XCTestCase {
    
    func testInitialiserDefaults() {
        let testPath = FakePath.testServices
        let config = try! RequestConfiguration(path: testPath)
        let request = config.request
        
        XCTAssertEqual(request.url, testPath.url)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertNil(request.httpBody)
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
    }
    
    func testNoDataDoesntApplyMime() {
        let testPath = FakePath.testServices
        let testMime = MIMEType.JSON
        let config = try! RequestConfiguration(path: testPath,
                                               bodyData: nil,
                                               mimeType: testMime)
        let request = config.request
        
        XCTAssertEqual(request.url, testPath.url)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertNil(request.httpBody)
        XCTAssertEqual(request.allHTTPHeaderFields, [:])
    }
    
    func testDataExistsAppliesMime() {
        let testPath = FakePath.testServices
        let testMime = MIMEType.JSON
        let testData = "data".data(using: .utf8)
        let config = try! RequestConfiguration(path: testPath,
                                               bodyData: testData,
                                               mimeType: testMime)
        let request = config.request
        
        XCTAssertEqual(request.url, testPath.url)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.httpBody, testData)
        XCTAssertEqual(request.allHTTPHeaderFields, [MIMEType.key: testMime.rawValue])
    }
    
    func testInitialiser() {
        let testPath = FakePath.testServices
        let testHTTPMethod = HTTPMethod.post
        // Should only have 1 query item as the order is not guaranteed and test can become flaky
        let testQueryItems = ["key": "special value"]
        let testCustomHeaders = ["header": "value"]
        let testData = "testThis-data".data(using: .utf8)
        let testMimeType = MIMEType.JSON
        let config = try! RequestConfiguration(path: testPath,
                                               httpMethod: testHTTPMethod,
                                               queryItems: testQueryItems,
                                               customHeaders: testCustomHeaders,
                                               bodyData: testData,
                                               mimeType: testMimeType)
        let request = config.request
        
        let expectedURL = URL(string: "https://google-not.now?key=special%20value")
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.httpBody, testData)
        
        let expectedHeaders = [MIMEType.key: testMimeType.rawValue]
            .merging(testCustomHeaders, uniquingKeysWith: { (key1, key2) in return key1 })
        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaders)
    }
}
