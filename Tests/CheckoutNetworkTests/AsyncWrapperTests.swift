//
//  AsyncWrapperTests.swift
//
//
//  Created by Okhan Okbay on 18/01/2024.
//

@testable import CheckoutNetwork
import XCTest

final class AsyncWrapperTests: XCTestCase {}

// MARK: Run Request whilst expecting a data response
extension AsyncWrapperTests {
  func test_whenRunRequestReturnsData_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    let expectedResponseBody = FakeObject(id: "some response")
    client.expectedResponseBody = expectedResponseBody
    client.expectedError = nil
    let responseBody: FakeObject = try await client.runRequest(with: testConfig)
    XCTAssertEqual(client.configuration.request, testConfig.request)
    XCTAssertEqual(client.runRequestCallCount, 1)
    XCTAssertEqual(responseBody, expectedResponseBody)
  }

  func test_whenRunRequestReturnsError_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    let expectedError = FakeError.someError
    client.expectedResponseBody = nil
    client.expectedError = expectedError

    do {
      let _: FakeObject = try await client.runRequest(with: testConfig)
      XCTFail("An error was expected to be thrown")
    } catch let error as FakeError {
      XCTAssertEqual(client.configuration.request, testConfig.request)
      XCTAssertEqual(client.runRequestCallCount, 1)
      XCTAssertEqual(error, expectedError)
    }
  }
}

// MARK: Run Request whilst expecting no data response (HTTP 204)

extension AsyncWrapperTests {
  func test_whenRunRequestWithNoDataReturnsNoError_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    client.expectedResponseBody = nil
    client.expectedError = nil
    do {
      try await client.runRequest(with: testConfig)
      XCTAssertEqual(client.configuration.request, testConfig.request)
      XCTAssertEqual(client.runRequestCallCount, 1)
    } catch {
      XCTFail("Should have not thrown an error \(error)")
    }
  }

  func test_whenRunRequestWithNoDataReturnsError_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    let expectedError = FakeError.someError
    client.expectedResponseBody = nil
    client.expectedError = expectedError

    do {
      try await client.runRequest(with: testConfig)
      XCTFail("An error was expected to be thrown")
    } catch let error as FakeError {
      XCTAssertEqual(client.configuration.request, testConfig.request)
      XCTAssertEqual(client.runRequestCallCount, 1)
      XCTAssertEqual(error, expectedError)
    }
  }
}
