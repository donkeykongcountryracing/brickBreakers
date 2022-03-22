//
//  GameViewController.swift
//  brickBreakers
//
//  Created by Ethan  Jin  on 2/9/2021.
//

import UIKit
import SpriteKit
import GameplayKit

var screenSize = CGSize()

class GameViewController: UIViewController {
    var scene1: GameScene?
    var scene2: GameScene?
    var skView: SKView?
    
//    @IBAction func nextSceneAction(sender: AnyObject) {
//
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene2 = SKScene(fileNamed: "GameScene") {
//                //        scene2 = GameScene(fileNamed:"GameScene")
//                // Present scene2 object that replace the scene1 object
//
//                scene1 = nil
//                scene2.scaleMode = .aspectFit
//                view.presentScene(scene2)
//            }
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene1 = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene1.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene1)
            }
            
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
