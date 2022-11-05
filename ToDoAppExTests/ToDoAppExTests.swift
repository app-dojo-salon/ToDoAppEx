//
//  ToDoAppExTests.swift
//  ToDoAppExTests
//
//  Created by izumiyoshiki on 2021/03/07.
//

import XCTest
@testable import ToDoAppEx

class ToDoAppExTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testSignUpModel() {
        let model = SignUpModel()

        let exp: XCTestExpectation = expectation(description: "戻ってくるまで待つ！")

        model.createAccount(email: "hoge@mail", password: "hoge", displayName: "Hoge") { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "新しいリスト追加に成功")
            case .failure(let error as SignUpModelError):
                XCTAssertTrue(false, "エラー：\(error)")
            case .failure(_):
                fatalError("Unexpected pattern.")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
