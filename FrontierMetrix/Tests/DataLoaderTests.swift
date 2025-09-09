import XCTest
import Combine
@testable import FrontierMetrix

final class DataLoaderTests: XCTestCase {
    
    var dataLoader: DataLoader!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        dataLoader = DataLoader()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        dataLoader = nil
        super.tearDown()
    }
    
    func testValidJSONParses() async {
        // This test would require the actual JSON files to be available
        // In a real test environment, we'd mock the Bundle or use test data
        
        let expectation = XCTestExpectation(description: "Data loaded")
        
        dataLoader.$assets
            .dropFirst() // Skip initial empty state
            .sink { assets in
                if !assets.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        await dataLoader.refresh()
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testInvalidFieldsIgnored() {
        // Test that the decoder handles missing or invalid fields gracefully
        let invalidJSON = """
        [
            {
                "id": "test1",
                "name": "Valid Asset",
                "type": "crypto",
                "latitude": 37.7749,
                "longitude": -122.4194,
                "value": 1.0,
                "risk": "medium",
                "country": "US",
                "ts": "2025-01-20T12:00:00.000Z"
            },
            {
                "id": "test2",
                "name": "Invalid Asset",
                "type": "invalid_type",
                "latitude": "invalid_lat",
                "longitude": -122.4194,
                "value": 1.0,
                "risk": "medium",
                "country": "US",
                "ts": "2025-01-20T12:00:00.000Z"
            }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            let fallbackFormatter = ISO8601DateFormatter()
            return fallbackFormatter.date(from: dateString) ?? Date()
        }
        
        // This should not crash, even with invalid data
        XCTAssertNoThrow(try decoder.decode([AssetSignal].self, from: invalidJSON))
    }
    
    func testBadDateReturnsPartialSuccess() {
        let mixedDateJSON = """
        [
            {
                "id": "test1",
                "name": "Valid Asset",
                "type": "crypto",
                "latitude": 37.7749,
                "longitude": -122.4194,
                "value": 1.0,
                "risk": "medium",
                "country": "US",
                "ts": "2025-01-20T12:00:00.000Z"
            },
            {
                "id": "test2",
                "name": "Invalid Date Asset",
                "type": "currency",
                "latitude": 40.7128,
                "longitude": -74.0060,
                "value": 1.0,
                "risk": "low",
                "country": "US",
                "ts": "invalid_date"
            }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            let fallbackFormatter = ISO8601DateFormatter()
            return fallbackFormatter.date(from: dateString) ?? Date()
        }
        
        do {
            let assets = try decoder.decode([AssetSignal].self, from: mixedDateJSON)
            // Should still decode the valid asset
            XCTAssertEqual(assets.count, 2)
            XCTAssertEqual(assets[0].name, "Valid Asset")
            XCTAssertEqual(assets[1].name, "Invalid Date Asset")
        } catch {
            XCTFail("Should not throw error for bad dates: \(error)")
        }
    }
    
    func testFiltersApplication() {
        let expectation = XCTestExpectation(description: "Filters applied")
        
        // Set up test data
        dataLoader.assets = [
            AssetSignal(
                id: "1",
                name: "Crypto",
                type: .crypto,
                latitude: 0,
                longitude: 0,
                value: 1.0,
                risk: .low,
                country: "US",
                ts: Date()
            ),
            AssetSignal(
                id: "2",
                name: "Currency",
                type: .currency,
                latitude: 0,
                longitude: 0,
                value: 1.0,
                risk: .high,
                country: "US",
                ts: Date()
            )
        ]
        
        var filterCount = 0
        dataLoader.$assets
            .sink { assets in
                filterCount += 1
                if filterCount == 2 { // Initial load + filter application
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Apply filter for only crypto assets
        var filters = Filters()
        filters.assetClasses = [.crypto]
        dataLoader.applyFilters(filters)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Should only have crypto assets after filtering
        XCTAssertEqual(dataLoader.assets.count, 1)
        XCTAssertEqual(dataLoader.assets.first?.type, .crypto)
    }
    
    func testErrorHandling() {
        let expectation = XCTestExpectation(description: "Error published")
        
        dataLoader.errorPublisher
            .sink { error in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // This would trigger an error in a real scenario
        // We can't easily test file not found without mocking Bundle
        wait(for: [expectation], timeout: 1.0)
    }
}
