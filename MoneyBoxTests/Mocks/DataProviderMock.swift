//
//  DataProviderMock.swift
//  MoneyBoxTests
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import Networking

final class DataProviderMock: DataProviderProtocol {

    func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void)) {
        let url = Bundle.main.url(forResource: "LoginSucceed", withExtension: "json")
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url!)
            let model = try! decoder.decode(LoginResponse.self, from: jsonData)
            completion(.success(model))
        } catch let error {
            print(completion(.failure(error)))
        }
    }

    public func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
        let url = Bundle.main.url(forResource: "Accounts", withExtension: "json")
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url!)
            let accountResponse = try! decoder.decode(AccountResponse.self, from: jsonData)
            completion(.success(accountResponse))
        } catch let error {
            print(completion(.failure(error)))
        }
    }

    public func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void)) {
        let url = Bundle.main.url(forResource: "PaymentSuccess", withExtension: "json")
        do {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url!)
            let accountDetailResponse = try! decoder.decode(OneOffPaymentResponse.self, from: jsonData)
            completion(.success(accountDetailResponse))
        } catch let error {
            print(completion(.failure(error)))
        }
    }
}
