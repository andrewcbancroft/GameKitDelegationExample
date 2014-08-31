import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GameSceneDelegate, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
			scene.gameSceneDelegate = self
			
            skView.presentScene(scene)
        }
    }

	func gameCenterSignInTouched() {
		authenticateLocalPlayer()
	}

	func leaderboardTouched() {
		authenticateLocalPlayer()
		showLeaderboard()
	}
	
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

	var gameCenterEnabled: Bool = false
	var leaderboardIdentifier = "lots.points" // This should actually probably be assigned only by the loadDefaultLeaderboardIdentifierWithCompletionHandler method below in your authenticatLocalPlayer() function
	
	
	func authenticateLocalPlayer() {
		var localPlayer = GKLocalPlayer.localPlayer()
		localPlayer.authenticateHandler = {(viewController, error) -> Void in
			if (viewController != nil) {
				self.presentViewController(viewController, animated: true, completion: nil)
			} else {
				if (GKLocalPlayer().authenticated) {
					self.gameCenterEnabled = true
					localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier : String!, error : NSError!) -> Void in
						if error != nil {
							println(error.localizedDescription)
						} else {
							self.leaderboardIdentifier = leaderboardIdentifier
						}
					})
				} else {
					self.gameCenterEnabled = false
				}
			}
		}
		println(localPlayer)
		println(leaderboardIdentifier)
	}
	
	func showLeaderboard() {
		// only show the leaderboard if game center is enabled
		if self.gameCenterEnabled {
			let gameCenterViewController = GKGameCenterViewController()
			gameCenterViewController.gameCenterDelegate = self
			
			gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
			gameCenterViewController.leaderboardIdentifier = self.leaderboardIdentifier
			
			self.presentViewController(gameCenterViewController, animated: true, completion: nil)
		} else {
			// Tell the user something useful about the fact that game center isn't enabled on their device
		}
		
	}
	
	// MARK: GKGameCenterControllerDelegate Method
	func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
		gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
	}
}
