//
//  StopwatchViewModel.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import Foundation
import Observation

@Observable
final class StopwatchViewModel {
    private(set) var isRunning = false
    private(set) var laps: [TimeInterval] = []
    private(set) var referenceDate = Date()
    private(set) var lapMark: TimeInterval = 0

    private var accumulatedTime: TimeInterval = 0

    static func format(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let hundredths = Int((time * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    func time(at date: Date = .now) -> TimeInterval {
        isRunning ? accumulatedTime + date.timeIntervalSince(referenceDate) : accumulatedTime
    }

    func currentLap(at date: Date = .now) -> TimeInterval {
        time(at: date) - lapMark
    }

    func toggle() {
        if isRunning {
            accumulatedTime = time(at: .now)
            isRunning = false
        } else {
            referenceDate = .now
            isRunning = true
        }
        Task { await StopwatchLiveActivityManager.shared.sync(from: self) }
    }

    func addLap() {
        let current = time(at: .now)
        laps.append(current - lapMark)
        lapMark = current
        Task { await StopwatchLiveActivityManager.shared.sync(from: self) }
    }

    func reset() {
        accumulatedTime = 0
        laps = []
        lapMark = 0
        isRunning = false
        Task { await StopwatchLiveActivityManager.shared.sync(from: self) }
    }

    func restore(from state: StopwatchAttributes.ContentState) {
        isRunning = state.isRunning
        lapMark = state.lapMark
        if state.isRunning, let startedAt = state.startedAt {
            accumulatedTime = 0
            referenceDate = startedAt
        } else {
            accumulatedTime = state.accumulatedTime
        }
    }

    func liveActivityState() -> StopwatchAttributes.ContentState {
        let timerStart = isRunning
            ? referenceDate.addingTimeInterval(-accumulatedTime)
            : nil

        return StopwatchAttributes.ContentState(
            isRunning: isRunning,
            startedAt: timerStart,
            accumulatedTime: isRunning ? 0 : accumulatedTime,
            lapCount: laps.count,
            lastLapDuration: laps.last ?? 0,
            lapMark: lapMark
        )
    }
}
