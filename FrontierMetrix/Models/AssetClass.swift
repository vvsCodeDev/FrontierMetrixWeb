import Foundation

enum AssetClass: String, Codable, CaseIterable {
    case currency = "currency"
    case crypto = "crypto"
    case bond = "bond"
    case commodity = "commodity"
    case stablecoin = "stablecoin"
    
    var displayName: String {
        switch self {
        case .currency:
            return "Currency"
        case .crypto:
            return "Cryptocurrency"
        case .bond:
            return "Bond"
        case .commodity:
            return "Commodity"
        case .stablecoin:
            return "Stablecoin"
        }
    }
    
    var icon: String {
        switch self {
        case .currency:
            return "dollarsign.circle"
        case .crypto:
            return "bitcoinsign.circle"
        case .bond:
            return "chart.line.uptrend.xyaxis"
        case .commodity:
            return "leaf"
        case .stablecoin:
            return "shield"
        }
    }
}
