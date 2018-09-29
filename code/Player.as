package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The Player class.
	 */
	public class Player extends MovieClip {
		
		/**
		 * Player constructor function.
		 */
		public function Player() {
			
		} // ends Player
		
		/** Update design pattern. */
		public function update(keyboard:KeyboardInput):void {
			
			// Change angle based on mouse position and rotate player. 
			var tx: Number = parent.mouseX - x;
			var ty: Number = parent.mouseY - y;
			var angle: Number = Math.atan2(ty, tx);
			angle *= 180 / Math.PI;
			rotation = angle + 90;
			
			// Tells player which direction to move based on what key is pressed.
			if(keyboard.keyLeft) x -= 7;
			if(keyboard.keyUp) y -= 7;
			if(keyboard.keyRight) x += 7;
			if(keyboard.keyDown) y += 7;
		
		} // ends update
	} // ends class
} // ends package
