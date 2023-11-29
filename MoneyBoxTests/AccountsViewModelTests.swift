//
//  AccountsViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Mantas Jakstas on 28/11/23.
//

import XCTest
import Networking
@testable import MoneyBox

final class AccountViewModelTests: XCTestCase {

    private var sut: AccountsViewModel!

    override func setUpWithError() throws {
        let provider = DataProviderMock()
        sut = AccountsViewModel(provider: provider, user: User(firstName: "Steve", lastName: "Jobs"))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_FetchProducts_Success() {
        let expectation = self.expectation(description: "Fetch Products expectation")
        sut.fetchProducts { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.productResponses?.count,2)
                XCTAssertEqual(response.productResponses?.count, 2)
                XCTAssertEqual(response.productResponses?[0].product?.name, "ISA")
                XCTAssertEqual(response.productResponses?[0].moneybox, 570.0)
                XCTAssertEqual(response.productResponses?[1].product?.name, "Lisa Plus")
                XCTAssertEqual(response.productResponses?[1].moneybox, 470.0)
            case .failure:
                XCTFail("Expected a successful fetchProducts, but got a failure.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func test_FetchProducts_Failure() {
        let expectation = self.expectation(description: "Fetch Products expectation")
        sut.fetchProducts { result in
            switch result {
            case .success(let response):
                XCTAssertNotEqual(response.productResponses?.count,5)
                XCTAssertNotEqual(response.productResponses?[1].product?.name, "ISA")
                XCTAssertNotEqual(response.productResponses?[1].moneybox, 570.0)
                XCTAssertNotEqual(response.productResponses?[1].product?.name, "Lisa")
                XCTAssertNotEqual(response.productResponses?[1].moneybox, 4730.0)
            case .failure:
                XCTFail("Expected a unsuccessful fetchProducts, but got a success.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
