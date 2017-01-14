//
//  GameViewController.swift
//  Basketball
//
//  Created by Dean Sponholz on 5/30/16.
//  Copyright (c) 2016 Dean Sponholz. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    //! means were promising we will initialize "scene"
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure the view
        let skView = view as! SKView
        //If finger is on iphone, you cant tap again
        skView.multipleTouchEnabled = false
        //skView.showsPhysics = true
        
        //Create and configure the scene
        //create scene within size of skview
        scene = GameScene(size:CGSize(width: 2048, height: 1536))

        //http://stackoverflow.com/questions/37197981/universal-app-background-spritekit
        scene.scaleMode = .Fill
        //scene.anchorPoint = CGPointZero
        
        //present the scene
        skView.presentScene(scene)
        
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else {
            return .Landscape
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
