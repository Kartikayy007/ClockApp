//
//  AnalogClockFace.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct AnalogClockFace: View {
    let stopwatch: StopwatchViewModel

    private let majorValues = [60, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    private let appleOrange = Color(red: 1.0, green: 149.0 / 255.0, blue: 0)
    private let tickWidth: CGFloat = 2.0

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2

            ZStack {
                ForEach(0..<240, id: \.self) { tick in
                    tickMark(index: tick, radius: radius)
                }

                ForEach(majorValues, id: \.self) { value in
                    numberLabel(value: value, radius: radius * 0.68)
                }

                handAndReadout(radius: radius)
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    @ViewBuilder
    private func handAndReadout(radius: CGFloat) -> some View {
        if stopwatch.isRunning {
            TimelineView(.periodic(from: stopwatch.referenceDate, by: 0.01)) { context in
                content(for: stopwatch.time(at: context.date), radius: radius)
            }
        } else {
            content(for: stopwatch.time(), radius: radius)
        }
    }

    private func content(for elapsed: TimeInterval, radius: CGFloat) -> some View {
        let angle = elapsed.truncatingRemainder(dividingBy: 60) / 60 * 360

        return ZStack {
            secondHand(radius: radius)
                .rotationEffect(.degrees(angle))

            Text(StopwatchViewModel.format(elapsed))
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white)
                .monospacedDigit()
                .offset(y: radius * 0.22)
        }
    }

    private func secondHand(radius: CGFloat) -> some View {
        let needleLength = radius - 6
        let tailLength = radius * 0.08

        return ZStack {
            Rectangle()
                .fill(appleOrange)
                .frame(width: tickWidth, height: needleLength)
                .offset(y: -needleLength / 2)

            Rectangle()
                .fill(appleOrange)
                .frame(width: tickWidth, height: tailLength)
                .offset(y: tailLength / 2)

            Circle()
                .stroke(appleOrange, lineWidth: tickWidth)
                .frame(width: 8, height: 8)
        }
    }

    private func tickMark(index: Int, radius: CGFloat) -> some View {
        let isMajor = index % 20 == 0
        let isSecondary = index % 4 == 0 && !isMajor
        let bigLength = radius * 0.09   
        let smallLength = bigLength / 2
        let length = isMajor || isSecondary ? bigLength : smallLength
        let color: Color = isMajor ? .white : Color.gray.opacity(0.45)

        return Rectangle()
            .fill(color)
            .frame(width: tickWidth, height: length)
            .offset(y: -radius + length / 2 + 6 )
            .rotationEffect(.degrees(Double(index) / 240 * 360))
    }

    private func numberLabel(value: Int, radius: CGFloat) -> some View {
        let angle = Double(value) / 60 * 2 * .pi
        let x = radius * sin(angle)
        let y = -radius * cos(angle)

        return Text("\(value)")
            .font(.system(size: 22, weight: .medium))
            .foregroundStyle(.white)
            .offset(x: x, y: y)
    }
}

#Preview {
    AnalogClockFace(stopwatch: StopwatchViewModel())
}
