//
//  LoadinViewController.swift
//  BluetoothCommunicator
//
//  Created by Aswani G on 12/18/20.
//

import UIKit

class LoadingViewController: UIViewController {
    var loadingActivityIndicator = UIActivityIndicatorView()
    var blurEffectView = UIVisualEffectView()
    var loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpStyle()
    }
    
    func setUpView() {
        let indicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            indicator.style = .large
            indicator.color = .white
        }
        indicator.startAnimating()
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        loadingActivityIndicator = indicator
        
        let label = UILabel()
        label.text = "Scanning.."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        loadingLabel = label
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
    }
    
    func setUpStyle() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        loadingLabel.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY+30
        )
        view.addSubview(loadingActivityIndicator)
        view.addSubview(loadingLabel)
    }
}
