//
//  EmployeeSizeEnum.swift
//  JobFinderApp
//
//  Created by Mustafa Ceylan on 29.05.2024.
//

import Foundation

enum EmployeeSizeEnum: String, Codable,CaseIterable {
    case verySmall = "Çok Küçük (1-10)"
    case small = "Küçük (11-50)"
    case medium = "Orta (51-200)"
    case large = "Büyük (201-500)"
    case extraLarge = "Çok Büyük (501+)"
    
    var description: String {
        switch self {
        case .verySmall:
            return "1 - 10 Çalışan"
        case .small:
            return "11 - 50 Çalışan"
        case .medium:
            return "51 - 200 Çalışan"
        case .large:
            return "201 - 500 Çalışan"
        case .extraLarge:
            return "500+ Çalışan"
        }
    }
}
