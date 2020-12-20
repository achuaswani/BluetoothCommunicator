//
//  BLEConnectionState.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/19/20.
//

import Foundation
import CoreBluetooth

enum BLEConnectionState: Equatable {
    case scanningNotStarted
    case scanningStopped
    case failed
    case disconnected(String?)
    case userDisconnected
    case bluetoothFailure
    case bluetoothPermissionChecking
    case scanning
    case connecting
    case discoveringServices
    case discoveringCharacteristics
    case connected
    case restoringConnectingPeripheral(CBPeripheral)
    case restoringConnectedPeripheral(CBPeripheral)
}
