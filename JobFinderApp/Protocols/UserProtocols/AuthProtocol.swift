//
//  AuthProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import Foundation

protocol AuthProtocol {
    
    func UserRegister(user: User) async throws -> Bool
    func UserLogin(email: String, password : String) async throws -> [User] 

}
