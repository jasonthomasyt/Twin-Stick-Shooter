package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The class for the lose scene of the game.
	 */
	public class SceneLose extends GameScene {
		
		/**
		 * Overrides the update design pattern function for GameScene.
		 */
		override public function update():GameScene {
			
			Time.update(); // Update Time
			
			// If enter key is pressed, go to title screen.
			if(KeyboardInput.keyEnter) return new SceneTitle
			
			// Remove all bullets from the screen.
			for (var i = bullets.length - 1; i >= 0; i--) {
				removeChild(bullets[i]);
				bullets.splice(i, 1);
			}
			
			// Remove all enemy bullets from the screen.
			for (var j = enemyBullets.length - 1; j >= 0; j--) {
				removeChild(enemyBullets[j]);
				enemyBullets.splice(j, 1);
			}
			
			// Remove all enemy tanks from the screen.
			for (var k = enemyTanks.length - 1; k >= 0; k--) {
				removeChild(enemyTanks[k]);
				enemyTanks.splice(k, 1);
			}
			
			return null;
		} // ends update
	} // ends class
} // ends package
