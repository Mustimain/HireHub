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
    func UpdateUser(user: User) async throws -> Bool
    func GetUserByEmail(email: String) async throws -> User
    func GetUserDetailByEmail(email: String) async throws -> UserDetail

    
    
    func CompanyRegister(company: Company) async throws -> Bool
    func CompanyLogin(email: String, password : String) async throws -> Bool
    
    func UpdateCompany(company: Company) async throws -> Bool
    
    func GetCompanyByEmail(email: String) async throws -> Company
    func GetAllCompanies() async throws -> [Company]
    
    func GetCompanyDetailByEmail(email: String) async throws -> CompanyDetail
    func GetAllCompanyDetails() async throws -> [CompanyDetail]



}
