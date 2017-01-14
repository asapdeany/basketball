//
//  GameScene.swift
//  Basketball
//
//  Created by Dean Sponholz on 5/30/16.
//  Copyright (c) 2016 Dean Sponholz. All rights reserved.
//http://stackoverflow.com/questions/27216528/how-to-drag-and-release-an-object-with-velocity
//http://stackoverflow.com/questions/28245653/how-to-throw-skspritenode
//http://stackoverflow.com/questions/30395057/throwing-an-object-with-spritekit
//https://gist.github.com/johnlinvc/bdf61305b74305079d3bae198b09e0b2

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /////////////////////////////////////////////////////////////////////////////
    //NodeVariables                                                            //
    var background = SKSpriteNode()
    var score = 0//
    var scoreLabel = SKLabelNode()
    var players = ["Steve Kerr", "Kyle Korver", "Ray Allen", "Klay Thomson", "Michael Jordan", "Steph Curry"]
    var steveKerr = SKSpriteNode()
    var ground = SKSpriteNode()
    var rim1 = SKSpriteNode()                                                  //
    var rim2 = SKSpriteNode()                                                  //
    var rimNet = SKSpriteNode()                                                //
    var ball: SKSpriteNode!                                                    //
    //PhysicsVariables
    
    var touchingPoint: CGPoint = CGPoint()
    var touching: Bool = false
    var selectedNode:SKSpriteNode?
    struct TouchInfo {
        var location:CGPoint
        var time:NSTimeInterval
    }
    
    var randomPoint = CGPoint()
    //var touch = UITouch()
    var sceneBody = SKPhysicsBody()                                            //
    var died: Bool = false
    let None: UInt32 = 0
    let ballCategory: UInt32 = 0x1 << 0                                        //
    let rim1Category: UInt32 = 0x1 << 1                                        //
    let rim2Category: UInt32 = 0x1 << 2
    let rimNetCategory: UInt32 = 0x1 << 3
    let groundCategory: UInt32 = 0x1 << 4           //
    /////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////
    func loadAppearance_background(){                                          //
        background = SKSpriteNode(imageNamed: "Background")                    //
        background.size = self.frame.size                                      //
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0                                               //
                                                    //
    }                                                                          //
    /////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    func loadAppearance_scoreLabel(){                                         //
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")                    //
        scoreLabel.text = "0"                                                 //
        scoreLabel.fontSize = 175
        scoreLabel.fontColor = SKColor.orangeColor()                          //
        scoreLabel.position = CGPointMake(((self.frame.size.width * 0.1)), (self.frame.size.height / 1.25))
        
    }
    ////////////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////////////
    func loadAppearance_players(){                                            //
        //steveKerr = SKSpriteNode(imageNamed: "Steve")                       //
        steveKerr = SKSpriteNode(color: UIColor.magentaColor(), size: CGSizeMake((self.frame.size.width) / 15, (self.frame.size.width) / 10))
        steveKerr.position = CGPointMake(((self.frame.size.width) / 1.36), (self.frame.size.height / 1.15))
        steveKerr.anchorPoint = CGPointMake(0.5, 0.5)
        steveKerr.zPosition = 0
                                                                              //
    }                                                                         //
    ////////////////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////////////////
    func loadAppearance_ground(){
        ground = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake((self.frame.size.width), (self.frame.size.width) / 125))
        ground.position = CGPointMake(self.frame.size.width/2, self.frame.size.height / 190)
        ground.anchorPoint = CGPointMake(0.5, 0.5)
        ground.zPosition = 1
        let groundPhysicsSize = CGSizeMake(self.frame.size.width, self.frame.size.width / 80)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: groundPhysicsSize, center: CGPointZero)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.contactTestBitMask = (ballCategory)
        
    }
    func loadAppearance_rim1() {                                               //
        rim1 = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake((self.frame.size.width) / 40, (self.frame.size.width) / 40))
        rim1.position = CGPointMake(((self.frame.size.width) / 2.23), ((self.frame.size.height) / 1.33))
        rim1.anchorPoint = CGPointMake(0.5, 0.5)                               //
        rim1.zPosition = 1
        let rim1PhysicsSize = CGSizeMake(self.frame.size.width / 50, self.frame.size.width / 100)
        rim1.physicsBody = SKPhysicsBody(rectangleOfSize: rim1PhysicsSize, center: CGPointZero)
        rim1.physicsBody?.affectedByGravity = false
        rim1.physicsBody?.dynamic = false

        //rim1.loadPhysicsBodyWithSize(size)                                   //
                                                                               //
    }                                                                          //
    func loadAppearance_rim2(){                                                //
        rim2 = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake((self.frame.size.width) / 40, (self.frame.size.width) / 40))
        rim2.position = CGPointMake(((self.frame.size.width) / 1.8), ((self.frame.size.height) / 1.33))
        rim2.anchorPoint = CGPointMake(0.5, 0.5)                               //
        rim2.zPosition = 1
        let rim2PhysicsSize = CGSizeMake(self.frame.size.width / 50, self.frame.size.width / 100)
        rim2.physicsBody = SKPhysicsBody(rectangleOfSize: rim2PhysicsSize, center: CGPointZero)
        rim2.physicsBody?.affectedByGravity = false
        rim2.physicsBody?.dynamic = false

        //rim2.loadPhysicsBodyWithSize(size)                                   //
                                                                               //
    }                                                                          //
    func loadAppearance_rimNet(){                                              //
        rimNet = SKSpriteNode(color: UIColor.brownColor(), size: CGSizeMake((self.frame.size.width) / 8.5, (self.frame.size.width) / 150))
        rimNet.position = CGPointMake(((self.frame.size.width) / 1.99), ((self.frame.size.height) / 1.33))
        rimNet.anchorPoint = CGPointMake(0.5, 0.5)                             //
        rimNet.zPosition = 1
        let rimNetPhysicsSize = CGSizeMake(self.frame.size.width / 10, self.frame.size.width / 1000)
        rimNet.physicsBody = SKPhysicsBody(rectangleOfSize: rimNetPhysicsSize, center: CGPointZero)
        rimNet.physicsBody?.affectedByGravity = false
        rimNet.physicsBody?.dynamic = false
        rimNet.physicsBody?.collisionBitMask = (None)
        rimNet.physicsBody?.contactTestBitMask = (ballCategory)
        rimNet.physicsBody?.categoryBitMask = (rimNetCategory)
        //ringEnabled = false
        //rimNet.loadPhysicsBodyWithSize(size)                                 //
                                                                               //
    }                                                                          //
    func loadAppearance_ball() {                                               //
        ball = SKSpriteNode(imageNamed: "Rock")
        let randomNumber = arc4random_uniform(2)
        if randomNumber == 0{
            ball.position = randBallPositionLeft()
        }
        if randomNumber == 1{
            ball.position = randBallPositionRight()
        }
        ball.size = CGSizeMake(self.frame.size.width / 18, self.frame.size.width / 18)
        ball.anchorPoint = CGPointMake(0.5, 0.5)                               //
        ball.zPosition = 1                                                     //
        //declare ball as PhysicsBody
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        //affected by gravity set
        //ball.userInteractionEnabled = false
        ball.physicsBody?.affectedByGravity = false
        //bounciness of ball
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 1
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.collisionBitMask = rim1Category
        ball.physicsBody?.collisionBitMask = rim2Category
        ball.physicsBody?.collisionBitMask = groundCategory
        //appearBeforeRing = true                   //
                                                                               //
    }                                                                          //
    /////////////////////////////////////////////////////////////////////////////
    
    func randBallPositionLeft() -> CGPoint{
        
        let randLeftMin = (self.size.width) / 11.5
        let randLeftMax = (self.size.width) / 3.3
        let SpawnPositionLeft = UInt32(randLeftMax - randLeftMin)
        return CGPointMake(CGFloat(arc4random_uniform(SpawnPositionLeft)) + randLeftMin, (self.frame.size.height) / 11)
        
    }
    
    func randBallPositionRight() -> CGPoint{
        let randRightMin = (self.size.width) * 0.725
        //NEEDS EDIT FOR MAX
        let randRightMax = (self.size.width) * 0.9
        let SpawnPositionRight = UInt32(randRightMax - randRightMin)
        return CGPointMake(CGFloat(arc4random_uniform(SpawnPositionRight)) + randRightMin, (self.frame.size.height) / 11)
    }
 
 
    func madeShotReset(){
        ball.removeFromParent()
        loadAppearance_ball()
        addChild(ball)
        view!.userInteractionEnabled = true
        
        
    }

    func ballAboveRing()->Bool {
        return rimNet.position.y < ball?.position.y
    }
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////
    func addNodes() {                                                          //
        //background                                                           //
        loadAppearance_background()
        addChild(background)
        //scoreLabel                                                           //
        loadAppearance_scoreLabel()                                            //
        addChild(scoreLabel)                                                   //
        //players                                                              //
        //loadAppearance_players()                                               //
        //addChild(steveKerr)                                                    //
        //rim1                                                                 //
        loadAppearance_rim1()                                                  //
        addChild(rim1)                                                         //
        //rim2                                                                 //
        loadAppearance_rim2()                                                  //
        addChild(rim2)                                                         //
        //rimNet                                                               //
        loadAppearance_rimNet()                                                //
        addChild(rimNet)                                                       //
        //ball                                                                 //
        loadAppearance_ball()                                                  //
        addChild(ball)
        //randBallPositionLeft()
        //ground
        loadAppearance_ground()
        addChild(ground)
    }                                                                          //
    /////////////////////////////////////////////////////////////////////////////
    
    func addPhysicsWorld() {                                                   //
        
        //amount of effect the gravity has
        //x is 0 for no side to side
        //-9.8 is gravity on Earth
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        //close off the frame with a physicsbody
        //sceneBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //friction - ball will bounce back at same speed
        sceneBody.friction = 0
        //apply physics body to scene
        self.physicsBody = sceneBody
        physicsWorld.contactDelegate = self                                    //
    }                                                                          //
    /////////////////////////////////////////////////////////////////////////////
    
    func scaler() {
        let scale:CGFloat = 0.75
        let scaleDuration:NSTimeInterval = 1.1
        ball.runAction(SKAction.scaleBy(scale, duration: scaleDuration))
    }
    /////////////////////////////////////////////////////////////////////////////
    override func didMoveToView(view: SKView) {
        addNodes()
        addPhysicsWorld()
    }
    /////////////////////////////////////////////////////////////////////////////

    
    /////////////////////////////////////////////////////////////////////////////
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        //var currentScore = score
        
        if firstBody.categoryBitMask == rimNetCategory && secondBody.categoryBitMask == ballCategory || firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == rimNetCategory{
            madeShotReset()
            //loadAppearance_ball()
            //ball.reset(randBallPositionLeft())
            score += 1
            scoreLabel.text = "\(score)"
            
            }
    
        else if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == groundCategory || firstBody.categoryBitMask == groundCategory && secondBody.categoryBitMask == ballCategory{
            ball.removeFromParent()
            score = 0
            scoreLabel.text = "\(score)"
            madeShotReset()
        }

    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
        for touch: AnyObject in touches {
        let location = touch.locationInNode(self)
        if ball.frame.contains(location){
            touchingPoint = location
            touching = true
        }
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //touching = false
        for touch: AnyObject in touches {
        //let touch = touches.first! as UITouch
        let location = touch.locationInNode(self)
            touchingPoint = location
        }
    }
 
   
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        ball.physicsBody?.affectedByGravity = true
        //touching = true
        if touching{
            let dt:CGFloat = 8.25/29.5
            let distance = CGVector(dx: touchingPoint.x-ball.position.x, dy: touchingPoint.y-ball.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            ball.physicsBody!.velocity=velocity
            scaler()
            view!.userInteractionEnabled = false
            
        }
    }
}



