//
//  CountDown.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/19/20.
//

import Foundation

class Countdown {
    let timer: Timer
    
    init(seconds: TimeInterval, closure: @escaping () -> ()) {
        timer = Timer.scheduledTimer(withTimeInterval: seconds,
                repeats: false, block: { _ in
            closure()
        })
    }
    
    deinit {
        timer.invalidate()
    }
}
