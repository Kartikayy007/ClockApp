//
//  ClockView.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import SwiftUI

struct ClockView: View {
    @Bindable var stopwatch: StopwatchViewModel
    @State private var selectedFace: Int = 0

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: .zero) {
                    ClockDisplayView(selection: $selectedFace, stopwatch: stopwatch)

                    ControlButtonsView(selection: $selectedFace, stopwatch: stopwatch)

                    Divider()
                        .padding(.horizontal)

                    LapListView(stopwatch: stopwatch)
                }
                .frame(minHeight: geo.size.height, alignment: .top)
            }
        }
    }
}

#Preview {
    ClockView(stopwatch: StopwatchViewModel())
}
