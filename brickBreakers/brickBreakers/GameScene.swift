//
//  GameScene.swift
//  brickBreakers
//
//  Created by Ethan  Jin  on 2/9/2021.
//

import SpriteKit
import GameplayKit

struct physicsCategories {
    static let none: UInt32 = 0 //have to add static
    static let platform: UInt32 = 0b10
    static let ball: UInt32 = 0b100
    static let brick: UInt32 = 0b1000
}

struct game {
    static var isOver: Bool = false
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    //pause button, in pause menu there is option to add ball or make ball faster or make ball bigger
    
    var ballSpeed = 0.5
    let label = SKLabelNode()
    var counter = 0
    let gameSpriteWorld = SKNode()
    let restartButton = SKSpriteNode()
    let playButton = SKSpriteNode()
    let pauseButton = SKSpriteNode()
    let fasterBallButton = SKSpriteNode()
    let slowerBallButton = SKSpriteNode()
    let biggerBallButton = SKSpriteNode()
    let biggerPlatformButton = SKSpriteNode()
    let platform = SKSpriteNode()
    let invisible = SKSpriteNode()
    let ball = SKShapeNode(circleOfRadius: 25)
    let background = SKShapeNode(rectOf: CGSize(width: 750, height: 1400))
    let brickLabel = SKSpriteNode()
    let slowerBallLabel = SKLabelNode()
    let fasterBallLabel = SKLabelNode()
    let biggerBallLabel = SKLabelNode()
    let biggerPlatformLabel = SKLabelNode()
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collisionObject = contact.bodyA.categoryBitMask == physicsCategories.brick ? contact.bodyB : contact.bodyA
         
