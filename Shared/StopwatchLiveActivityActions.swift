//
//  StopwatchLiveActivityActions.swift
//  Shared
//
//  Created by kartikay on 08/07/26.
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
            state.laps.append(elapsed - state.lapMark)
            state.lapMark = elapsed
            state.lapCount = state.laps.count
            state.lastLapDuration = state.laps.last ?? 0

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
