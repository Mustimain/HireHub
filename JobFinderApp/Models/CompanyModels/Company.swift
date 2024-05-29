import Foundation
import FirebaseFirestore


struct Company : Codable{
    
    @DocumentID var  companyID : String? = UUID().uuidString
    var name : String?
    var sectorID : String?
    var employeeSize : EmployeeSizeEnum? // Enum Yapılacak
    var avarageSalary : AverageSalaryEnum? // Enum yapılacak
    var address : String?
    var locationLong : Double?
    var locationLat : Double?
    var description : String?
    var email : String?
    var password : String?
    var phoneNumber : String?
    var registerDate : Date?  
    var updateDate : Date?


}
