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
        HStack {
            Button {
                stopwatch.isRunning ? stopwatch.addLap() : stopwatch.reset()
            } label: {
                Text(stopwatch.isRunning ? "Lap" : "Reset")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundStyle(.gray)
                    .padding(30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())

            }

            Spacer()

            PageIndicatorDots(selection: selection, count: 2)

            Spacer()

            Button {
                stopwatch.toggle()
            } label: {
                Text(stopwatch.isRunning ? "Stop" : "Start")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundStyle(stopwatch.isRunning ? .red : .green)
                    .padding(30)
                    .background((stopwatch.isRunning ? Color.red : Color.green).opacity(0.2))
                    .clipShape(Circle())

            }
        }
        .padding()
        .frame(height: 120)
    }
}

#Preview {
    ControlButtonsView(selection: .constant(0), stopwatch: StopwatchViewModel())
}
