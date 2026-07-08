//
//  StopwatchLiveActivityActions.swift
//  Shared
//

import ActivityKit
import Foundation

enum StopwatchIslandAction {
    case toggle
    case lap
    case reset
}

@MainActor
enum StopwatchLiveActivityActions {
    static func perform(_ action: StopwatchIslandAction) async {
        guard let activity = Activity<StopwatchAttributes>.activities.first else { return }

        var state = activity.content.state
        let now = Date()

        switch action {
        case .toggle:
            if state.isRunning, let startedAt = state.startedAt {
                state.accumulatedTime = max(0, now.timeIntervalSince(startedAt))
                state.isRunning = false
                state.startedAt = nil
            } else {
                state.isRunning = true
                state.startedAt = now.addingTimeInterval(-state.accumulatedTime)
                state.accumulatedTime = 0
            }

        case .lap:
            guard state.isRunning, let startedAt = state.startedAt else { return }
            let elapsed = max(0, now.timeIntervalSince(startedAt))
            state.lastLapDuration = elapsed - state.lapMark
            state.lapCount += 1
            state.lapMark = elapsed

        case .reset:
            await activity.end(
                ActivityContent(state: state, staleDate: nil),
                dismissalPolicy: .immediate
            )
            return
        }

        await activity.update(ActivityContent(state: state, staleDate: nil))
    }
}
