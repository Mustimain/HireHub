//
//  User.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 28.04.2024.
//

import Foundation

class User{
    
    var  userID : String?
    var  firstName : String?
    var  lastName : String?
    var  job : String?
    var  experienceYear : String?
    var  email : String?
    var  password : String?
    var  phoneNumber : String?
    var  cvPath : String?
    var  emailVerification : Bool?
    var  createDate : Date?
    
    
    init(userID: String? = nil, firstName: String? = nil, lastName: String? = nil, job: String? = nil, experienceYear: String? = nil, email: String? = nil, password: String? = nil, phoneNumber: String? = nil, cvPath: String? = nil, emailVerification: Bool? = nil, createDate: Date? = nil) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.job = job
        self.experienceYear = experienceYear
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.cvPath = cvPath
        self.emailVerification = emailVerification
        self.createDate = createDate
    }
    
   

}
