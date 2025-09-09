import SwiftUI

class RiskStyling: ObservableObject {
    @Published var isColorVisionFriendly: Bool = false
    
    func color(for riskLevel: RiskLevel) -> Color {
        if isColorVisionFriendly {
            return colorVisionFriendlyColor(for: riskLevel)
        } else {
            return standardColor(for: riskLevel)
        }
    }
    
    private func standardColor(for riskLevel: RiskLevel) -> Color {
        switch riskLevel {
        case .low:
            return Color.green
        case .medium:
            return Color.yellow
        case .high:
            return Color.orange
        case .extreme:
            return Color.red
        }
    }
    
    private func colorVisionFriendlyColor(for riskLevel: RiskLevel) -> Color {
        switch riskLevel {
        case .low:
            return Color.blue
        case .medium:
            return Color.cyan
        case .high:
            return Color.purple
        case .extreme:
            return Color.pink
        }
    }
    
    func pulseRate(for riskLevel: RiskLevel) -> Double {
        switch riskLevel {
        case .low:
            return 1.2
        case .medium:
            return 0.9
        case .high:
            return 0.6
        case .extreme:
            return 0.45
        }
    }
    
    func haloWidth(for riskLevel: RiskLevel) -> CGFloat {
        switch riskLevel {
        case .low:
            return 4
        case .medium:
            return 6
        case .high:
            return 8
        case .extreme:
            return 10
        }
    }
    
    func dotSize(for riskLevel: RiskLevel) -> CGFloat {
        switch riskLevel {
        case .low:
            return 8
        case .medium:
            return 10
        case .high:
            return 12
        case .extreme:
            return 14
        }
    }
    
    func animationDuration(for riskLevel: RiskLevel) -> Double {
        return 1.0 / pulseRate(for: riskLevel)
    }
    
    // MARK: - Accessibility
    
    func accessibilityLabel(for asset: AssetSignal) -> String {
        return "\(asset.name), \(asset.type.displayName), risk \(asset.risk.displayName)"
    }
    
    func accessibilityHint() -> String {
        return "Double-tap for details"
    }
}
