import Foundation
import CoreLocation

class FlowArcCalculator {
    private static let earthRadiusMeters: Double = 6_371_000
    
    static func greatCircle(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D,
        segments: Int = 64,
        heightScale: Double = 0.12
    ) -> [CLLocationCoordinate2D] {
        let distance = haversineKm(start, end)
        let adaptiveSegments = max(24, min(96, Int(distance / 500.0)))
        let finalSegments = min(segments, adaptiveSegments)
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        for i in 0...finalSegments {
            let t = Double(i) / Double(finalSegments)
            let coordinate = interpolateGreatCircle(
                from: start,
                to: end,
                t: t,
                heightScale: heightScale
            )
            coordinates.append(coordinate)
        }
        
        return coordinates
    }
    
    private static func interpolateGreatCircle(
        from start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D,
        t: Double,
        heightScale: Double
    ) -> CLLocationCoordinate2D {
        let lat1 = start.latitude * .pi / 180
        let lon1 = start.longitude * .pi / 180
        let lat2 = end.latitude * .pi / 180
        let lon2 = end.longitude * .pi / 180
        
        let d = haversineRadians(lat1, lon1, lat2, lon2)
        
        // Handle edge case where points are too close
        guard d > 0.001 else {
            return CLLocationCoordinate2D(
                latitude: start.latitude + t * (end.latitude - start.latitude),
                longitude: start.longitude + t * (end.longitude - start.longitude)
            )
        }
        
        let a = sin((1 - t) * d) / sin(d)
        let b = sin(t * d) / sin(d)
        
        let x = a * cos(lat1) * cos(lon1) + b * cos(lat2) * cos(lon2)
        let y = a * cos(lat1) * sin(lon1) + b * cos(lat2) * sin(lon2)
        let z = a * sin(lat1) + b * sin(lat2)
        
        // Apply arch height
        let archHeight = sin(t * .pi) * heightScale * earthRadiusMeters
        let heightFactor = 1 + (archHeight / earthRadiusMeters)
        
        let finalX = x * heightFactor
        let finalY = y * heightFactor
        let finalZ = z * heightFactor
        
        let lat = atan2(finalZ, sqrt(finalX * finalX + finalY * finalY))
        let lon = atan2(finalY, finalX)
        
        return CLLocationCoordinate2D(
            latitude: lat * 180 / .pi,
            longitude: lon * 180 / .pi
        )
    }
    
    private static func haversineKm(_ start: CLLocationCoordinate2D, _ end: CLLocationCoordinate2D) -> Double {
        let lat1 = start.latitude * .pi / 180
        let lon1 = start.longitude * .pi / 180
        let lat2 = end.latitude * .pi / 180
        let lon2 = end.longitude * .pi / 180
        
        return haversineRadians(lat1, lon1, lat2, lon2) * earthRadiusMeters / 1000
    }
    
    private static func haversineRadians(_ lat1: Double, _ lon1: Double, _ lat2: Double, _ lon2: Double) -> Double {
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1) * cos(lat2) *
                sin(dLon / 2) * sin(dLon / 2)
        
        return 2 * atan2(sqrt(a), sqrt(1 - a))
    }
    
    static func createPolyline(from flow: AssetFlow) -> [CLLocationCoordinate2D] {
        return greatCircle(
            from: flow.fromCoordinate,
            to: flow.toCoordinate,
            heightScale: min(0.12, max(0.05, flow.magnitude * 0.1))
        )
    }
    
    static func calculatePolylineWidth(for magnitude: Double) -> Double {
        // Scale width based on magnitude (1.0 to 5.0 points)
        return max(1.0, min(5.0, magnitude * 2.0))
    }
    
    static func calculatePolylineAlpha(for magnitude: Double) -> Double {
        // Scale alpha based on magnitude (0.3 to 1.0)
        return max(0.3, min(1.0, magnitude * 0.5))
    }
}
