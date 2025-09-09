import Foundation
import Combine

protocol SignalRepository {
    var assetsPublisher: AnyPublisher<[AssetSignal], Never> { get }
    var flowsPublisher: AnyPublisher<[AssetFlow], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func refresh() async
    func applyFilters(_ filters: Filters)
    func setCurrentDate(_ date: Date)
}
