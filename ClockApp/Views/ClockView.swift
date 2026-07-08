//
//  ClockView.swift
//  ClockApp
//
//  Created by kartikay on 07/07/26.
//

import SwiftUI

struct ClockView: View {
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
            ClockDisplayView()

            ControlButtonsView()

            Divider()
                .padding(.horizontal)

            LapListView()
        }
    }
}

private struct ClockDisplayView: View {
    var body: some View {
        VStack {
            Text("00:00.0")
                .font(.system(size: 100, weight: .thin, design: .default))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ControlButtonsView: View {
    var body: some View {
        HStack {
            Button {

            } label: {
                Text("Lap")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundStyle(.gray)
                    .padding(30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())

            }

            Spacer()

            Button {

            } label: {
                Text("Start")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundStyle(.green)
                    .padding(30)
                    .background(Color.green.opacity(0.2))
                    .clipShape(Circle())

            }
        }
        .padding()
        .frame(height: 120)
    }
}

private struct LapListView: View {
    var body: some View {
        List {
            ForEach(0...10, id: \.self) { lap in
                HStack {
                    Text("lap \(lap)")

                    Text("00:00.33")
                }
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
}

#Preview {
    ClockView()
}
