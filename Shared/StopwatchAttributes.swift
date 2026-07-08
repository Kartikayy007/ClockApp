//
//  StopwatchAttributes.swift
//  StopwatchAttributes
//

import ActivityKit
import Foundation

struct StopwatchAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isRunning: Bool
        var startedAt: Date?
        var accumulatedTime: TimeInterval
        var lapCount: Int
        var lastLapDuration: TimeInterval
        var lapMark: TimeInterval

        static func format(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            let hundredths = Int((time * 100).truncatingRemainder(dividingBy: 100))
            return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
        }

        static func formatCompact(_ time: TimeInterval) -> String {
            let totalSeconds = Int(time)
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            return String(format: "%d:%02d", minutes, seconds)
        }

        /// Zero-padded `MM:SS` for expanded island lap labels (`00:14`).
        static func formatPadded(_ time: TimeInterval) -> String {
            let totalSeconds = Int(time)
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
