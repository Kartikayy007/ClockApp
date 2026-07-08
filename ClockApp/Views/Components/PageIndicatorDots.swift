//
//  PageIndicatorDots.swift
//  ClockApp
//
//  Created by kartikay on 08/07/26.
//

import SwiftUI

struct PageIndicatorDots: View {
    let selection: Int
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == selection ? Color.white : Color.gray.opacity(0.4))
                    .frame(width: 6, height: 6)
                    .animation(.easeInOut(duration: 0.25), value: selection)
            }
        }
    }
}

#Preview {
    PageIndicatorDots(selection: 0, count: 2)
}
