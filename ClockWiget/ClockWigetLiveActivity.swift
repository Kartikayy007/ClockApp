//
//  ClockWigetLiveActivity.swift
//  ClockWiget
//
//  Created by kartikay on 08/07/26.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

private let stopwatchOrange = Color(red: 1.0, green: 149.0 / 255.0, blue: 0)
struct ClockWigetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StopwatchAttributes.self) { context in
            lockScreenView(context: context)
                .activityBackgroundTint(.black)
                .activitySystemActionForegroundColor(stopwatchOrange)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading, priority: 1) {
                    expandedLeading(context: context)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    expandedTrailing(context: context)
                }
            } compactLeading: {
                compactStopwatchIcon(state: context.state, size: 17)
            } compactTrailing: {
                compactTime(context.state)
                    .foregroundStyle(stopwatchOrange)
            } minimal: {
                compactStopwatchIcon(state: context.state, size: 14)
            }
            .widgetURL(URL(string: "clockapp://open"))
            .keylineTint(stopwatchOrange)
        }
    }

    private func compactStopwatchIcon(state: StopwatchAttributes.ContentState, size: CGFloat) -> some View {
        ZStack {
            Image(systemName: "stopwatch")
                .font(.system(size: size, weight: .semibold))
                .foregroundStyle(stopwatchOrange)

            if !state.isRunning {
                Circle()
                    .fill(.black)
                    .frame(width: size * 0.48, height: size * 0.48)
                    .offset(y: size * 0.11)

                Image(systemName: "pause.fill")
                    .font(.system(size: size * 0.34, weight: .black))
                    .foregroundStyle(stopwatchOrange)
                    .offset(y: size * 0.11)
            }
        }
    }

    @ViewBuilder
    private func compactTime(_ state: StopwatchAttributes.ContentState) -> some View {
        // Live Activities don't allow custom high-frequency timers (TimelineView).
        // Text(timerInterval:) is the system path that keeps seconds ticking.
        Group {
            if state.isRunning, let startedAt = state.startedAt {
                Text(
                    timerInterval: startedAt...startedAt.addingTimeInterval(9 * 60 * 60),
                    countsDown: false,
                    showsHours: false
                )
            } else {
                Text(compactMainTime(state.accumulatedTime))
            }
        }
        .font(.caption)
        .monospacedDigit()
        .multilineTextAlignment(.trailing)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(width: 44, alignment: .trailing)
        .padding(.trailing, 1)
    }

    private func compactMainTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }


    private func expandedLeading(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        HStack(spacing: 10) {
            Button(intent: ToggleStopwatchIntent()) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.35, green: 0.18, blue: 0.05))
                    Image(systemName: context.state.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(stopwatchOrange)
                }
            }
            .buttonStyle(.plain)

            if context.state.isRunning {
                Button(intent: LapStopwatchIntent()) {
                    ZStack {
                        Circle()
                            .fill(Color(white: 0.22))
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
            } else {
                Button(intent: ResetStopwatchIntent()) {
                    ZStack {
                        Circle()
                            .fill(Color(white: 0.22))
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(width: 110, alignment: .leading)
    }

    private func expandedTrailing(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        expandedPrimaryTimer(context.state)
            .font(.system(size: 36, weight: .medium, design: .rounded))
            .foregroundStyle(stopwatchOrange)
            .monospacedDigit()
            .multilineTextAlignment(.trailing)
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            .frame(width: 96, alignment: .trailing)
            .overlay(alignment: .topTrailing) {
                if context.state.lapCount > 0 {
                    expandedLapRow(context.state)
                        .offset(y: -15)
                }
            }
            .frame(width: 96, alignment: .trailing)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .offset(y: context.state.lapCount > 0 ? 6 : 0)
    }

    private func expandedLapRow(_ state: StopwatchAttributes.ContentState) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("LAP \(state.lapCount + 1)")
            expandedLapTimer(state)
                .multilineTextAlignment(.trailing)
        }
        .font(.system(size: 16, weight: .semibold, design: .rounded))
        .foregroundStyle(stopwatchOrange)
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(maxWidth: 88, alignment: .trailing)
    }

    @ViewBuilder
    private func expandedLapTimer(_ state: StopwatchAttributes.ContentState) -> some View {
        if state.isRunning, let startedAt = state.startedAt {
            let lapStartedAt = startedAt.addingTimeInterval(state.lapMark)
            Text(
                timerInterval: lapStartedAt...lapStartedAt.addingTimeInterval(9 * 60 * 60),
                countsDown: false,
                showsHours: false
            )
        } else {
            Text(StopwatchAttributes.ContentState.formatPadded(state.accumulatedTime - state.lapMark))
        }
    }

    @ViewBuilder
    private func expandedPrimaryTimer(_ state: StopwatchAttributes.ContentState) -> some View {
        if state.isRunning, let startedAt = state.startedAt {
            Text(
                timerInterval: startedAt...startedAt.addingTimeInterval(9 * 60 * 60),
                countsDown: false,
                showsHours: false
            )
        } else {
            Text(compactMainTime(state.accumulatedTime))
        }
    }

    private func lockScreenView(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        HStack {
            Image(systemName: "stopwatch.fill")
                .foregroundStyle(stopwatchOrange)

            VStack(alignment: .trailing, spacing: 2) {
                if context.state.lapCount > 0 {
                    Text(
                        "LAP \(context.state.lapCount) \(StopwatchAttributes.ContentState.formatPadded(context.state.lastLapDuration))"
                    )
                    .font(.system(size: 8, weight: .regular, design: .default))
                    .foregroundStyle(stopwatchOrange)
                    .monospacedDigit()
                }
                expandedPrimaryTimer(context.state)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(stopwatchOrange)
                    .monospacedDigit()
            }
        }
    }
}

extension StopwatchAttributes {
    fileprivate static var preview: StopwatchAttributes { StopwatchAttributes() }
}

extension StopwatchAttributes.ContentState {
    fileprivate static var running: StopwatchAttributes.ContentState {
        .init(
            isRunning: true,
            startedAt: Date().addingTimeInterval(-15),
            accumulatedTime: 0,
            lapCount: 0,
            lastLapDuration: 0,
            lapMark: 0
        )
    }

    fileprivate static var runningWithLaps: StopwatchAttributes.ContentState {
        .init(
            isRunning: true,
            startedAt: Date().addingTimeInterval(-15),
            accumulatedTime: 0,
            lapCount: 2,
            lastLapDuration: 14,
            lapMark: 30
        )
    }

    fileprivate static var paused: StopwatchAttributes.ContentState {
        .init(
            isRunning: false,
            startedAt: nil,
            accumulatedTime: 92.5,
            lapCount: 3,
            lastLapDuration: 20.1,
            lapMark: 72.4
        )
    }
}

#Preview("Lock Screen", as: .content, using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.running
    StopwatchAttributes.ContentState.runningWithLaps
    StopwatchAttributes.ContentState.paused
}

#Preview("Island Compact", as: .dynamicIsland(.compact), using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.running
    StopwatchAttributes.ContentState.paused
}

#Preview("Island Expanded", as: .dynamicIsland(.expanded), using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.running
    StopwatchAttributes.ContentState.runningWithLaps
    StopwatchAttributes.ContentState.paused
}

#Preview("Island Minimal", as: .dynamicIsland(.minimal), using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.running
    StopwatchAttributes.ContentState.paused
}
