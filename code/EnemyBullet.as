package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The class for the Enemy Bullet object. 
	 */
	public class EnemyBullet extends MovieClip {
		
		/** Speed of the bullet. */
		public const SPEED: Number = 240;

		/** Velocity of the bullet. */
		public var velocityX: Number = 0;
		public var velocityY: Number = -10;

		/** Checks for if the bullet should be deleted. */
		public var isDead: Boolean = false;

		/** Radius of the bullet. */
		public var radius: Number = 10;

		/** Angle of the bullet. */
		public var angle: Number = 0;
		
		/**
		 * Enemy Bullet constructor function.
		 * @param p The Player object.
		 * @param e The enemy object of the game.
		 */
		public function EnemyBullet(p: Player, e: BasicTank) {
			// Set coordinates of bullet to player coordinates. 
			x = e.x;
			y = e.y;
			
			var tx:Number = p.x - e.x;
			var ty:Number = p.y - e.y;
				
			var angle:Number = Math.atan2(ty, tx);
			angle += (Math.random() * 20 + Math.random() * -20) * Math.PI / 180;
				
			velocityX = SPEED * Math.cos(angle);
			velocityY = SPEED * Math.sin(angle);
		} // ends EnemyBullet
		
		/**
		 * The update design pattern for the bullet.
		 */
		public function update(): void {
			
			// Moves bullet according to velocity.
			x += velocityX * Time.dtScaled;
			y += velocityY * Time.dtScaled;

			// If it moves off the stage, mark it as dead.
			if (!stage || y < 0 || x < 0 || x > stage.stageWidth || y > stage.stageHeight) isDead = true;
			
		} // ends update
	}
	
}
