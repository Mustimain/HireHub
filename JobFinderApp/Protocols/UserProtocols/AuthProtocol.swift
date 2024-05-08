//
//  AuthProtocol.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import Foundation

protocol AuthProtocol {
    
    func UserRegister(user: User) async throws -> Bool
    func UserLogin(email: String, password : String) async throws -> Bool
    func CompanyRegister(company: Company) async throws -> Bool
    func CompanyLogin(email: String, password : String) async throws -> Bool
    func GetUserByEmail(email: String) async throws -> User
    func GetCompanyByEmail(email: String) async throws -> Company


}
