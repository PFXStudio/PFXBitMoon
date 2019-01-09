//
//  HistoryData.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 14..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit

class HistoryData: NSObject {
    var time = 0.0
    var close = 0.0
    var high = 0.0
    var low = 0.0
    var open = 0.0
    var volumeFrom = 0.0
    var volumeTo = 0.0

    init(time: Double, close: Double, high: Double, low: Double, open: Double, volumeFrom: Double, volumeTo: Double) {
        self.time = time
        self.close = close
        self.high = high
        self.low = low
        self.open = open
        self.volumeFrom = volumeFrom
        self.volumeTo = volumeTo
    }
}
