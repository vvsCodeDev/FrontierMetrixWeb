import Foundation

enum RegionPreset: String, Codable, CaseIterable {
    case global = "global"
    case africa = "africa"
    case latam = "latam"
    case apac = "apac"
    case emea = "emea"
    case mena = "mena"
    case europe = "europe"
    case northAmerica = "northAmerica"
    
    var displayName: String {
        switch self {
        case .global:
            return "Global"
        case .africa:
            return "Africa"
        case .latam:
            return "Latin America"
        case .apac:
            return "Asia Pacific"
        case .emea:
            return "EMEA"
        case .mena:
            return "MENA"
        case .europe:
            return "Europe"
        case .northAmerica:
            return "North America"
        }
    }
    
    var centerCoordinate: (latitude: Double, longitude: Double) {
        switch self {
        case .global:
            return (0, 0)
        case .africa:
            return (4, 20)
        case .latam:
            return (-15, -60)
        case .apac:
            return (10, 115)
        case .emea:
            return (35, 20)
        case .mena:
            return (24, 44)
        case .europe:
            return (54, 15)
        case .northAmerica:
            return (39, -98)
        }
    }
    
    var centerDistance: Double {
        switch self {
        case .global:
            return 25_000_000
        case .africa:
            return 4_200_000
        case .latam:
            return 5_000_000
        case .apac:
            return 6_000_000
        case .emea:
            return 5_200_000
        case .mena:
            return 3_800_000
        case .europe:
            return 2_800_000
        case .northAmerica:
            return 3_800_000
        }
    }
}

struct Filters: Equatable {
    var assetClasses: Set<AssetClass>
    var region: RegionPreset
    var riskMin: RiskLevel
    var dateRange: ClosedRange<Date>
    var showFlows: Bool
    
    init(
        assetClasses: Set<AssetClass> = Set(AssetClass.allCases),
        region: RegionPreset = .global,
        riskMin: RiskLevel = .low,
        dateRange: ClosedRange<Date> = Date.distantPast...Date.distantFuture,
        showFlows: Bool = true
    ) {
        self.assetClasses = assetClasses
        self.region = region
        self.riskMin = riskMin
        self.dateRange = dateRange
        self.showFlows = showFlows
    }
    
    func matches(asset: AssetSignal) -> Bool {
        return assetClasses.contains(asset.type) &&
               asset.risk >= riskMin &&
               dateRange.contains(asset.ts)
    }
    
    func matches(flow: AssetFlow) -> Bool {
        return showFlows &&
               assetClasses.contains(flow.classTag) &&
               dateRange.contains(flow.ts)
    }
}
