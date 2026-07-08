//
//  DigitalClockFace.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct DigitalClockFace: View {
    let stopwatch: StopwatchViewModel

    var body: some View {
        Group {
            if stopwatch.isRunning {
                TimelineView(.periodic(from: stopwatch.referenceDate, by: 0.01)) { context in
                    Text(StopwatchViewModel.format(stopwatch.time(at: context.date)))
                }
            } else {
                Text(StopwatchViewModel.format(stopwatch.time()))
            }
        }
        .font(.system(size: 90, weight: .thin, design: .default))
        .monospacedDigit()
    }
}

#Preview {
    DigitalClockFace(stopwatch: StopwatchViewModel())
}
