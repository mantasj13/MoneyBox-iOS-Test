//
//  IndividualAccountDetailViewModel.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import Networking

protocol IndividualAccountDetailViewModelProtocol {
    var productResponse: ProductResponse { get }
    func addTenPounds(productId: Int, completion: @escaping (Result<OneOffPaymentResponse, Error>) -> Void)
}

final class IndividualAccountDetailViewModel: IndividualAccountDetailViewModelProtocol {

    private let provider: DataProviderProtocol
    let productResponse: ProductResponse

    init(provider: DataProviderProtocol = DataProvider(), productResponse: ProductResponse) {
        self.provider = provider
        self.productResponse = productResponse
    }

    func addTenPounds(productId: Int, completion: @escaping (Result<OneOffPaymentResponse, Error>) -> Void) {
        let request = OneOffPaymentRequest(amount: 10, investorProductID: productId)
        provider.addMoney(request: request) { response in

            switch response {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
