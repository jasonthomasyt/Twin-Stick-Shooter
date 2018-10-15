package code {

	import flash.display.MovieClip;

	/**
	 * The constructor function for the BasicTank object.
	 * This enemy only takes one hit to kill.
	 */
	public class BasicTank extends MovieClip {

		/** Speed of tank. */
		public var speed: Number;

		/** X Velocity of Tank. */
		public var velocityX: Number;

		/** Y Velocity of Tank. */
		public var velocityY: Number;

		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead: Boolean = false;

		/** Hit radius of tank. */
		public var radius: Number = 30;

		/** The amount of time (in seconds) to wait before spawning the next bullet. */
		public var spawnDelay: Number = 0;

		/** Allows our gameloop to determine which enemy is which. */
		public var selector: int;

		/** Determines how many hits an enemy is able to take before dying. */
		public var hitCounter: int = 0;

		/**
		 * Basic Tank constructor function.
		 * Chooses the coordinates of each tank that spawns.
		 */
		public function BasicTank() {
			selector = 1;
			x = Math.random() * 1000;
			y = -50;
			speed = Math.random() * 75 + 50; // 2 to 5?
			radius *= scaleX;
		} // ends BasicTank

		/**
		 * The update design pattern for the tank.
		 * @param scenePlay The play scene of the game.
		 * @return void This method should not return anything.
		 */
		public function update(scenePlay: ScenePlay): void {

			// Randomly chooses when tank shoots.
			if (spawnDelay > 0) {
				spawnDelay -= Time.dtScaled;
			} else {
				scenePlay.spawnEnemyBullet(this);
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