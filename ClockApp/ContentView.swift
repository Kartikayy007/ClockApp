//
//  ContentView.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var isRunning = false
    @State private var timerCancellable: AnyCancellable?

    @State private var startTime: Date?

    private func toggleClock() {
        isRunning.toggle()

        if isRunning {
            startTime = Date().addingTimeInterval(-elapsedTime)

            timerCancellable = Timer.publish(every: 0.01, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    if let startTime = startTime {
                        self.elapsedTime = Date().timeIntervalSince(startTime)
                    }
                }
        } else {
            timerCancellable?.cancel()
            timerCancellable = nil
        }
    }

    private func resetClock() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
        elapsedTime = 0.0
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)

        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }

    var body: some View {
        VStack(spacing: 132) {

            Text(formatTime(elapsedTime))
                .font(.system(size: 80, weight: .light, design: .default))

            HStack {
                Button {
                    resetClock()
                } label: {
                    Text("Reset")
                        .font(.headline)
                        .bold()
                        .padding(32)
                        .background(Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }

                Spacer()

                Button(action: toggleClock) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.headline)
                        .bold()
                        .padding(32)
                        .background(isRunning ? Color.red.opacity(0.3) : Color.green.opacity(0.3))
                        .foregroundStyle(isRunning ? .red : .green)
                        .clipShape(Circle())
                }

            }.foregroundStyle(.primary)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    ContentView()
}
