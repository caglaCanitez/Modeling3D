//
//  ActivityIndicatorAlertView.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 27.12.2022.
//

import Foundation
import UIKit

final class ActivityIndicatorAlertView: NSObject {
    private lazy var targetView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.alertTitle
        label.textAlignment = .center
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.blue()
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private var alertTitle: String
    
    var cancelAction: VoidHandler?
    
    init(on viewController: UIViewController, alertTitle: String) {
        self.alertTitle = alertTitle
        
        super.init()
        self.targetView = viewController.view
        self.applyConstraints()
        self.activityIndicator.startAnimating()
    }
    
    private func applyConstraints() {
        targetView.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(activityIndicator)
        alertView.addSubview(cancelButton)
        
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        self.alertView.centerXAnchor.constraint(equalTo: self.targetView.centerXAnchor).isActive = true
        self.alertView.centerYAnchor.constraint(equalTo: self.targetView.centerYAnchor).isActive = true
        self.alertView.heightAnchor.constraint(equalTo: self.targetView.heightAnchor, multiplier: 0.15).isActive = true
        self.alertView.widthAnchor.constraint(equalTo: self.targetView.widthAnchor, multiplier: 0.7).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor).isActive = true
        
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: 20).isActive = true
        self.cancelButton.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor).isActive = true
        
    }
    
    func removeAlertView() {
        self.activityIndicator.stopAnimating()
        self.alertView.removeFromSuperview()
    }
    
    @objc private func didTapCancelButton() {
        cancelAction?()
        self.removeAlertView()
    }
}
