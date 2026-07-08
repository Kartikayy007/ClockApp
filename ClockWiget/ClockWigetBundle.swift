//
//  ClockWigetBundle.swift
//  ClockWiget
//
//  Created by kartikay on 08/07/26.
//

import WidgetKit
import SwiftUI

@main
struct ClockWigetBundle: WidgetBundle {
    var body: some Widget {
        ClockWiget()
        ClockWigetControl()
        ClockWigetLiveActivity()
    }
}
