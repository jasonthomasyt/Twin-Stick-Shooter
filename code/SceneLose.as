package code {

	import flash.display.MovieClip;

	/**
	 * The class for the gameover scene of the game.
	 * This scene is shown when the player dies.
	 */
	public class SceneLose extends GameScene {

		/**
		 * Overrides the update design pattern function for GameScene.
		 * @return GameScene Either return a new scene or return null.
		 */
		override public function update(): GameScene {

			// If enter key is pressed, go to title screen.
			if (KeyboardInput.keyEnter) return new SceneTitle

			// Remove all player bullets from the screen.
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