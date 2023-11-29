//
//  SessionManagerProtocol.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import Networking

protocol SessionManagerProtocol {
    func setUserToken(_ token: String)
    func removeUserToken()
}

extension SessionManager: SessionManagerProtocol {}
