import SpriteKit

extension SKNode {
	class func unarchiveFromFile(file : String) -> SKNode? {
		if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
			var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
			var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
			
			archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
			let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
			archiver.finishDecoding()
			return scene
		} else {
			return nil
		}
	}
}