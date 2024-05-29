import Foundation
import FirebaseFirestore


struct Sector : Codable{
    
    @DocumentID var  sectorID : String? = UUID().uuidString
    var  name : String?
 
}
