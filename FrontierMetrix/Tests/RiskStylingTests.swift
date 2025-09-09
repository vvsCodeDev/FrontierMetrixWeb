import XCTest
import SwiftUI
@testable import FrontierMetrix

final class RiskStylingTests: XCTestCase {
    
    var riskStyling: RiskStyling!
    
    override func setUp() {
        super.setUp()
        riskStyling = RiskStyling()
    }
    
    override func tearDown() {
        riskStyling = nil
        super.tearDown()
    }
    
    func testPulseRates() {
        XCTAssertEqual(riskStyling.pulseRate(for: .low), 1.2)
        XCTAssertEqual(riskStyling.pulseRate(for: .medium), 0.9)
        XCTAssertEqual(riskStyling.pulseRate(for: .high), 0.6)
        XCTAssertEqual(riskStyling.pulseRate(for: .extreme), 0.45)
    }
    
    func testHaloWidths() {
        XCTAssertEqual(riskStyling.haloWidth(for: .low), 4)
        XCTAssertEqual(riskStyling.haloWidth(for: .medium), 6)
        XCTAssertEqual(riskStyling.haloWidth(for: .high), 8)
        XCTAssertEqual(riskStyling.haloWidth(for: .extreme), 10)
    }
    
    func testDotSizes() {
        XCTAssertEqual(riskStyling.dotSize(for: .low), 8)
        XCTAssertEqual(riskStyling.dotSize(for: .medium), 10)
        XCTAssertEqual(riskStyling.dotSize(for: .high), 12)
        XCTAssertEqual(riskStyling.dotSize(for: .extreme), 14)
    }
    
    func testAnimationDurations() {
        XCTAssertEqual(riskStyling.animationDuration(for: .low), 1.0 / 1.2, accuracy: 0.001)
        XCTAssertEqual(riskStyling.animationDuration(for: .medium), 1.0 / 0.9, accuracy: 0.001)
        XCTAssertEqual(riskStyling.animationDuration(for: .high), 1.0 / 0.6, accuracy: 0.001)
        XCTAssertEqual(riskStyling.animationDuration(for: .extreme), 1.0 / 0.45, accuracy: 0.001)
    }
    
    func testStandardColors() {
        riskStyling.isColorVisionFriendly = false
        
        // Test that colors are not nil (we can't easily test exact colors without UI)
        let lowColor = riskStyling.color(for: .low)
        let mediumColor = riskStyling.color(for: .medium)
        let highColor = riskStyling.color(for: .high)
        let extremeColor = riskStyling.color(for: .extreme)
        
        XCTAssertNotNil(lowColor)
        XCTAssertNotNil(mediumColor)
        XCTAssertNotNil(highColor)
        XCTAssertNotNil(extremeColor)
    }
    
    func testColorVisionFriendlyColors() {
        riskStyling.isColorVisionFriendly = true
        
        // Test that colors are not nil
        let lowColor = riskStyling.color(for: .low)
        let mediumColor = riskStyling.color(for: .medium)
        let highColor = riskStyling.color(for: .high)
        let extremeColor = riskStyling.color(for: .extreme)
        
        XCTAssertNotNil(lowColor)
        XCTAssertNotNil(mediumColor)
        XCTAssertNotNil(highColor)
        XCTAssertNotNil(extremeColor)
    }
    
    func testAccessibilityLabel() {
        let asset = AssetSignal(
            id: "test",
            name: "Test Asset",
            type: .crypto,
            latitude: 0,
            longitude: 0,
            value: 1.0,
            risk: .high,
            country: "US",
            ts: Date()
        )
        
        let label = riskStyling.accessibilityLabel(for: asset)
        XCTAssertTrue(label.contains("Test Asset"))
        XCTAssertTrue(label.contains("Cryptocurrency"))
        XCTAssertTrue(label.contains("High"))
    }
    
    func testAccessibilityHint() {
        let hint = riskStyling.accessibilityHint()
        XCTAssertEqual(hint, "Double-tap for details")
    }
}
