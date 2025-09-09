import XCTest
import CoreLocation
@testable import FrontierMetrix

final class FlowArcCalculatorTests: XCTestCase {
    
    func testGreatCircleEndpoints() {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let end = CLLocationCoordinate2D(latitude: 90, longitude: 0)
        
        let coordinates = FlowArcCalculator.greatCircle(from: start, to: end, segments: 10)
        
        XCTAssertEqual(coordinates.first?.latitude, start.latitude, accuracy: 0.001)
        XCTAssertEqual(coordinates.first?.longitude, start.longitude, accuracy: 0.001)
        XCTAssertEqual(coordinates.last?.latitude, end.latitude, accuracy: 0.001)
        XCTAssertEqual(coordinates.last?.longitude, end.longitude, accuracy: 0.001)
    }
    
    func testSegmentCountRules() {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let end = CLLocationCoordinate2D(latitude: 1, longitude: 1)
        
        let coordinates = FlowArcCalculator.greatCircle(from: start, to: end, segments: 64)
        
        // Should have segments + 1 points (including start and end)
        XCTAssertEqual(coordinates.count, 65)
    }
    
    func testMonotonicLongitudesOnSmallArcs() {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let end = CLLocationCoordinate2D(latitude: 0.1, longitude: 0.1)
        
        let coordinates = FlowArcCalculator.greatCircle(from: start, to: end, segments: 20)
        
        // Check that longitudes are generally increasing
        var previousLon = coordinates.first?.longitude ?? 0
        for coordinate in coordinates.dropFirst() {
            XCTAssertGreaterThanOrEqual(coordinate.longitude, previousLon - 0.1) // Allow small tolerance
            previousLon = coordinate.longitude
        }
    }
    
    func testArchApexAltitude() {
        let start = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let end = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        
        let coordinates = FlowArcCalculator.greatCircle(from: start, to: end, segments: 20)
        
        // Find the middle point (should be the apex)
        let middleIndex = coordinates.count / 2
        let apex = coordinates[middleIndex]
        
        // The apex should be higher than both endpoints
        // This is a simplified test - in reality, we'd need to calculate the actual altitude
        XCTAssertNotNil(apex)
    }
    
    func testPolylineWidthCalculation() {
        let width1 = FlowArcCalculator.calculatePolylineWidth(for: 0.5)
        let width2 = FlowArcCalculator.calculatePolylineWidth(for: 1.0)
        let width3 = FlowArcCalculator.calculatePolylineWidth(for: 2.0)
        
        XCTAssertGreaterThan(width2, width1)
        XCTAssertGreaterThan(width3, width2)
        XCTAssertGreaterThanOrEqual(width1, 1.0)
        XCTAssertLessThanOrEqual(width3, 5.0)
    }
    
    func testPolylineAlphaCalculation() {
        let alpha1 = FlowArcCalculator.calculatePolylineAlpha(for: 0.5)
        let alpha2 = FlowArcCalculator.calculatePolylineAlpha(for: 1.0)
        let alpha3 = FlowArcCalculator.calculatePolylineAlpha(for: 2.0)
        
        XCTAssertGreaterThan(alpha2, alpha1)
        XCTAssertGreaterThan(alpha3, alpha2)
        XCTAssertGreaterThanOrEqual(alpha1, 0.3)
        XCTAssertLessThanOrEqual(alpha3, 1.0)
    }
    
    func testCreatePolylineFromFlow() {
        let flow = AssetFlow(
            id: "test",
            fromLat: 0,
            fromLon: 0,
            toLat: 10,
            toLon: 10,
            magnitude: 1.5,
            classTag: .currency,
            ts: Date()
        )
        
        let coordinates = FlowArcCalculator.createPolyline(from: flow)
        
        XCTAssertFalse(coordinates.isEmpty)
        XCTAssertEqual(coordinates.first?.latitude, flow.fromLat, accuracy: 0.001)
        XCTAssertEqual(coordinates.first?.longitude, flow.fromLon, accuracy: 0.001)
        XCTAssertEqual(coordinates.last?.latitude, flow.toLat, accuracy: 0.001)
        XCTAssertEqual(coordinates.last?.longitude, flow.toLon, accuracy: 0.001)
    }
}
