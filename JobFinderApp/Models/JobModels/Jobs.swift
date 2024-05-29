import Foundation
import FirebaseFirestore

struct Job : Codable{
    
    @DocumentID var  jobID : String? = UUID().uuidString
    var  name : String?
    var  sectorID : String?
 
}
