import Foundation
import FirebaseFirestore


struct Advertise : Codable{
    
    @DocumentID var  advertiseID : String? = UUID().uuidString
    var  companyID : String?
    var  jobId : String?
    var  description : String?
    var  createDate : Date?
    var  title : String?
    var updateDate : Date?
    var  isActive : Bool? = true

}
