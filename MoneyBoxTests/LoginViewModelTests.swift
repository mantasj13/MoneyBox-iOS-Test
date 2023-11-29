//
//  LoginViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Mantas Jakstas on 28/11/23.
//

import XCTest
import Networking
@testable import MoneyBox

final class LoginViewModelTests: XCTestCase {

    private var sut: LoginViewModel!
    private var provider: DataProviderProtocol!

    override func setUpWithError() throws {
        provider = DataProviderMock()
        sut = LoginViewModel(provider: provider)
    }

    override func tearDownWithError() throws {
        provider = nil
        sut = nil
    }

    func test_LoginSuccessfully() {
        let validEmail = "test@example.com"
        let validPassword = "SecurePassword123"

        let expectation = self.expectation(description: "Login expectation")
        sut.login(email: validEmail, password: validPassword) { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertEqual(user.firstName, "Michael")
                XCTAssertEqual(user.lastName, "Jordan")
            case .failure:
                XCTFail("Expected a successful login, but got a failure.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func test_LoginFailureWithInvalidEmail() {

        let invalidEmail = "invalidemail"
        let validPassword = "SecurePassword123"

        let expectation = self.expectation(description: "Login expectation")

        sut.login(email: invalidEmail, password: validPassword) { result in
            switch result {
            case .success:
                XCTFail("Expected a failure for invalid email, but got success.")
            case .failure(let error):
                if case .invalidEmail = error { } else {
                    XCTFail("Expected an invalidEmail error, but got a different error.")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func test_ValidEmailProvided() {
        let validEmail = sut.validateEmail(email: "example@gmail.com")
        XCTAssertTrue(validEmail)
    }

    func test_InvalidEmailProvided() {
        let invalidEmail = sut.validateEmail(email: "email")
        XCTAssertFalse(invalidEmail)
    }

    func test_ValidPasswordProvided() {
        let validPasswordResult = sut.validatePassword(password: "SecurePassword123")
        switch validPasswordResult {
        case .success:
            XCTAssert(true, "Expected a valid password")
        case .failure(let error):
            XCTFail("Expected a valid password, but got an error: \(error)")
        }
    }

    func test_TooShortPassword() {
        let tooShortPasswordResult = sut.validatePassword(password: "ShortPwd1")
        switch tooShortPasswordResult {
        case .success:
            XCTFail("Expected a tooShortPassword error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .tooShortPassword, "Expected a tooShortPassword error, but got a different error.")
        }
    }

    func test_NumbersRequired() {
        let noNumbersPasswordResult = sut.validatePassword(password: "NoNumbersPwd")
        switch noNumbersPasswordResult {
        case .success:
            XCTFail("Expected a numbersRequired error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .numbersRequired, "Expected a numbersRequired error, but got a different error.")
        }
    }

    func test_LowerCaseRequired() {
        let noLowerCasePasswordResult = sut.validatePassword(password: "NOLOWERCASE123")
        switch noLowerCasePasswordResult {
        case .success:
            XCTFail("Expected a lowerCaseRequired error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .lowerCaseRequired, "Expected a lowerCaseRequired error, but got a different error.")
        }
    }

    func test_UpperCaseRequired() {
        let noUpperCasePasswordResult = sut.validatePassword(password: "nouppercase123")
        switch noUpperCasePasswordResult {
        case .success:
            XCTFail("Expected an upperCaseRequired error, but got success.")
        case .failure(let error):
            XCTAssertEqual(error, .upperCaseRequired, "Expected an upperCaseRequired error, but got a different error.")
        }
    }

    func test_FailureWhenMandatorySessionFieldIsMissing() {
        let jsonString =
        """
        {
            "User": {
                "Email": "test+ios@moneyboxapp.com",
                "FirstName": "Michael",
                "LastName": "Jordan"
            }
        }

        """
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Cannot convert json to data")
            return
        }

        XCTAssertThrowsError(try JSONDecoder().decode(LoginResponse.self, from: data)) { error in
            let decodingError = error as? DecodingError
            XCTAssertNotNil(decodingError)
            if case .keyNotFound = decodingError {} else {
                XCTFail("Unknown error")
            }
        }
    }
}
