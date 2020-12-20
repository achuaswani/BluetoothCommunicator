//
//  BluetoothHomeViewController.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/17/20.
//

import UIKit
import UserNotifications

protocol BluetoothHomeViewDelegate {
    func updateUI()
    func showActivityindicator()
    func hideActivityindicator()
    func updateConnectionStateUI()
}

class BluetoothHomeViewController: UIViewController {

    private var bleHomeStackView = UIStackView()
    private var headerLabel = UILabel()
    private var bleTimeLabel = UILabel()
    private var bleConnectionMessageLabel = UILabel()
    private var bleRefreshButton = UIButton()
    private var bleDisconnectButton = UIButton()
    private var viewModel = BluetoothHomeViewModel()
    private var presented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.initiateBLEPermission()
        
        setUpView()
        applyStyle()
        applyContraints()
        updateConnectionStateUI()
    }
    
    private func setUpView() {
        let header = UILabel(frame: .zero)
        header.text = viewModel.bluetoothTime
        header.translatesAutoresizingMaskIntoConstraints = false
        header.numberOfLines = 0
        header.textAlignment = .center
        header.textColor = .black
        header.text = "bluetooth.home.time.text".localized()
        header.font = .boldSystemFont(ofSize: 18)
        headerLabel = header
        
        let label = UILabel(frame: .zero)
        label.text = viewModel.bluetoothTime
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        bleTimeLabel = label
        
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .italicSystemFont(ofSize: 14)
        bleConnectionMessageLabel = messageLabel
        
        let refreshButton = UIButton()
        refreshButton.setTitle(viewModel.refreshButtonTitle, for: .normal)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.normalButton()
        bleRefreshButton = refreshButton
        
        let disconnectButton = UIButton()
        disconnectButton.setTitle(viewModel.diconnectButtonTitle, for: .normal)
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.setTitleColor(.white, for: .normal)
        disconnectButton.addTarget(self, action: #selector(disconnectButtonTapped), for: .touchUpInside)
        disconnectButton.normalButton()
        bleDisconnectButton = disconnectButton
        
        let stackView = UIStackView(
            arrangedSubviews: [
                headerLabel,
                bleTimeLabel,
                bleConnectionMessageLabel,
                bleRefreshButton,
                bleDisconnectButton
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bleHomeStackView = stackView
        view.addSubview(bleHomeStackView)
    }
    
    private func applyStyle() {
        view.backgroundColor = .white
    }
    
    private func applyContraints() {
        NSLayoutConstraint.activate([
            bleHomeStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bleHomeStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            bleHomeStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    @objc private func refreshButtonTapped() {
        viewModel.cancelBLEConnection()
        viewModel.initiateBLEPermission()
    }
    
    @objc private func disconnectButtonTapped() {
        viewModel.cancelBLEConnection()
    }
}

extension BluetoothHomeViewController: BluetoothHomeViewDelegate {
    func updateUI() {
        bleTimeLabel.text = viewModel.bluetoothTime
    }
    
    func showActivityindicator() {
        if !presented {
            let loadingViewController = LoadingViewController()
            loadingViewController.modalPresentationStyle = .overCurrentContext
            loadingViewController.modalTransitionStyle = .crossDissolve
            present(loadingViewController, animated: true, completion: nil)
            presented = true
        }
    }
    
    func hideActivityindicator() {
        if presented {
            dismiss(animated: true, completion: nil)
            presented = false
        }
    }
    
    func updateConnectionStateUI() {
        bleConnectionMessageLabel.text = viewModel.message
        bleConnectionMessageLabel.textColor = viewModel.messageColor
        bleDisconnectButton.isEnabled = viewModel.isDiconnectButtonEnabled
        if viewModel.isDiconnectButtonEnabled {
            bleDisconnectButton.alpha = 1.0
        } else {
            bleDisconnectButton.alpha = 0.5
        }
    }
}
