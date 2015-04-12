import SpriteKit

protocol GameSceneDelegate {
	func gameCenterSignInTouched()
	func leaderboardTouched()
}

class GameScene: SKScene {
	var gameSceneDelegate: GameSceneDelegate?
	
	override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let gameCenterSignInLabel = SKLabelNode(fontNamed:"Chalkduster")
        gameCenterSignInLabel.text = "Sign in to Game Center!";
        gameCenterSignInLabel.fontSize = 20;
        gameCenterSignInLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
		gameCenterSignInLabel.name = "GameCenterSignIn"
		
		let leaderboardLabel = SKLabelNode(fontNamed:"Chalkduster")
		leaderboardLabel.text = "View Leaderboard";
		leaderboardLabel.fontSize = 20;
		leaderboardLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 35.0);
		leaderboardLabel.name = "LeaderBoard"
		
        self.addChild(gameCenterSignInLabel)
		self.addChild(leaderboardLabel)
    }
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		/* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
			
			if let nodeName = node.name {
				switch nodeName {
				case "GameCenterSignIn":
					self.gameSceneDelegate?.gameCenterSignInTouched()
				case "LeaderBoard":
					self.gameSceneDelegate?.leaderboardTouched()
				default:
					println("User tapped some other thing")
				}
			} else {
				let sprite = SKSpriteNode(imageNamed:"Spaceship")
				
				sprite.xScale = 0.5
				sprite.yScale = 0.5
				sprite.position = location
				
				let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
				sprite.runAction(SKAction.repeatActionForever(action))
				self.addChild(sprite)
			}
        }
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
