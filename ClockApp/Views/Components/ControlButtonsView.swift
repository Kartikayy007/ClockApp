//
//  ControlButtonsView.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct ControlButtonsView: View {
    @Binding var selection: Int
    let stopwatch: StopwatchViewModel

    var body: some View {
        let isLapOrResetEnabled = stopwatch.isRunning || stopwatch.time() > 0

        ZStack {
            HStack {
                Button {
                    if stopwatch.isRunning {
                        stopwatch.addLap()
                    } else if isLapOrResetEnabled {
                        stopwatch.reset()
                    }
                } label: {
                    Text(stopwatch.isRunning ? "Lap" : "Reset")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundStyle(isLapOrResetEnabled ? .white : .gray)
                        .frame(width: 80, height: 80)
                        .background((isLapOrResetEnabled ? Color.gray.opacity(0.35) : Color.gray.opacity(0.2)))
                        .clipShape(Circle())

                }

                Spacer()

                Button {
                    stopwatch.toggle()
                } label: {
                    Text(stopwatch.isRunning ? "Stop" : "Start")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundStyle(stopwatch.isRunning ? .red : .green)
                        .frame(width: 80, height: 80)
                        .background((stopwatch.isRunning ? Color.red : Color.green).opacity(0.2))
                        .clipShape(Circle())

                }
            }

            PageIndicatorDots(selection: selection, count: 2)
        }
        .padding()
        .frame(height: 120)
    }
}

#Preview {
    ControlButtonsView(selection: .constant(0), stopwatch: StopwatchViewModel())
}
