import XCTest

final class UITests_GlobeBasics: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testLaunchAndWaitForPins() throws {
        // Wait for the app to load and show at least one pin
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.waitForExistence(timeout: 10))
        
        // Wait for at least one pin to appear (this might be a map annotation)
        // In a real test, we'd need to identify the specific annotation elements
        let pins = app.otherElements.matching(identifier: "AssetAnnotation")
        XCTAssertTrue(pins.count > 0, "Should have at least one asset pin visible")
    }
    
    func testTapPinAndShowAssetSheet() throws {
        // Wait for map to load
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.waitForExistence(timeout: 10))
        
        // Find and tap a pin (this is a simplified test - real implementation would need proper element identification)
        let pins = app.otherElements.matching(identifier: "AssetAnnotation")
        if pins.count > 0 {
            pins.firstMatch.tap()
            
            // Wait for asset info sheet to appear
            let assetSheet = app.sheets.firstMatch
            XCTAssertTrue(assetSheet.waitForExistence(timeout: 5))
            
            // Verify sheet contains asset name
            let assetName = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Bitcoin' OR label CONTAINS 'Naira'")).firstMatch
            XCTAssertTrue(assetName.exists, "Asset sheet should show asset name")
        }
    }
    
    func testFilterBarInteraction() throws {
        // Wait for filter bar to appear
        let filterBar = app.otherElements["FilterBar"]
        XCTAssertTrue(filterBar.waitForExistence(timeout: 5))
        
        // Test asset class filter chips
        let cryptoChip = app.buttons["Cryptocurrency"]
        if cryptoChip.exists {
            cryptoChip.tap()
        }
        
        // Test region picker
        let regionPicker = app.pickers["Region"]
        if regionPicker.exists {
            regionPicker.tap()
            // Select a different region
            let africaOption = app.pickerWheels.element.adjust(toPickerWheelValue: "Africa")
            africaOption.tap()
        }
    }
    
    func testTimelineControls() throws {
        // Wait for timeline scrubber to appear
        let timelineScrubber = app.otherElements["TimelineScrubber"]
        XCTAssertTrue(timelineScrubber.waitForExistence(timeout: 5))
        
        // Test play/pause button
        let playButton = app.buttons["play.circle.fill"]
        if playButton.exists {
            playButton.tap()
            
            // Wait a moment for play state
            Thread.sleep(forTimeInterval: 1)
            
            // Should now show pause button
            let pauseButton = app.buttons["pause.circle.fill"]
            XCTAssertTrue(pauseButton.exists, "Should show pause button when playing")
        }
        
        // Test timeline slider
        let timelineSlider = app.sliders.firstMatch
        if timelineSlider.exists {
            timelineSlider.adjust(toNormalizedSliderPosition: 0.5)
        }
    }
    
    func testResetGlobeButton() throws {
        // Wait for reset button to appear
        let resetButton = app.buttons["globe"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 5))
        
        // Tap reset button
        resetButton.tap()
        
        // Verify map resets to global view (this would need more specific assertions in a real test)
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.exists)
    }
    
    func testAccessibility() throws {
        // Test that map elements are accessible
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.isAccessibilityElement)
        
        // Test that pins have proper accessibility labels
        let pins = app.otherElements.matching(identifier: "AssetAnnotation")
        if pins.count > 0 {
            let firstPin = pins.firstMatch
            XCTAssertTrue(firstPin.isAccessibilityElement)
            XCTAssertNotNil(firstPin.label)
        }
    }
    
    func testPerformance() throws {
        // Basic performance test - measure time to load
        let startTime = Date()
        
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.waitForExistence(timeout: 10))
        
        let loadTime = Date().timeIntervalSince(startTime)
        XCTAssertLessThan(loadTime, 5.0, "Map should load within 5 seconds")
    }
}
