import Foundation
import CoreLocation

struct AssetFlow: Identifiable, Codable, Hashable {
    let id: String
    let fromLat: Double
    let fromLon: Double
    let toLat: Double
    let toLon: Double
    let magnitude: Double
    let classTag: AssetClass
    let ts: Date
    
    var fromCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: fromLat, longitude: fromLon)
    }
    
    var toCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: toLat, longitude: toLon)
    }
    
    var distance: Double {
        let from = CLLocation(latitude: fromLat, longitude: fromLon)
        let to = CLLocation(latitude: toLat, longitude: toLon)
        return from.distance(from: to)
    }
    
    var formattedMagnitude: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: magnitude)) ?? "\(magnitude)"
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: AssetFlow, rhs: AssetFlow) -> Bool {
        return lhs.id == rhs.id
    }
}
