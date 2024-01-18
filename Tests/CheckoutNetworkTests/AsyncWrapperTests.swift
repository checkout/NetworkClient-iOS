//
//  AsyncWrapperTests.swift
//
//
//  Created by Okhan Okbay on 18/01/2024.
//

@testable import CheckoutNetwork
import XCTest

final class AsyncWrapperTests: XCTestCase {

  func test_whenRunRequestReturnsData_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    let expectedResult = FakeObject(id: "some response")
    client.expectedResult = expectedResult
    client.expectedError = nil
    let result: FakeObject = try await client.runRequest(with: testConfig)
    XCTAssertEqual(client.configuration.request, testConfig.request)
    XCTAssertEqual(client.runRequestCallCount, 1)
    XCTAssertEqual(result, expectedResult)
  }

  func test_whenRunRequestReturnsError_ThenAsyncRunRequestPropagatesIt() async throws {
    let fakeSession = FakeSession()
    let fakeDataTask = FakeDataTask()
    fakeSession.calledDataTasksReturn = fakeDataTask
    let client = CheckoutNetworkClientSpy(session: fakeSession)
    let testConfig = try! RequestConfiguration(path: FakePath.testServices)

    let expectedError = FakeError.someError
    client.expectedResult = nil
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
