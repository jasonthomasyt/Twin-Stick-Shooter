package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The Player class.
	 */
	public class Player extends MovieClip {
		
		/** Checks if player is dead. */
		public var isDead:Boolean = false;
		
		public var angle:Number = 0;
		
		/** The hit radius of the player. */
		public var radius:Number = 51;
		
		/**
		 * The constructor function of the player.
		 */
		public function Player() {
			radius *= scaleX;
		} // ends Player
		
		/** Update design pattern. */
		public function update():void {
			
			// Change angle based on mouse position and rotate player. 
			var tx: Number = parent.mouseX - x;
			var ty: Number = parent.mouseY - y;
			angle = Math.atan2(ty, tx);
			angle *= 180 / Math.PI;
			rotation = angle + 90;
			
			var speed:Number = 200;
			
			// Tells player which direction to move based on what key is pressed.
			if(KeyboardInput.keyLeft) x -= speed * Time.dtScaled;
			if(KeyboardInput.keyUp) y -= speed * Time.dtScaled;
			if(KeyboardInput.keyRight) x += speed * Time.dtScaled;
			if(KeyboardInput.keyDown) y += speed * Time.dtScaled;
		
		} // ends update
	} // ends class
} // ends package
