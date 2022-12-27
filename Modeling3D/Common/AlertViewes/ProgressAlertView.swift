//
//  ProgressAlertView.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 27.12.2022.
//

import UIKit
import Modeling3dKit

final class ProgressAlertView: NSObject {
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
    
    private lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()
    
    private lazy var completeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.maskedCorners  =  [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.blue()
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private var alertTitle: String
    private var isUpload: Bool
    private var taskId: String
    
    var deleteActionForUpload: VoidHandler?
    
    init(on viewController: UIViewController, alertTitle: String, isUpload: Bool, taskId: String) {
        self.alertTitle = alertTitle
        self.isUpload = isUpload
        self.taskId = taskId
        
        super.init()
        self.targetView = viewController.view
        self.applyConstraints()
    }
    
    private func applyConstraints() {
        targetView.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(progressBar)
        alertView.addSubview(completeLabel)
        alertView.addSubview(cancelButton)
        
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        self.alertView.centerXAnchor.constraint(equalTo: self.targetView.centerXAnchor).isActive = true
        self.alertView.centerYAnchor.constraint(equalTo: self.targetView.centerYAnchor).isActive = true
        self.alertView.heightAnchor.constraint(equalTo: self.targetView.heightAnchor, multiplier: 0.2).isActive = true
        self.alertView.widthAnchor.constraint(equalTo: self.targetView.widthAnchor, multiplier: 0.7).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        self.progressBar.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: 20).isActive = true
        self.progressBar.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor, constant: -20).isActive = true
        self.progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.completeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.completeLabel.topAnchor.constraint(equalTo: self.progressBar.bottomAnchor, constant: 20).isActive = true
        self.completeLabel.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor).isActive = true
        self.completeLabel.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor).isActive = true
        self.completeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.topAnchor.constraint(equalTo: self.completeLabel.bottomAnchor, constant: 20).isActive = true
        self.cancelButton.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor).isActive = true
        self.cancelButton.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor).isActive = true

    }
    
    @objc private func didTapCancelButton() {
        if (!isUpload) { //false
           Modeling3dReconstructTask.sharedManager().cancelDownloadTask(withTaskId: taskId) { retCode, retMsg in
               print("cancelDownloadTask retCode:", retCode)
               print("cancelDownloadTask retMsg:", retMsg)
               self.removeAlertView()
           }
       } else { //true
           Modeling3dReconstructTask.sharedManager().cancelUploadTask(withTaskId: taskId) { retCode, retMsg in
               print("cancelUploadTask retCode:", retCode)
               print("cancelUploadTask retMsg:", retMsg)
               self.deleteActionForUpload?()
               self.removeAlertView()
           }
       }
    }
    
    func updateProgress(progressValue: Float) {
        self.progressBar.setProgress(progressValue, animated: true)
        self.completeLabel.text = "Completed: %" + String((progressValue * 100).rounded())
    }
    
    func removeAlertView() {
        self.alertView.removeFromSuperview()
    }
}
