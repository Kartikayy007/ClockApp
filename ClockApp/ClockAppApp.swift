//
//  ClockAppApp.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import ActivityKit
import SwiftUI

@main
struct ClockAppApp: App {
    @State private var stopwatch = StopwatchViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ClockView(stopwatch: stopwatch)
                .onOpenURL { url in
                    handleDeepLink(url)
                }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        syncStopwatchFromLiveActivity()
                    }
                }
        }
    }

    private func syncStopwatchFromLiveActivity() {
        if let activity = Activity<StopwatchAttributes>.activities.first {
            stopwatch.restore(from: activity.content.state)
        } else if stopwatch.isRunning || stopwatch.time() > 0 {
            stopwatch.reset()
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "clockapp" else { return }

        if let activity = Activity<StopwatchAttributes>.activities.first {
            stopwatch.restore(from: activity.content.state)
        }

        switch url.host {
        case "toggle":
            stopwatch.toggle()
        case "lap":
            if stopwatch.isRunning {
                stopwatch.addLap()
            }
        case "reset":
            stopwatch.reset()
        default:
            break
        }
    }
}
