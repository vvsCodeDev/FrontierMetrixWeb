import Foundation
import Combine
import UIKit

@MainActor
class TimelineEngine: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var isPlaying: Bool = false
    @Published var dateRange: ClosedRange<Date> = Date.distantPast...Date.distantFuture
    
    private var timer: AnyCancellable?
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    private var isHapticsEnabled = true
    
    init() {
        setupTimer()
    }
    
    deinit {
        timer?.cancel()
    }
    
    func play() {
        isPlaying = true
    }
    
    func pause() {
        isPlaying = false
    }
    
    func step(by interval: TimeInterval) {
        let newDate = currentDate.addingTimeInterval(interval)
        if dateRange.contains(newDate) {
            currentDate = newDate
            triggerHapticFeedback()
        }
    }
    
    func setDateRange(_ range: ClosedRange<Date>) {
        dateRange = range
        if !range.contains(currentDate) {
            currentDate = range.lowerBound
        }
    }
    
    func resetToStart() {
        currentDate = dateRange.lowerBound
    }
    
    func resetToEnd() {
        currentDate = dateRange.upperBound
    }
    
    private func setupTimer() {
        timer = Timer.publish(every: 0.25, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    private func tick() {
        guard isPlaying else { return }
        
        let stepInterval: TimeInterval = 3600 // 1 hour steps
        let newDate = currentDate.addingTimeInterval(stepInterval)
        
        if dateRange.contains(newDate) {
            currentDate = newDate
            triggerHapticFeedback()
        } else {
            // Reached end of range, pause
            pause()
        }
    }
    
    private func triggerHapticFeedback() {
        guard isHapticsEnabled else { return }
        hapticFeedback.impactOccurred()
    }
    
    func setHapticsEnabled(_ enabled: Bool) {
        isHapticsEnabled = enabled
    }
    
    var progress: Double {
        let totalDuration = dateRange.upperBound.timeIntervalSince(dateRange.lowerBound)
        let currentDuration = currentDate.timeIntervalSince(dateRange.lowerBound)
        return totalDuration > 0 ? currentDuration / totalDuration : 0
    }
    
    func setProgress(_ progress: Double) {
        let clampedProgress = max(0, min(1, progress))
        let totalDuration = dateRange.upperBound.timeIntervalSince(dateRange.lowerBound)
        let targetDuration = totalDuration * clampedProgress
        currentDate = dateRange.lowerBound.addingTimeInterval(targetDuration)
    }
}
