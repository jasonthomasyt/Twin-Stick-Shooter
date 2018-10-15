package code {

	import flash.display.MovieClip;

	/**
	 * The class for the HUD of the game.
	 */
	public class HUD extends MovieClip {

		/**
		 * The update design pattern for the HUD.
		 * @param game The playscene for the game.
		 * @return void This method should not return anything.
		 */
		public function update(game: ScenePlay): void {
			// Set the index of the HUD.
			parent.setChildIndex(this, parent.numChildren - 1);

			// Change text based on what wave it is.
			if (game.waveOne == true) {
				waveCounter.text = "Wave: 1/3";
			} else if (game.waveTwo == true) {
				waveCounter.text = "Wave: 2/3";
			} else if (game.waveThree == true) {
				waveCounter.text = "Wave: 3/3";
			} else if (game.bossWave == true) {
				waveCounter.text = "BOSS HEALTH";
				game.addChild(game.bossHealth);
				game.bossHealth.x = 835;
				game.bossHealth.y = 570;

				waveCounter.x = 590;
				waveCounter.y = 465;
			}

			// Scale the healthbar color based on how much health the player currently has.
			healthbar.barColor.scaleX = game.playerCurrentHealth / game.playerMaxHealth;

			// Scale the boss health color based on how much health the boss currently has.
			game.bossHealth.bossBarColor.scaleX = game.bossCurrentHealth / game.bossMaxHealth;
		} // ends update
	} // ends class
} // ends package