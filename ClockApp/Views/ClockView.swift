//
//  ClockView.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import SwiftUI

struct ClockView: View {
    @State private var selectedFace: Int = 0
    @State private var stopwatch = StopwatchViewModel()

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                content
                    .frame(minHeight: geo.size.height)
            }
        }
    }

    private var content: some View {
        VStack(spacing: .zero) {
            ClockDisplayView(selection: $selectedFace, stopwatch: stopwatch)

            ControlButtonsView(selection: $selectedFace, stopwatch: stopwatch)

            Divider()
                .padding(.horizontal)

            LapListView(stopwatch: stopwatch)
        }
    }
}

#Preview {
    ClockView()
}
