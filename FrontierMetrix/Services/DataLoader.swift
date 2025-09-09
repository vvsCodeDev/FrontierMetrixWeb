import Foundation
import Combine

class DataLoader: SignalRepository, ObservableObject {
    @Published var assets: [AssetSignal] = []
    @Published var flows: [AssetFlow] = []
    @Published var error: Error?
    
    private var allAssets: [AssetSignal] = []
    private var allFlows: [AssetFlow] = []
    private var currentFilters = Filters()
    private let dateFormatter: ISO8601DateFormatter
    private let throttler = PassthroughSubject<Void, Never>()
    
    var assetsPublisher: AnyPublisher<[AssetSignal], Never> {
        $assets.eraseToAnyPublisher()
    }
    
    var flowsPublisher: AnyPublisher<[AssetFlow], Never> {
        $flows.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        $error.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    init() {
        self.dateFormatter = ISO8601DateFormatter()
        self.dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Throttle updates to prevent excessive UI refreshes
        throttler
            .throttle(for: .milliseconds(120), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in
                self?.applyCurrentFilters()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func refresh() async {
        do {
            try await loadAssets()
            try await loadFlows()
            applyCurrentFilters()
        } catch {
            self.error = error
        }
    }
    
    func applyFilters(_ filters: Filters) {
        currentFilters = filters
        throttler.send()
    }
    
    func setCurrentDate(_ date: Date) {
        // Update the current date for time-based filtering
        // This will be used in the filtering logic
        currentFilters.dateRange = date...date
        throttler.send()
    }
    
    private func loadAssets() async throws {
        guard let url = Bundle.main.url(forResource: "seed_assets", withExtension: "json") else {
            throw DataLoaderError.fileNotFound("seed_assets.json")
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }
            
            // Fallback for dates without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            if let date = fallbackFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        
        allAssets = try decoder.decode([AssetSignal].self, from: data)
    }
    
    private func loadFlows() async throws {
        guard let url = Bundle.main.url(forResource: "seed_flows", withExtension: "json") else {
            throw DataLoaderError.fileNotFound("seed_flows.json")
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }
            
            // Fallback for dates without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            if let date = fallbackFormatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        
        allFlows = try decoder.decode([AssetFlow].self, from: data)
    }
    
    private func applyCurrentFilters() {
        assets = allAssets.filter { currentFilters.matches(asset: $0) }
        flows = allFlows.filter { currentFilters.matches(flow: $0) }
    }
}

enum DataLoaderError: LocalizedError {
    case fileNotFound(String)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find data file: \(filename)"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        }
    }
}
