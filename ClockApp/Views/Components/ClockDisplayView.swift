//
//  ClockDisplayView.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct ClockDisplayView: View {
    @Binding var selection: Int
    let stopwatch: StopwatchViewModel

    var body: some View {
        TabView(selection: $selection) {
            DigitalClockFace(stopwatch: stopwatch).tag(0)
            AnalogClockFace(stopwatch: stopwatch).tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ClockDisplayView(selection: .constant(0), stopwatch: StopwatchViewModel())
}
