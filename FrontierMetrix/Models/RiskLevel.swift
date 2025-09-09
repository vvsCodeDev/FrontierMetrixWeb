import Foundation

enum RiskLevel: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case extreme = "extreme"
    
    var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        case .extreme:
            return "Extreme"
        }
    }
    
    var order: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        case .extreme:
            return 3
        }
    }
    
    static func >= (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        return lhs.order >= rhs.order
    }
    
    static func <= (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        return lhs.order <= rhs.order
    }
}