        if collisionObject.categoryBitMask == physicsCategories.ball{
            contact.bodyA.node?.removeFromParent()
            counter += 1
            label.text = "Kills = " + String(counter)
        }
    }
    
    
    override func didMove(to view: SKView) { //calls once the whole scene is loaded
        physicsWorld.contactDelegate = self
        
        addChild(gameSpriteWorld)
        
        self.physicsBody?.applyAngularImpulse(200)
        
        let backgroundTexture = SKTexture(imageNamed: "background")
        background.zPosition = -10
        background.fillColor = .white
        background.fillTexture = backgroundTexture
        
        brickLabel.size = CGSize(width: 710, height: 354)
        let labelTexture = SKTexture(imageNamed: "label")
        brickLabel.color = .white
        brickLabel.zPosition = -9
        brickLabel.position.y = -270
        brickLabel.texture = labelTexture
        
        self.addChild(brickLabel)
        self.addChild(screen)
        self.addChild(background)
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame) //creates an edge loop from a path or rectangle   frame is a rectangle in the parents coordinate system which ignores all the child nodes
        borderBody.friction = 0.0
        borderBody.restitution = 1.0
        borderBody.linearDamping = 1000
        borderBody.angularDamping = 1000
        //self is the gamescene/parent
        self.physicsBody = borderBody //have to do this because you self isn't a physics body so you cant do self.friction so you have to individually make a physics body the size of the game scene and assign the self/gamescene to that physics body
        borderBody.isDynamic = true
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        createPlatform()
        createBall()
        createPauseButton()
        createPlayButton()
        //cant put if statement here because it doesn't loop before each frame or second to check the if statement, it only loops once when the view is presented by the scene, it calls only once after the scene is fully loaded, put if statement in update function, which does loop
        generateBrick()
        createInvisible()
        //        createInvisibleBlocks()
        
        self.addChild(biggerBallLabel)
        self.addChild(biggerBallButton)
        self.addChild(slowerBallLabel)
        self.addChild(slowerBallButton)
        self.addChild(fasterBallLabel)
        self.addChild(fasterBallButton)
        self.addChild(biggerPlatformButton)
        self.addChild(biggerPlatformLabel)
        
        //        label.fontName = ""
        label.fontColor = .white
        label.fontSize = 100
        label.position = CGPoint(x: 150, y: 470)
        label.zPosition = 103
        //        label.text = "Kills = " + String(counter)
        self.addChild(label)
        
        physicsWorld.speed = CGFloat(ballSpeed)
    }
    
    
    //    func removeScene(){
    //        self.removeAllActions()
    //        self.removeAllChildren()
    //        self.scene?.removeFromParent()
    //        self.isPaused = true
    ////        game.isOver  = true
    //    }
    
    
    func restartScene(){
        self.removeAllActions()
        self.removeAllChildren()
        self.scene?.removeFromParent()
        self.isPaused = true
        
        //What is super.viewDidLoad() and what does the code below really mean
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
//
//        let selfRect = UIScreen.main.bounds
//        let selfSize = CGSize(width: selfRect.size.width, height: selfRect.size.height)
        //        why is it when I copy the gameviewcontroller it works, but when I try writing the same thing in different format it doesn't work. Find out.
        //        let GameScene = GameScene(size: self.view!.bounds.size)//        GameScene.position = CGPoint(x: 0, y: 0)
        //        let transition = SKTransition.fade(withDuration: 1) //creates transition
        //        GameScene.scaleMode = .aspectFill     //a setting that defines how the scene is mapped to the view that presents it; skscenescalemode determines how the scene's area is mapped to the view around it; fill makes each axis of the scene scale independently so each axis in the scene maps to each length of the axis in that view
        //        view?.presentScene(GameScene, transition: transition)
        
    }
    
    func createPauseButton() {
        //        let rectangle1 = SKSpriteNode()
        //        let rectangle2 = SKSpriteNode()
        
        pauseButton.size = CGSize(width: 80, height: 80)
        pauseButton.position = CGPoint(x: -300, y: 510)
        pauseButton.color = .white
        pauseButton.zPosition = 101
        pauseButton.name = "pauseButton"
        let pauseTexture = SKTexture(imageNamed: "pause")
        pauseButton.texture = pauseTexture
        
        //        rectangle1.color = .black
        //        rectangle2.color = .black
        //        rectangle2.zPosition = 102
        //        rectangle1.zPosition = 102
        //        rectangle1.size = CGSize(width: 20, height: 60)
        //        rectangle2.size = CGSize(width: 20, height: 60)
        //        rectangle1.position = CGPoint(x: -315, y: 510)
        //        rectangle2.position = CGPoint(x: -285, y: 510)
        //        self.addChild(rectangle1)
        //        self.addChild(rectangle2)
        self.addChild(pauseButton)
    }
    
    func createPlayButton(){
        playButton.size = CGSize(width: 80, height: 80)
        playButton.position = CGPoint(x: -200, y: 510)
        playButton.color = .purple
        playButton.name = "playButton"
        playButton.zPosition = 102
        let playTexture = SKTexture(imageNamed: "play")
        playButton.texture = playTexture
        
        self.addChild(playButton)
    }
    
    func createInvisible(){
        let randomPos = Int.random(in: 0..<11)
        let randomArray = [-28,-20,-12,-8,-4,0,4,8,12,20,28]
        
        invisible.position = CGPoint(x: randomArray[randomPos], y: -60)
        invisible.size = CGSize(width:60, height: 30)
        invisible.color = .clear
        
        invisible.physicsBody = SKPhysicsBody(rectangleOf: invisible.size)
        invisible.physicsBody?.isDynamic = true
        invisible.physicsBody?.linearDamping = 100.0
        invisible.physicsBody?.angularDamping = 100.0
        invisible.physicsBody?.restitution = 5.0
        invisible.physicsBody?.affectedByGravity = false
        invisible.physicsBody?.usesPreciseCollisionDetection = true
        invisible.physicsBody?.categoryBitMask = physicsCategories.brick
        invisible.physicsBody?.contactTestBitMask = physicsCategories.ball
        
        self.addChild(invisible)
    }
    
    //    func createInvisibleBlocks(){
    //        let invisibleBlock = SKSpriteNode()
    //        invisibleBlock.size = CGSize(width: 50, height: 40)
    //        invisibleBlock.color = .clear
    //        invisibleBlock.position = CGPoint(x: 24, y: 162)
    //        let invisibleBlock2 = SKSpriteNode()
    //        invisibleBlock2.size = CGSize(width: 50, height: 40)
    //        invisibleBlock2.color = .clear
    //        invisibleBlock2.position = CGPoint(x: 76, y: 162)
    //
    //        invisibleBlock.physicsBody = SKPhysicsBody(rectangleOf: invisibleBlock.size)
    //        invisibleBlock.physicsBody?.isDynamic = true
    //        invisibleBlock.physicsBody?.linearDamping = 100.0
    //        invisibleBlock.physicsBody?.angularDamping = 100.0
    //        invisibleBlock.physicsBody?.restitution = 1.0
    //        invisibleBlock.physicsBody?.affectedByGravity = false
    //        invisibleBlock.physicsBody?.usesPreciseCollisionDetection = true
    //        invisibleBlock.physicsBody?.categoryBitMask = physicsCategories.brick
    //        invisibleBlock.physicsBody?.contactTestBitMask = physicsCategories.ball
    //        invisibleBlock2.physicsBody = SKPhysicsBody(rectangleOf: invisibleBlock2.size)
    //        invisibleBlock2.physicsBody?.isDynamic = true
    //        invisibleBlock2.physicsBody?.linearDamping = 100.0
    //        invisibleBlock2.physicsBody?.angularDamping = 100.0
    //        invisibleBlock2.physicsBody?.restitution = 1.0
    //        invisibleBlock2.physicsBody?.affectedByGravity = false
    //        invisibleBlock2.physicsBody?.usesPreciseCollisionDetection = true
    //        invisibleBlock2.physicsBody?.categoryBitMask = physicsCategories.brick
    //        invisibleBlock2.physicsBody?.contactTestBitMask = physicsCategories.ball
    //
    //        self.addChild(invisibleBlock2)
    //        self.addChild(invisibleBlock)
    //    }
    
    func createBall(){
        ball.fillColor = .white
        ball.strokeColor = .white
        ball.position = CGPoint(x: 0, y: 0)
        let ballTexture = SKTexture(imageNamed: "beachBall")
        ball.fillTexture = ballTexture
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 25 / 2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = true // whether the physics body/node is affected by angular forces and impulses applied to it
        ball.physicsBody?.friction = 0.0 // roughness of surface of physics body
        ball.physicsBody?.restitution = 1.05 // bounciness of physics body
        ball.physicsBody?.linearDamping = 0.0 //reduces bodies linear velocity or “the rate of change of displacement with respect to time when the object moves along a straight path.”
        ball.physicsBody?.angularDamping = 0.0 //reduces bodies rotational velocity or  "measure of rotation rate, that refers to how fast an object rotates or revolves relative to another point, i.e. how fast the angular position or orientation of an object changes with time."
        ball.physicsBody?.applyAngularImpulse(100.0) //applies an impulse that puts angular momentum to an object
        ball.physicsBody?.applyTorque(400)//force that causes rotation
        ball.physicsBody?.applyImpulse(CGVector(dx: -10.0, dy: 2.0))//applies an impulse to the node's center of gravity, dont need to add affected by gravity because this already does it
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = physicsCategories.ball
        ball.physicsBody?.contactTestBitMask = physicsCategories.brick
        
        gameSpriteWorld.addChild(ball)
    }
    
    
    func createPlatform(){
        platform.color = .green
        platform.position = CGPoint(x: 0, y: -540)
        platform.size = CGSize(width: 200, height: 25)
        //        let platformTexture = SKTexture(imageNamed: "")
        //        platform.texture = platformTexture
        
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        platform.physicsBody?.isDynamic = false //cant make true or when the ball bounces on it it will fall
        platform.physicsBody?.restitution = 0.0 //bounciness
        platform.physicsBody?.friction = 100.0
        platform.physicsBody?.affectedByGravity = false
        
        gameSpriteWorld.addChild(platform)
    }
    
    
    func createBrick(pos: CGPoint, texture: SKTexture){
        let brick = SKSpriteNode()
        
        brick.size = CGSize(width: 50, height: 30)
        //        brick.color = col
        brick.position = pos
        brick.texture = texture
        
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = true
        brick.physicsBody?.linearDamping = 100.0
        brick.physicsBody?.angularDamping = 100.0
        brick.physicsBody?.restitution = 1.0
        brick.physicsBody?.affectedByGravity = false
        brick.physicsBody?.usesPreciseCollisionDetection = true
        brick.physicsBody?.categoryBitMask = physicsCategories.brick
        brick.physicsBody?.contactTestBitMask = physicsCategories.ball
        
        gameSpriteWorld.addChild(brick)
    }
    
    func generateBrick(){
        let startY = 450
        
        //row 1
        var startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY), texture: SKTexture(imageNamed: "brownBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-32), texture: SKTexture(imageNamed: "redBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-64), texture: SKTexture(imageNamed: "brownBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-96), texture: SKTexture(imageNamed: "redBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-128), texture: SKTexture(imageNamed: "brownBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-160), texture: SKTexture(imageNamed: "redBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-192), texture: SKTexture(imageNamed: "brownBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-224), texture: SKTexture(imageNamed: "redBrick"))
            startX += 52
        }
        
        startX = -340
        for _ in 1...14 {
            createBrick(pos: CGPoint(x: startX, y: startY-256), texture: SKTexture(imageNamed: "brownBrick"))
            startX += 52
        }
    }
    
    
    let restartLabel = SKLabelNode()
    
    let restartTexture = SKTexture(imageNamed: "button")
    
    func createRestartButton(){
        restartLabel.text = "Restart"
        restartLabel.fontColor = .red
        restartLabel.fontName = "c"
        restartLabel.fontSize = 80
        restartLabel.zPosition = 104
        
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: 0, y: -170)
        restartButton.color = .white
        restartButton.zPosition = 103
        restartButton.texture = restartTexture
        restartButton.size = CGSize(width: 300, height: 105)
        restartLabel.position = CGPoint(x: 0, y: -198)
        self.addChild(restartLabel)
        self.addChild(restartButton)
    }
    
    func restart() {
        //        removeScene()
        restartScene()
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            let move = SKAction.move(to: CGPoint(x: loc.x, y: platform.position.y), duration: 0.1)
            platform.run(move)
        }
    }
    
    var sizeScale = 0.9
    var ballScale = 1
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode: SKNode = self.atPoint(location)
            if let name = touchedNode.name {
                if name == "restartButton" {
                    restart()
                }
                if name == "pauseButton"{
                    pauseScreen()
                }
                if name == "playButton"{
                    unpauseScreen()
                }
                if name == "slowerButton"{
                    biggerBallLabel.isHidden = true
                    biggerBallButton.isHidden = true
                    slowerBallButton.isHidden = true
                    slowerBallLabel.isHidden = true
                    fasterBallLabel.isHidden = true
                    fasterBallButton.isHidden = true
                    biggerPlatformLabel.isHidden = true
                    biggerPlatformButton.isHidden = true
                    
                    restartLabel.zPosition = 104
                    restartButton.zPosition = 103
                    
                    screen.alpha = 0
                    gameSpriteWorld.isPaused = false
                    ballSpeed = ballSpeed - 0.3
                    physicsWorld.speed = CGFloat(ballSpeed)
                    print(ballSpeed)
                }
                if name == "fasterButton"{
                    biggerBallLabel.isHidden = true
                    biggerBallButton.isHidden = true
                    slowerBallButton.isHidden = true
                    slowerBallLabel.isHidden = true
                    fasterBallLabel.isHidden = true
                    fasterBallButton.isHidden = true
                    biggerPlatformLabel.isHidden = true
                    biggerPlatformButton.isHidden = true
                    restartLabel.zPosition = 104
                    restartButton.zPosition = 103
                    
                    screen.alpha = 0
                    gameSpriteWorld.isPaused = false
                    ballSpeed = ballSpeed + 0.3
                    physicsWorld.speed = CGFloat(ballSpeed)
                }
                if name == "biggerButton"{
                    biggerBallLabel.isHidden = true
                    biggerBallButton.isHidden = true
                    slowerBallButton.isHidden = true
                    slowerBallLabel.isHidden = true
                    fasterBallLabel.isHidden = true
                    fasterBallButton.isHidden = true
                    biggerPlatformLabel.isHidden = true
                    biggerPlatformButton.isHidden = true
                    
                    restartLabel.zPosition = 104
                    restartButton.zPosition = 103
                    
                    ballScale = ballScale + 1
                    let bigger = SKAction.scale(by: CGFloat(ballScale), duration: 0)
                    ball.run(bigger)
                    
                    screen.alpha = 0
                    gameSpriteWorld.isPaused = false
                    physicsWorld.speed = CGFloat(ballSpeed)
                }
                if name == "biggerBase"{
                    biggerBallLabel.isHidden = true
                    biggerBallButton.isHidden = true
                    slowerBallButton.isHidden = true
                    slowerBallLabel.isHidden = true
                    fasterBallLabel.isHidden = true
                    fasterBallButton.isHidden = true
                    biggerPlatformLabel.isHidden = true
                    biggerPlatformButton.isHidden = true
                    
                    restartLabel.zPosition = 104
                    restartButton.zPosition = 103
                    
                    sizeScale = sizeScale + 0.5
                    func biggerX(node: SKSpriteNode){
                        node.xScale = CGFloat(sizeScale)
                    }
                    biggerX(node: platform)
                    
                    screen.alpha = 0
                    gameSpriteWorld.isPaused = false
                    physicsWorld.speed = CGFloat(ballSpeed)
                }
            }
        }
    }
    
    let screen = SKShapeNode(rectOf: CGSize(width: 800, height: 1200))
    func pauseScreen(){
        biggerBallLabel.isHidden = false
        biggerBallButton.isHidden = false
        slowerBallButton.isHidden = false
        slowerBallLabel.isHidden = false
        fasterBallLabel.isHidden = false
        fasterBallButton.isHidden = false
        biggerPlatformButton.isHidden = false
        biggerPlatformLabel.isHidden = false
        
        restartLabel.zPosition = 0
        restartButton.zPosition = 0
        
        screen.fillColor = .yellow
        screen.alpha = 0.85
        screen.zPosition = 100
        
        gameSpriteWorld.isPaused = true
        physicsWorld.speed = 0 //rate at which physics in this scene is excecuted
        
        //Faster ball button
        
        fasterBallLabel.text = "Faster Ball"
        fasterBallLabel.fontColor = .systemPink
        fasterBallLabel.fontName = "Helvetica"
        fasterBallLabel.fontSize = 80
        fasterBallLabel.zPosition = 104
        
        fasterBallButton.name = "fasterButton"
        fasterBallButton.zPosition = 103
        fasterBallButton.texture = restartTexture
        fasterBallButton.size = CGSize(width: 200, height: 30)
        fasterBallButton.position = CGPoint(x: 0, y: 200)
        fasterBallButton.color = UIColor(red: 255, green: 253, blue: 208, alpha: 1)
        fasterBallButton.size = CGSize(width: 420, height: 105)
        fasterBallLabel.position = CGPoint(x: 0, y: 172)
        
        // Slower ball button
        
        slowerBallLabel.text = "Slower Ball"
        slowerBallLabel.fontColor = .systemPink
        slowerBallLabel.fontName = "Helvetica"
        slowerBallLabel.fontSize = 80
        slowerBallLabel.zPosition = 104
        
        slowerBallButton.name = "slowerButton"
        slowerBallButton.zPosition = 103
        slowerBallButton.texture = restartTexture
        slowerBallButton.size = CGSize(width: 200, height: 30)
        slowerBallButton.position = CGPoint(x: 0, y: 30)
        slowerBallButton.color = UIColor(red: 255, green: 253, blue: 208, alpha: 1)
        slowerBallButton.size = CGSize(width: 420, height: 105)
        slowerBallLabel.position = CGPoint(x: 0, y: 2)
        
        //Bigger ball Button
        biggerBallLabel.text = "Bigger Ball"
        biggerBallLabel.fontColor = .systemPink
        biggerBallLabel.fontName = "Helvetica"
        biggerBallLabel.fontSize = 80
        biggerBallLabel.zPosition = 104
        
        biggerBallButton.name = "biggerButton"
        biggerBallButton.zPosition = 103
        biggerBallButton.texture = restartTexture
        biggerBallButton.size = CGSize(width: 200, height: 30)
        biggerBallButton.position = CGPoint(x: 0, y: -140)
        biggerBallButton.color = UIColor(red: 255, green: 253, blue: 208, alpha: 1)
        biggerBallButton.size = CGSize(width: 420, height: 105)
        biggerBallLabel.position = CGPoint(x: 0, y: -168)
        
        biggerPlatformLabel.text = "Bigger Base"
        biggerPlatformLabel.fontColor = .systemPink
        biggerPlatformLabel.fontName = "Helvetica"
        biggerPlatformLabel.fontSize = 80
        biggerPlatformLabel.zPosition = 104
        
        biggerPlatformButton.name = "biggerBase"
        biggerPlatformButton.zPosition = 103
        biggerPlatformButton.texture = restartTexture
        biggerPlatformButton.size = CGSize(width: 200, height: 30)
        biggerPlatformButton.position = CGPoint(x: 0, y: -310)
        biggerPlatformButton.color = UIColor(red: 255, green: 253, blue: 208, alpha: 1)
        biggerPlatformButton.size = CGSize(width: 500, height: 105)
        biggerPlatformLabel.position = CGPoint(x: 0, y: -338)
    }
    
    func unpauseScreen(){
        biggerBallLabel.isHidden = true
        biggerBallButton.isHidden = true
        slowerBallButton.isHidden = true
        slowerBallLabel.isHidden = true
        fasterBallLabel.isHidden = true
        fasterBallButton.isHidden = true
        biggerPlatformLabel.isHidden = true
        biggerPlatformButton.isHidden = true
        
        restartLabel.zPosition = 104
        restartButton.zPosition = 103
        
        screen.alpha = 0
        gameSpriteWorld.isPaused = false
        physicsWorld.speed = CGFloat(ballSpeed)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if ball.position.y < -600 {
            self.isPaused = true
            label.position = CGPoint(x: 0, y: 0)
            label.fontSize = 90
            label.text = "You Lose"
            label.fontName = "c"
            label.fontColor = .red
            //            restartButton.setTitleColor(.red, for: UIControl.State.normal)
            createRestartButton()
        }
        
        if ball.position.x < -400 {
            self.isPaused = true
            label.position = CGPoint(x: 0, y: 0)
            label.fontSize = 150
            label.text = "Bug"
            label.fontName = "c"
            label.fontColor = .red
            //            restartButton.setTitleColor(.red, for: UIControl.State.normal)
            createRestartButton()
        }
        
        if ball.position.x > 400 {
            self.isPaused = true
            label.position = CGPoint(x: 0, y: 0)
            label.fontSize = 150
            label.text = "Bug"
            label.fontName = "c"
            label.fontColor = .red
            //            restartButton.setTitleColor(.red, for: UIControl.State.normal)
            createRestartButton()
        }
        
        if counter == 127 {
            self.isPaused = true
            label.position = CGPoint(x: 0, y: 0)
            label.fontSize = 150
            label.text = "You Win!"
            label.fontName = "c"
            label.fontColor = .green
            //            restartButton.setTitleColor(.green, for: UIControl.State.normal)
            restartLabel.color = .green
            createRestartButton()
        }
    }
}
//class ViewController: UIViewController {
//
//    let gameScene = GameScene()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(makeButtonSpawn())
//
//    }
//
//
//        func makeButtonSpawn() -> UIButton {
//            gameScene.restartButton.frame = CGRect(x: 0, y: -250, width: 100, height: 50)
//            gameScene.restartButton.backgroundColor = UIColor.white
//            gameScene.restartButton.setTitle("restart", for: UIControl.State.normal)
//            gameScene.restartButton.addTarget(self, action: #selector(gameScene.self.restart), for: .touchUpInside) //an event that happens when the fingers are in the the bounds of control
//    //        self.addChild(restartButton) cant do this for uibutton
//
//            makeButtonSpawn().isHidden = true
//            return gameScene.restartButton
//        }
//
//
//
//
//}
