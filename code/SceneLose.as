package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The class for the lose scene of the game.
	 */
	public class SceneLose extends GameScene {

		/**
		 * Constructor function for SceneLose
		 */
		public function SceneLose() {
			
		}
		
		/**
		 * Overrides the update design pattern function for GameScene.
		 */
		override public function update(keyboard:KeyboardInput):GameScene {
			
			// If enter key is pressed, go to title screen.
			if(keyboard.keyEnter) return new SceneTitle();
			
			// Remove all bullets from the screen.
			for (var i = bullets.length - 1; i >= 0; i--) {
				removeChild(bullets[i]);
				bullets.splice(i, 1);
			}
			
			return null;
		} // ends update
	} // ends class
} // ends package
