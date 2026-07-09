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
private let lockScreenButtonSize: CGFloat = 44
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
                    .frame(width: size * 0.7, height: size * 0.88)
                    .offset(y: size * 0.06)

                Image(systemName: "pause.fill")
                    .font(.system(size: size * 0.34, weight: .black))
                    .foregroundStyle(stopwatchOrange)
                    .offset(y: size * 0.06)
            }
        }
    }

    @ViewBuilder
    private func compactTime(_ state: StopwatchAttributes.ContentState) -> some View {
        Group {
            if state.isRunning, let startedAt = state.startedAt {
                Text(
                    timerInterval: startedAt...startedAt.addingTimeInterval(9 * 60 * 60),
                    countsDown: false,
                    showsHours: false
                )
            } else {
                Text(StopwatchAttributes.ContentState.formatPadded(state.accumulatedTime))
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
            Text(StopwatchAttributes.ContentState.formatPadded(state.accumulatedTime))
        }
    }

    private func lockScreenView(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        HStack(alignment: .center, spacing: 12) {
            lockScreenControls(context: context)
            Spacer(minLength: 0)
            lockScreenTimerColumn(context: context)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func lockScreenControls(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        HStack(spacing: 8) {
            Button(intent: ToggleStopwatchIntent()) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.35, green: 0.18, blue: 0.05).opacity(0.6))
                    Image(systemName: context.state.isRunning ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(stopwatchOrange)
                }
                .frame(width: lockScreenButtonSize, height: lockScreenButtonSize)
            }
            .buttonStyle(.plain)

            if context.state.isRunning {
                Button(intent: LapStopwatchIntent()) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .frame(width: lockScreenButtonSize, height: lockScreenButtonSize)
                }
                .buttonStyle(.plain)
            } else {
                Button(intent: ResetStopwatchIntent()) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .frame(width: lockScreenButtonSize, height: lockScreenButtonSize)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func lockScreenTimerColumn(context: ActivityViewContext<StopwatchAttributes>) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            if context.state.lapCount > 0 {
                lockScreenLapRow(context.state)
            }
            lockScreenPrimaryTimer(context.state)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(stopwatchOrange)
                .monospacedDigit()
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func lockScreenLapRow(_ state: StopwatchAttributes.ContentState) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("LAP \(state.lapCount + 1)")
            lockScreenLapTimer(state)
        }
        .font(.system(size: 14, weight: .semibold, design: .rounded))
        .foregroundStyle(stopwatchOrange)
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }

    @ViewBuilder
    private func lockScreenLapTimer(_ state: StopwatchAttributes.ContentState) -> some View {
        if state.isRunning, let startedAt = state.startedAt {
            let lapStartedAt = startedAt.addingTimeInterval(state.lapMark)
            Text(
                timerInterval: lapStartedAt...lapStartedAt.addingTimeInterval(9 * 60 * 60),
                countsDown: false,
                showsHours: false
            )
            .frame(width: 44, alignment: .trailing)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
        } else {
            Text(StopwatchAttributes.ContentState.formatPadded(state.accumulatedTime - state.lapMark))
        }
    }

    @ViewBuilder
    private func lockScreenPrimaryTimer(_ state: StopwatchAttributes.ContentState) -> some View {
        if state.isRunning, let startedAt = state.startedAt {
            Text(
                timerInterval: startedAt...startedAt.addingTimeInterval(9 * 60 * 60),
                countsDown: false,
                showsHours: false
            )
        } else {
            Text(StopwatchAttributes.ContentState.formatPadded(state.accumulatedTime))
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
            laps: [],
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
            laps: [14, 16],
            lapCount: 2,
            lastLapDuration: 16,
            lapMark: 30
        )
    }

    fileprivate static var paused: StopwatchAttributes.ContentState {
        .init(
            isRunning: false,
            startedAt: nil,
            accumulatedTime: 92.5,
            laps: [20.1, 32.2, 20.1],
            lapCount: 3,
            lastLapDuration: 20.1,
            lapMark: 72.4
        )
    }
}

#Preview("Lock Screen No Lap", as: .content, using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.running
}

#Preview("Lock Screen With Lap", as: .content, using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
    StopwatchAttributes.ContentState.runningWithLaps
}

#Preview("Lock Screen Paused", as: .content, using: StopwatchAttributes.preview) {
    ClockWigetLiveActivity()
} contentStates: {
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
