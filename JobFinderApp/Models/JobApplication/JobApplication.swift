import Foundation
import FirebaseFirestore

struct JobApplication : Codable {
    @DocumentID var  jobApplicationID : String? = UUID().uuidString
    var userID : String?
    var advertiseID : String?
    var applicationDate : Date?
    var applicationStatus : ApplicationStatusEnum?

}
