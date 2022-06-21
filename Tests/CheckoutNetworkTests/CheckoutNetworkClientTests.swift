//
//  CheckoutNetworkClientTests.swift
//  
//
//  Created by Alex Ioja-Yang on 21/06/2022.
//

import XCTest
@testable import CheckoutNetwork

final class CheckoutNetworkClientTests: XCTestCase {
    
    func testNoTasksWhenCreated() {
        let client = CheckoutNetworkClient(session: FakeSession())
        XCTAssertTrue(client.tasks.isEmpty)
    }
    
    func testPublicInitialiser() {
        let client = CheckoutNetworkClient()
        XCTAssertTrue(client.tasks.isEmpty)
        XCTAssertTrue(client.session === URLSession.shared)
    }
    
    func testTasksStartedAndStored() {
        let fakeSession = FakeSession()
        let fakeDataTask = FakeDataTask()
        fakeSession.calledDataTasksReturn = fakeDataTask
        let client = CheckoutNetworkClient(session: fakeSession)
        
        XCTAssertFalse(fakeDataTask.wasStarted)
        XCTAssertTrue(client.tasks.isEmpty)
        
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in }
        
        XCTAssertEqual(client.tasks.count, 1)
        XCTAssertTrue(client.tasks.values.first === fakeDataTask)
        XCTAssertTrue(fakeDataTask.wasStarted)
        XCTAssertEqual(fakeSession.calledDataTasks.count, 1)
        XCTAssertEqual(fakeSession.calledDataTasks.first?.request, testConfig.request)
    }
    
    func testCreatingTasksDoesNotRemovePreviousOnes() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        let numberOfTasksToCreate = 1000
        
        (0..<numberOfTasksToCreate).forEach { _ in
            client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in }
        }
        XCTAssertEqual(client.tasks.count, numberOfTasksToCreate)
        XCTAssertEqual(fakeSession.calledDataTasks.count, numberOfTasksToCreate)
    }
    
    func testDataTaskCompletedWithError() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let expectedData = "nothing".data(using: .utf8)
        let expectedResponse = URLResponse()
        let expectedError = NSError(domain: "fail", code: 12345)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                XCTAssertEqual(failure as NSError, expectedError)
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(expectedData, expectedResponse, expectedError)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithBadResponseCode() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        let testResponseCode = 300
        
        let expectedData = "nothing".data(using: .utf8)
        let expectedResponse = HTTPURLResponse(url: FakePath.testServices.url(),
                                               statusCode: 300,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                XCTAssertEqual(failure as? CheckoutNetworkError, CheckoutNetworkError.unexpectedResponseCode(code: testResponseCode))
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(expectedData, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithBadResponseStyle() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let expectedData = "nothing".data(using: .utf8)
        let expectedResponse = URLResponse()
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                XCTAssertEqual(failure as? CheckoutNetworkError, CheckoutNetworkError.unexpectedResponseCode(code: 0))
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(expectedData, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithNoData() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let expectedResponse = HTTPURLResponse(url: FakePath.testServices.url(),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                XCTAssertEqual(failure as? CheckoutNetworkError, CheckoutNetworkError.noDataResponseReceived)
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(nil, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithEmptyData() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let expectedData = Data()
        let expectedResponse = HTTPURLResponse(url: FakePath.testServices.url(),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                XCTAssertEqual(failure.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(expectedData, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithInvalidResponseFormat() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let fakeObject = FakeObject(id: "4")
        var fakeObjectEncoded = try! JSONEncoder().encode(fakeObject)
        // Prepare for malforming the data decoding
        let fakeObjectString = String(data: fakeObjectEncoded, encoding: .utf8)!
        // Make id key invalid for decoding
        fakeObjectEncoded = fakeObjectString.replacingOccurrences(of: "d", with: "").data(using: .utf8)!
        let expectedResponse = HTTPURLResponse(url: FakePath.testServices.url(),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(_):
                XCTFail("Test expects a specific error to be returned")
            case .failure(let failure):
                let decodingError = failure as? DecodingError
                XCTAssertNotNil(decodingError)
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(fakeObjectEncoded, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
    
    func testDataTaskCompletedWithSuccess() {
        let fakeSession = FakeSession()
        let client = CheckoutNetworkClient(session: fakeSession)
        let testConfig = try! RequestConfiguration(path: FakePath.testServices)
        
        let fakeObject = FakeObject(id: UUID().uuidString)
        let fakeObjectEncoded = try! JSONEncoder().encode(fakeObject)
        let expectedResponse = HTTPURLResponse(url: FakePath.testServices.url(),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        
        let expect = expectation(description: "Ensure completion handler is called")
        client.runRequest(with: testConfig) { (result: Result<FakeObject, Error>) in
            expect.fulfill()
            switch result {
            case .success(let receivedObject):
                XCTAssertEqual(receivedObject, fakeObject)
            case .failure(let failure):
                XCTFail("Test expects a success, so error \(failure) is unexpected")
            }
        }
        
        XCTAssertFalse(client.tasks.isEmpty)
        let requestCompletion = fakeSession.calledDataTasks.first!.completion
        requestCompletion(fakeObjectEncoded, expectedResponse, nil)
        XCTAssertTrue(client.tasks.isEmpty)
        waitForExpectations(timeout: 1)
    }
}
