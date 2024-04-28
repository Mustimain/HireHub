//
//  UserService.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class UserService : AuthProtocol {
    
    let db = Firestore.firestore()
    
    func UserRegister(user: User) async throws -> Bool {
        
        if (user.userID?.count ?? 0 > 0){
            do {
                try db.collection("Users").document("deneme").setData(from: user)
                return true;
            } catch let error {
              print("Error writing city to Firestore: \(error)")
                return false;

            }
        }

        return false;
    }
    
    func UserLogin(email: String, password: String) async throws -> Bool {
        
        _ = email;
        _ = password;
        return true;
        
    }
    
  
    
}
