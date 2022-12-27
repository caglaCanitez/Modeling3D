//
//  HomeViewController.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 26.12.2022.
//

import UIKit
import PhotosUI
import Modeling3dKit

final class HomeViewController: UIViewController, PHPickerViewControllerDelegate, Model3dDelegate {
    let icon = (UIImage(systemName: "plus")!.withTintColor(UIColor.purple(), renderingMode: .alwaysOriginal))
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(Model3DViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private lazy var addNewPhotosButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue()
        button.layer.cornerRadius = 30
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(pickPhotos), for: .touchUpInside)
        return button
    }()
    
    private var imageSet = [[UIImage]]()
    
    var viewModel: Model3dViewModel! {
        didSet {
            viewModel.delegate = self
            viewModel.actionTableReload = {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getListData()
    }
    
    private func applyConstraints() {
        self.view.backgroundColor = UIColor.background()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.modalPresentationStyle = .fullScreen
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.addNewPhotosButton)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        self.addNewPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        self.addNewPhotosButton.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: -15).isActive = true
        self.addNewPhotosButton.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor, constant: -5).isActive = true
        self.addNewPhotosButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addNewPhotosButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    @objc func pickPhotos(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 200
        config.filter = PHPickerFilter.images
        config.preferredAssetRepresentationMode = .current
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()
        
        results.forEach { result in
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                defer {
                    dispatchGroup.leave()
                }
                guard let image = object as? UIImage, error == nil else {
                    return
                }
                images.append(image)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.imageSet.append(images)
            self.collectionView.reloadData()
            self.model3dUpload()
        }
    }
    
    func model3dUpload() {
        self.viewModel.upload(imageSet: self.imageSet[0], viewController: self)
    }
    
    func getListData() {
        self.viewModel.model.removeAll()
        let storedModel = Modeling3dReconstructTask.sharedManager().getLocationFileArray()
        if let models = storedModel as? [Modeling3dReconstructTaskModel] {
            self.viewModel.model.append(contentsOf: models)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.1, height: collectionView.frame.height/3)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                            for: indexPath) as? Model3DViewCell else { return UICollectionViewCell() }
        let image = Modeling3dReconstructTask.sharedManager().getCoverImage(withTaskId: self.viewModel.model[indexPath.row].taskId)
        cell.configurecell(image: image, viewController: self)
        viewModel.currentCellIndex = indexPath.row
        cell.viewModel = viewModel

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.preview()
        let preview = PreviewViewController(modelURL: self.viewModel.modelURL[indexPath.row])
        self.show(preview, sender: self)

    }
}
