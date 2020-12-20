//
//  Strings+Extension.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import Foundation

extension String {
     public func localized(withValue value: String = "") -> String {
        return String(format: NSLocalizedString(self, comment: "" ), value)
    }
}
