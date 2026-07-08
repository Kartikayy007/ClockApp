//
//  StopwatchLiveActivityIntents.swift
//  Shared
//

import AppIntents

struct ToggleStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Stopwatch"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        await StopwatchLiveActivityActions.perform(.toggle)
        return .result()
    }
}

struct LapStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Lap Stopwatch"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        await StopwatchLiveActivityActions.perform(.lap)
        return .result()
    }
}

struct ResetStopwatchIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Reset Stopwatch"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        await StopwatchLiveActivityActions.perform(.reset)
        return .result()
    }
}
