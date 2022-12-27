//
//  PreviewViewController.swift
//  Modeling3D
//
//  Created by Cagla Canitez on 27.12.2022.
//

import UIKit
import SceneKit

final class PreviewViewController: UIViewController {
    private lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(x: 0, y: 10, z: 35)
        return node
    }()
    
    private lazy var lightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .omni
        node.position = SCNVector3(x: 0, y: 10, z: 35)
        return node
    }()
    
    private lazy var ambientLightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .ambient
        node.light?.color = UIColor.white
        return node
    }()
    
    private lazy var scene: SCNScene = {
        let scene = try! SCNScene(url: self.modelURL)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(ambientLightNode)
        return scene
    }()
    
    private lazy var sceneView: SCNView = {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .white
        sceneView.cameraControlConfiguration.allowsTranslation = false
        sceneView.scene = self.scene
        return sceneView
    }()
    
    var modelURL: URL
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyConstraints()
    }
    
    init(modelURL: URL) {
        self.modelURL = modelURL
        super.init(nibName: nil, bundle: nil)
    }
    
    private func applyConstraints() {
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        self.view.addSubview(self.sceneView)
        
        self.sceneView.translatesAutoresizingMaskIntoConstraints = false
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
