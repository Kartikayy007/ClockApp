//
//  LapListView.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct LapListView: View {
    let stopwatch: StopwatchViewModel

    private var fastestIndex: Int? {
        stopwatch.laps.count > 1 ? stopwatch.laps.indices.min(by: { stopwatch.laps[$0] < stopwatch.laps[$1] }) : nil
    }

    private var slowestIndex: Int? {
        stopwatch.laps.count > 1 ? stopwatch.laps.indices.max(by: { stopwatch.laps[$0] < stopwatch.laps[$1] }) : nil
    }

    private var showsCurrentLap: Bool {
        stopwatch.isRunning || stopwatch.time() > 0
    }

    var body: some View {
        List {
            if showsCurrentLap {
                if stopwatch.isRunning {
                    TimelineView(.periodic(from: stopwatch.referenceDate, by: 0.01)) { context in
                        lapRow(
                            number: stopwatch.laps.count + 1,
                            duration: stopwatch.currentLap(at: context.date),
                            color: .primary
                        )
                    }
                } else {
                    lapRow(
                        number: stopwatch.laps.count + 1,
                        duration: stopwatch.currentLap(),
                        color: .primary
                    )
                }
            }

            ForEach(Array(stopwatch.laps.enumerated().reversed()), id: \.offset) { index, duration in
                lapRow(number: index + 1, duration: duration, color: color(for: index))
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }

    private func lapRow(number: Int, duration: TimeInterval, color: Color) -> some View {
        HStack {
            Text("Lap \(number)")

            Spacer()

            Text(StopwatchViewModel.format(duration))
                .monospacedDigit()
        }
        .foregroundStyle(color)
    }

    private func color(for index: Int) -> Color {
        if index == fastestIndex { return .green }
        if index == slowestIndex { return .red }
        return .primary
    }
}

#Preview {
    LapListView(stopwatch: StopwatchViewModel())
}
