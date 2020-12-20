//
//  BLEServiceManager.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import Foundation
import CoreBluetooth

class BLEServiceManager: NSObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var bleState: CBManagerState {
        return self.centralManager.state
    }
    var updateConnectionState: ((BLEConnectionState) -> Void)?
    var connectionState: BLEConnectionState = .scanningNotStarted {
        didSet {
            updateConnectionState?(connectionState)
        }
    }
    static let shared = BLEServiceManager()
    override init() {
        super.init()
        let key = CBCentralManagerOptionRestoreIdentifierKey
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(), options: [key: AppConstants.restoreIdentifierKey])
    }
    
    func startScan() {
        connectionState = .scanning
        guard centralManager.state == .poweredOn else {
            return
        }
        centralManager.scanForPeripherals(withServices: [BLEServiceIdentifier.serviceUUID], options: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
        connectionState = .scanningStopped
    }
    
    func discoverServices(_ peripheral: CBPeripheral) {
        guard peripheral.name != nil else {
            return
        }
        
        if peripheral.name == BLEServiceIdentifier.deviceName {
            stopScan()
            self.peripheral = peripheral
            peripheral.delegate = self
            self.connect(peripheral)
        }
    }
    
    func connect(_ peripheral: CBPeripheral) {
        guard centralManager.state == .poweredOn else {
            return
        }
       
        centralManager.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey:true, CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
        connectionState = .connecting
    }
    
    func disconnect() {
        guard let peripheral = peripheral else {
            return
        }
        centralManager.cancelPeripheralConnection(peripheral)
    }
}
