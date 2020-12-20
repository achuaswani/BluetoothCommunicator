//
//  BLEServiceManagerHandler.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import Foundation
import CoreBluetooth

extension BLEServiceManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            stopScan()
            disconnect()
        } else{
            switch connectionState {

            case .restoringConnectingPeripheral(let peripheral):
                connect(peripheral)

            case .restoringConnectedPeripheral(let peripheral):
                discoverServices(peripheral)
            default:
                break
           }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoverServices(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            peripheral.discoverServices(
                [
                    BLEServiceIdentifier.dataCharactericUUID,
                    BLEServiceIdentifier.serviceUUID
                ]
            )
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard  connectionState != .userDisconnected else {
            return
        }
        
        if let error = error {
            connectionState = .disconnected(error.localizedDescription)
        } else {
            connectionState = .disconnected(nil)
        }
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionState = .failed
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        let peripherals: [CBPeripheral] = dict[
                    CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] ?? []
        if let peripheral = peripherals.first {
            self.peripheral = peripheral
            switch peripheral.state {
            case .connecting:
                connectionState = .restoringConnectingPeripheral(peripheral)
            case .connected:
                connectionState = .restoringConnectedPeripheral(peripheral)
            default: break
            }
        }
    }

}
