//
//  Model3DViewCell.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 26.12.2022.
//

import UIKit

final class Model3DViewCell: UICollectionViewCell, Model3dDelegate {
    private lazy var model3DStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var modelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 9
        return imageView
    }()
    
    private lazy var modelNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.text()
        label.text = "Product"
        return label
    }()
    
    private lazy var modelPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.text()
        label.text = "30$"
        return label
    }()
    
    let icon = (UIImage(systemName: "ellipsis.circle.fill")!.withTintColor(UIColor.blue(), renderingMode: .alwaysOriginal))
    
    private lazy var popupMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(icon, for: .normal)
        return button
    }()
    
    private var controller = UIViewController()
    
    var viewModel: Model3dViewModel! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    func configurecell(image: UIImage, viewController: UIViewController){
        modelImageView.image = image
        self.controller = viewController
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyConstraints()
    }
    
    private func applyConstraints() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 9
        
        addSubview(self.model3DStackView)
        self.model3DStackView.addArrangedSubview(self.modelImageView)
        self.model3DStackView.addArrangedSubview(self.modelNameLabel)
        self.model3DStackView.addArrangedSubview(self.modelPriceLabel)
        
        let query = UIAction(title: "Query", image: nil) { (action) in
            self.viewModel.query(viewController: self.controller)
         }

         let download = UIAction(title: "Download", image: nil) { (action) in
             self.viewModel.download(viewController: self.controller)
         }
        
        let delete = UIAction(title: "Delete", image: nil) { (action) in
            self.viewModel.delete()
        }

        let menu = UIMenu(options: .displayInline, children: [query, download, delete])
        self.popupMenuButton.menu = menu
        self.popupMenuButton.showsMenuAsPrimaryAction = true
        
        addSubview(self.popupMenuButton)
        
        self.model3DStackView.translatesAutoresizingMaskIntoConstraints = false
        self.model3DStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.model3DStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.model3DStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.model3DStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        self.modelNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.modelPriceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.popupMenuButton.translatesAutoresizingMaskIntoConstraints = false
        self.popupMenuButton.bottomAnchor.constraint(equalTo: self.model3DStackView.bottomAnchor, constant: -5).isActive = true
        self.popupMenuButton.trailingAnchor.constraint(equalTo: self.model3DStackView.trailingAnchor).isActive = true
    }
    
//    func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "alert.click".localize, style: UIAlertAction.Style.default, handler: nil))
//        self.showDetailViewController(alert, sender: self)
//    }
    
}
