//
//  BluetoothHomeViewModel.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import UIKit
import CoreBluetooth

protocol BluetoothHomeViewModelType {
    var delegate: BluetoothHomeViewDelegate? { get set }
}

class BluetoothHomeViewModel: BluetoothHomeViewModelType {
    private let bleServiceManager = BLEServiceManager.shared
    var delegate: BluetoothHomeViewDelegate?
    var refreshButtonTitle = "bluetooth.home.refresh.button.title".localized()
    var diconnectButtonTitle = "bluetooth.home.connection.disconnect".localized()
    var isDiconnectButtonEnabled = false
    var message = ""
    var messageColor: UIColor = .black
    var bluetoothPermissionCheckCounter = 0
    var notificationManager = LocalNotificationManager()
    
    private var counter: Int = 1 {
        didSet {
            hideActivityIndicatorOnTimeout()
        }
    }
    var bluetoothTime = "" {
        didSet {
            presentBluetoothTime()
        }
    }
    
    var connectionState = BLEServiceManager.shared.connectionState {
        didSet {
            presentConnectionState()
        }
    }
    
    init() {
        subscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setBluetoothTime(_:)),
            name: BLENotification.dateTimeUpdate,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setConnectionState(_:)),
            name: BLENotification.connectionUpdate,
            object: nil
        )
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(BLENotification.dateTimeUpdate)
        NotificationCenter.default.removeObserver(BLENotification.connectionUpdate)
    }
    
    deinit {
        unsubscribe()
    }
    
    func initiateBLEPermission() {
        async { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.showActivityindicator()
            self.connectionState = .bluetoothPermissionChecking
            self.hideActivityIndicatorOnTimeout()
            self.checkBLEState()
        }
    }
    
    func checkBLEState() {
        if bleServiceManager.bleState != .poweredOn {
            async(deadline: 2) {
                self.bluetoothPermissionCheckCounter += 1
                self.checkBLEState()
            }
            
            if bluetoothPermissionCheckCounter >= 15 {
                connectionStateValues()
            }
        } else {
            waitForPeripheral()
        }
    }
    
    func waitForPeripheral() {
        bleServiceManager.startScan()
    }
    
    func hideActivityIndicatorOnTimeout() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.counter >= 30 {
                timer.invalidate()
                async { [weak self] in
                    self?.delegate?.hideActivityindicator()
                }
            }
            self.counter += 1
        }
    }
    
    func cancelBLEConnection() {
        bleServiceManager.stopScan()
        bleServiceManager.disconnect()
        bleServiceManager.connectionState = .userDisconnected
    }
    
    @objc private func setBluetoothTime(_ notification: Notification) {
        if let dateTime = notification.object as? String{
            bluetoothTime = dateTime
            notificationManager.postNotification(notificationType: dateTime)
        }
    }
    
    @objc private func setConnectionState(_ notification: Notification) {
        self.presentConnectionState()
    }
    
    func presentBluetoothTime() {
        async { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.updateUI()
        }
    }
    
    func presentBluetoothConnectionState() {
        async { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.updateConnectionStateUI()
        }
    }
    
    func presentConnectionState() {
        connectionStateValues()
        counter = 30
    }
    
    func connectionStateValues() {
        BLEServiceManager.shared.updateConnectionState = { [weak self] connectionState in
            guard let self = self else {
                return
            }
            self.setConnectionStateChanges(connectionState)
            self.presentBluetoothConnectionState()
        }
    }
    
    // Change the message, messasge color and button state according to the connection state
    func setConnectionStateChanges(_ connectionState: BLEConnectionState) {
        switch  connectionState {
        case .bluetoothPermissionChecking:
            message = "connection.bluetooth.checking.permission".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        case .bluetoothFailure:
            message = "connection.bluetooth.not.powered.on".localized()
            messageColor = .red
            isDiconnectButtonEnabled = false
        case .failed:
            message = "error.connection.failure".localized()
            messageColor = .red
            isDiconnectButtonEnabled = false
            notificationManager.postNotification(notificationType: message)
        case .disconnected(let error):
            if let error = error {
                message = error
            }else {
                message = "connection.state.disconnected".localized()
            }
            messageColor = .black
            isDiconnectButtonEnabled = false
            notificationManager.postNotification(notificationType: message)
        case .userDisconnected:
            message = "connection.state.user.disconnected".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        case .scanning:
            message = "connection.state.scanning.started".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        case .scanningStopped:
            message = "connection.state.scanning.stopped".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        case .scanningNotStarted:
            message = "connection.state.scanning.not.started".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        case .connected:
            message = "connection.state.connected".localized()
            messageColor = .black
            isDiconnectButtonEnabled = true
        case .connecting,
            .restoringConnectingPeripheral,
            .restoringConnectedPeripheral,
            .discoveringServices,
            .discoveringCharacteristics:
            message = "connection.state.connecting".localized()
            messageColor = .black
            isDiconnectButtonEnabled = false
        }
    }
}
