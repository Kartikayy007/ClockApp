//
//  ContentView.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var stopwatch = StopwatchViewModel()

    var body: some View {
        ClockView(stopwatch: stopwatch)
    }
}

#Preview {
    ContentView()
}
