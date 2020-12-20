//
//  BLEEventsHandler.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import Foundation
import CoreBluetooth

extension BLEServiceManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            let serviceUUID = service.uuid
            
            if serviceUUID == BLEServiceIdentifier.serviceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let charateristics = service.characteristics else {
            return
        }
        
        for characteristic in charateristics {
            let characteristicUUID = characteristic.uuid
            if characteristicUUID == BLEServiceIdentifier.dataCharactericUUID {
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateNotificationStateFor characteristic: CBCharacteristic,
                     error: Error?) {        
        if error != nil {
            print("Enable notify error")
        }
    }
    
    func readDateTime(timeData: [UInt8]) -> String {
        let timeDate = DateComponents(calendar: .current,
                                       timeZone: .current,
                                       year: Int(timeData[0..<2].uint16),
                                       month: Int(timeData[2]),
                                       day: Int(timeData[3]),
                                       hour: Int(timeData[4]),
                                       minute: Int(timeData[5]),
                                       second: Int(timeData[6])).date!
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
        let date = format.string(from: timeDate)
        return date
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error?) {
        if(characteristic.uuid == BLEServiceIdentifier.dataCharactericUUID ),
          let dateTime = characteristic.value {
            let timedate = readDateTime(timeData: [UInt8](dateTime))
            connectionState = .connected
            NotificationCenter.default.post(name: BLENotification.dateTimeUpdate, object: timedate)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
      peripheral.discoverServices(nil)
    }
}
