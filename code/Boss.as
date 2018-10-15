package code {

	import flash.display.MovieClip;

	/**
	 * The Boss class for the boss of the game.
	 * The player must shoot at him until his health bar depletes.
	 */
	public class Boss extends BasicTank {

		/**
		 * The constructor function for the Boss object.
		 * Sets the coordinates and radius of the boss.
		 */
		public function Boss() {
			selector = 4;
			x = 500;
			radius = 150;
		} // ends Boss

		/**
		 * Overrides the update design pattern from the BasicTank class.
		 * @param scenePlay The play scene of the game.
		 * @return void This method should not return anything.
		 */
		override public function update(scenePlay: ScenePlay): void {
			// Randomly chooses when tank shoots.
			if (spawnDelay > 0) {
				spawnDelay -= Time.dtScaled;
			} else {
				scenePlay.spawnEnemyBullet(null, null, null, this);
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