//
//  ViewController.swift
//  Tracked Images
//
//  Created by Tony Morales on 6/13/18.
//  Copyright © 2018 Tony Morales. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

@objc class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var appView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var magicSwitch: UISwitch!
    @IBOutlet weak var blurView: UIVisualEffectView!
  
    var configuration: ARImageTrackingConfiguration?
    var videoUrl: URL?
    var imageMaps: [String:URL] = [:]
    var videoMaps: [String:URL] = [:]
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    /// A serial queue for thread safety when modifying the SceneKit node graph.
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        magicSwitch.setOn(false, animated: false)
    
        // Hook up status view controller callback(s).
          statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
      
        UIApplication.shared.isIdleTimerDisabled = true
      
        // Add REACT NATIVE root view.
        let rnView = (UIApplication.shared.delegate as! AppDelegate).rootView
        rnView?.frame = appView.bounds
        appView.addSubview(rnView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Session management (Image detection setup)
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    @IBAction func switchOnMagic(_ sender: Any) {
        let configuration = ARImageTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = imageMaps.count
      
        let referenceImages = Set(imageMaps.map { key, value -> ARReferenceImage in
            let imageData: Data = try! Data(contentsOf: value)
            let image = UIImage(data: imageData, scale: UIScreen.main.scale)
            let cgImage = image!.cgImage
          
            let referenceImage = ARReferenceImage.init(cgImage!, orientation: .up, physicalWidth: 0.595)
            referenceImage.name = key
          
            return referenceImage
        })
      
        configuration.trackingImages = referenceImages
      
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    /// Creates a new AR configuration to run on the `session`.
    /// - Tag: ARReferenceImage-Loading
    func resetTracking() {
        let configuration = ARImageTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Image Tracking Results
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // Show video overlaid on image
        if let imageAnchor = anchor as? ARImageAnchor {
            // Create a plane
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
          
            guard let videoUrl = self.videoMaps[imageAnchor.referenceImage.name!] else {return node}
          
            let videoPlayer = AVPlayer(url: videoUrl)
            plane.firstMaterial?.diffuse.contents = videoPlayer
            videoPlayer.play()
            
            let planeNode = SCNNode(geometry: plane)
            
            // Rotate the plane to match the anchor
            planeNode.eulerAngles.x = -.pi / 2
            
            // Add plane node to parent
            node.addChildNode(planeNode)
        }
        
        return node
    }
}

extension ViewController {
  @objc func setNewMappingWith(picture:String, andVideo:String) -> Void {
    let uuid = UUID.init().description
    
    self.imageMaps[uuid] = URL(fileURLWithPath: picture);
    self.videoMaps[uuid] = URL(fileURLWithPath: andVideo);
  }
}
