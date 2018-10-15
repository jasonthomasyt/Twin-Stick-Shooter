package code {

	import flash.display.MovieClip;

	/**
	 * The class for the TripleTank object.
	 * This enemy takes three hits to take down.
	 */
	public class TripleTank extends BasicTank {

		/**
		 * The constructor function for TripleTank.
		 */
		public function TripleTank() {
			selector = 3;
		} // ends TripleTank

		/**
		 * Overrides the update design pattern function from BasicTank.
		 * @param scenePlay The play scene of the game.
		 * @return void This method should not return anything.
		 */
		override public function update(scenePlay: ScenePlay): void {
			// Dies after three hits.
			if (hitCounter >= 3) {
				isDead = true;
			}

			// Randomly chooses when tank shoots.
			if (spawnDelay > 0) {
				spawnDelay -= Time.dtScaled;
			} else {
				scenePlay.spawnEnemyBullet(null, null, this);
				spawnDelay = Math.random() * 1.5 + .5;
			}

			// Changes its angle and rotation of where it fires so that it shoots at and follows the player.
			var dx: Number = scenePlay.player.x - x;
			var dy: Number = scenePlay.player.y - y;
			var angleToPlayer: Number = Math.atan2(dy, dx);

			velocityY = speed * Math.sin(angleToPlayer);
			velocityX = speed * Math.cos(angleToPlayer);

			angleToPlayer *= 180 / Math.PI;
			rotation = angleToPlayer + 90;

			x += velocityX * Time.dtScaled;
			y += velocityY * Time.dtScaled;
		} // ends update
	} // ends class
} // ends package