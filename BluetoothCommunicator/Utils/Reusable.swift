//
//  Reusables.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import UIKit

func async(deadline: Double = 0.5, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
          closure()
     }
}

extension Numeric {
    init<D: DataProtocol>(_ data: D) {
        var value: Self = .zero
        let size = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        assert(size == MemoryLayout.size(ofValue: value))
        self = value
    }
}

extension DataProtocol {
    func value<N: Numeric>() -> N { .init(self) }
    var uint16: UInt16 { value() }
}

extension UIButton {
    func normalButton() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = UIColor(red: 88.0/255.0, green: 199.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        contentMode = .scaleAspectFit
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        showsTouchWhenHighlighted = true
    }
}
