package code {
	
	import flash.display.MovieClip;
	
	
	public class BasicTank extends MovieClip {
		
		/** Speed of tank. */
		private var speed:Number;
		
		/** X Velocity of Tank. */
		private var velocityX:Number;
		
		/** Y Velocity of Tank. */
		private var velocityY:Number;
		
		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead:Boolean = false;
		
		/** Hit radius of tank. */
		public var radius:Number = 51;
		
		/** The amount of time (in seconds) to wait before spawning the next bullet. */
		private var spawnDelay:Number = 0;
		
		/**
		 * Basic Tank constructor function.
		 * Chooses the coordinates of each tank that spawns.
		 */
		public function BasicTank() {
			x = Math.random() * 550;
			y = - 50;
			speed = Math.random() * 75 + 50; // 2 to 5?
			radius *= scaleX;
		} // ends BasicTank
		
		/**
		 * The update design pattern for the tank.
		 * @param scenePlay The play scene of the game.
		 */
		public function update(scenePlay:ScenePlay):void {
			
			// Randomly chooses when tank shoots.
			if(spawnDelay > 0){
				spawnDelay -= Time.dtScaled;
			} else {
				scenePlay.spawnEnemyBullet(this);
				spawnDelay = Math.random() * 1.5 + .5;
			}
			
			// Changes its angle and rotation of where it fires so that it shoots at and follows the player.
			var dx:Number = scenePlay.player.x - x;
			var dy:Number = scenePlay.player.y - y;			
			var angleToPlayer:Number = Math.atan2(dy, dx);
			
			velocityY = speed * Math.sin(angleToPlayer);
			velocityX = speed * Math.cos(angleToPlayer);
			
			angleToPlayer *= 180 / Math.PI;
			rotation = angleToPlayer + 90;
			
			x += velocityX * Time.dtScaled;
			y += velocityY * Time.dtScaled;
			
			if(y > 400){
				isDead = true;
			}
		} // ends update
	} // ends class
} // ends package
