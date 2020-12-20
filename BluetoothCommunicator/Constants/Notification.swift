//
//  BLENotification.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/18/20.
//

import Foundation

struct BLENotification {
    static let dateTimeUpdate = NSNotification.Name(rawValue: "DateTimeData")
    static let connectionUpdate = NSNotification.Name(rawValue: "ConnectionUpdate")
}
