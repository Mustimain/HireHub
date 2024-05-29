import Foundation

enum ApplicationStatusEnum: String, Codable, CaseIterable {
    case applicationReceived = "Başvuru Alındı"
    case applicationViewed = "Başvuru Görüntülendi"
    case cvDownloaded = "Özgeçmiş İndirildi"
    
    var description: String {
        switch self {
        case .applicationReceived:
            return "Başvurunuz alındı."
        case .applicationViewed:
            return "Başvurunuz görüntülendi."
        case .cvDownloaded:
            return "Özgeçmişiniz indirildi."
        }
    }
}
