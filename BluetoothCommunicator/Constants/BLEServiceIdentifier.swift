//
//  BLEServiceIdentifier.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import Foundation
import CoreBluetooth

struct BLEServiceIdentifier {
    static let deviceName = "IP84"
    static let serviceUUID = CBUUID.init(string: "1805")
    static let dataCharactericUUID = CBUUID.init(string: "2A2B")
}
