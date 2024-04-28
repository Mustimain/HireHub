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
    var users: [User] = []

    
    func UserRegister(user: User) async throws -> Bool {
        
        if (user.userID?.count ?? 0 > 0){
            do {
                try db.collection("Users").document(user.userID ?? "").setData(from: user)
                return true;
            } catch let error {
              print("Error writing city to Firestore: \(error)")
                return false;

            }
        }

        return false;
    }
    
    func UserLogin(email: String, password: String) async throws -> [User] {
        
        let query = db.collection("Users")
        
          let querySnapshot = try await query.getDocuments()

          // 2. Parse documents and handle errors
          var users: [User] = []
          for document in querySnapshot.documents {
            do {
              let user = try document.data(as: User.self)
              users.append(user)
            } catch {
              throw error // Re-throw the error for proper handling
            }
          }

          // 3. Return the fetched users
          return users
    }
    
}
