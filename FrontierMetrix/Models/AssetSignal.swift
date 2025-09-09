import Foundation
import CoreLocation

struct AssetSignal: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let type: AssetClass
    let latitude: Double
    let longitude: Double
    let value: Double
    let risk: RiskLevel
    let country: String
    let ts: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: ts)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: AssetSignal, rhs: AssetSignal) -> Bool {
        return lhs.id == rhs.id
    }
}
