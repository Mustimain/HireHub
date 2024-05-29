//
//  AvarageSalaryEnum.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 29.05.2024.
//

import Foundation

enum AverageSalaryEnum: String, Codable,CaseIterable {
    case veryLow = "Very Low"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryHigh = "Very High"
    
    var description: String {
        switch self {
        case .veryLow:
            return "0 - 17.000 TL"
        case .low:
            return "17.000 - 30.000 TL"
        case .medium:
            return "30.000 - 50.000 TL"
        case .high:
            return "50.000 - 100.000 TL"
        case .veryHigh:
            return "100.000+ TL"
            
        }
    }
}
