import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {

    func test_LoginRequestSuccess() {
        let loginRequest = LoginRequest(email: "email", password: "password")
        let login = API.Login.login(request: loginRequest)

        let request = login.request
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.path, "/users/login")
    }

    func test_LoginRequestFailed() {
        let loginRequest = LoginRequest(email: "email", password: "password")
        let login = API.Login.login(request: loginRequest)

        let request = login.request
        XCTAssertNotEqual(request.httpMethod, "Get")
        XCTAssertNotEqual(request.url?.path, "/users/logiin")
    }

    func test_BaseUrlCorrectlyCreated() {
        let sut = API.getURL(with: "")
        XCTAssertNotNil(sut, "URL should not be nil")
        XCTAssertEqual(sut.absoluteString, "https://api-test02.moneyboxapp.com", "Generated URL is incorrect")
    }

    func test_ProductsRequestTestSuccessfully() {
        let account = API.Account.products
        let request = account.request

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.path, "/investorproducts")
    }
    func test_ProductsRequestNotTestSuccessfully() {
        let account = API.Account.products
        let request = account.request

        XCTAssertNotEqual(request.httpMethod, "POST")
        XCTAssertNotEqual(request.url?.path, "/investorprodu")
    }

    func test_AddMoneyRequestSuccess() {
        let oneOffPaymentRequest = OneOffPaymentRequest(amount: 10, investorProductID: 123)
        let account = API.Account.addMoney(request: oneOffPaymentRequest)
        let request = account.request

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.path, "/oneoffpayments")
    }

    func test_AddMoneyRequestFailed() {
        let oneOffPaymentRequest = OneOffPaymentRequest(amount: 10, investorProductID: 123)
        let account = API.Account.addMoney(request: oneOffPaymentRequest)
        let request = account.request

        XCTAssertNotEqual(request.httpMethod, "GET")
        XCTAssertNotEqual(request.url?.path, "/oneoffpaymen")
    }
}

