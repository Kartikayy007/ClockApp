//
//  StopwatchLiveActivityManager.swift
//  ClockApp
//

import ActivityKit
import Foundation

@MainActor
final class StopwatchLiveActivityManager {
    static let shared = StopwatchLiveActivityManager()

    private var activity: Activity<StopwatchAttributes>?

    private init() {}

    func sync(from stopwatch: StopwatchViewModel) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let state = stopwatch.liveActivityState()
        let hasProgress = stopwatch.isRunning || stopwatch.time() > 0

        if !hasProgress {
            await end()
            return
        }

        // Reattach after process restart / hot reload.
        if activity == nil {
            activity = Activity<StopwatchAttributes>.activities.first
        }

        if let activity {
            await activity.update(ActivityContent(state: state, staleDate: nil))
        } else {
            await start(state: state)
        }
    }

    private func start(state: StopwatchAttributes.ContentState) async {
        do {
            activity = try Activity.request(
                attributes: StopwatchAttributes(),
                content: ActivityContent(state: state, staleDate: nil),
                pushType: nil
            )
        } catch {
            // System may deny Live Activities; ignore quietly.
        }
    }

    private func end() async {
        guard let activity else { return }
        await activity.end(
            ActivityContent(state: activity.content.state, staleDate: nil),
            dismissalPolicy: .immediate
        )
        self.activity = nil
    }
}
