//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import Networking

protocol AccountsViewModelProtocol {
    var user: User { get }
    func fetchProducts(_ completion: @escaping (Result<AccountResponse, Error>) -> Void)
}

final class AccountsViewModel: AccountsViewModelProtocol {

    private let provider: DataProviderProtocol
    let user: User

    init(provider: DataProviderProtocol = DataProvider(), user: User) {
        self.provider = provider
        self.user = user
    }

    func fetchProducts(_ completion: @escaping (Result<AccountResponse, Error>) -> Void) {
        provider.fetchProducts { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
