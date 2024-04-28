//
//  UserService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import Foundation

class UserService : AuthProtocol {
    func UserRegister(user: User) async throws -> Bool {
        return true;
    }
    
    func UserLogin(email: String, password: String) async throws -> Bool {
        
        var useremail = email;
        var userpassword = password;
        return true;
        
    }
    
  
    
}
