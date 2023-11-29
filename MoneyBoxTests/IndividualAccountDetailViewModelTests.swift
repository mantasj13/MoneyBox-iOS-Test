//
//  IndividualAccountDetailViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Mantas Jakstas on 28/11/23.
//

import XCTest
import Networking
@testable import MoneyBox

import XCTest

final class IndividualAccountDetailViewModelTests: XCTestCase {

    private var sut: IndividualAccountDetailViewModel!

    override func setUpWithError() throws {
        let mockProvider = DataProviderMock()
        sut = IndividualAccountDetailViewModel(provider: mockProvider, productResponse: ProductResponse.mockResponse)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_AddedMoneySuccessfully() {
        let valueBoxValue = 2000.0
        let expectation = self.expectation(description: "Response moneybox expectation")
        sut.addTenPounds(productId: 10) { result  in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.moneybox, valueBoxValue)
            case .failure(_):
                fatalError()
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func test_AddedMoneyNotSuccessfully() {
        let valueBoxValue = 100.0
        let expectation = self.expectation(description: "Response moneybox expectation")
        sut.addTenPounds(productId: 10) { result  in
            switch result {
            case .success(let response):
                XCTAssertNotEqual(response.moneybox, valueBoxValue)
            case .failure(_):
                fatalError()
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}

extension ProductResponse {
    static var mockResponse: Self {
        let url = Bundle.main.url(forResource: "ProductResponse", withExtension: "json")
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url!)
            let model = try! decoder.decode(ProductResponse.self, from: jsonData)
            return model
        } catch {
            fatalError()
        }
    }
}
