package code {

	import flash.display.MovieClip;

	/**
	 * The class for the Player object.
	 */
	public class Player extends MovieClip {

		/** Checks if player is dead. */
		public var isDead: Boolean = false;

		/** The angle that the player is facing. */
		public var angle: Number = 0;

		/** The hit radius of the player. */
		public var radius: Number = 30;

		/**
		 * The constructor function of the player.
		 * Sets the radius according to the size of the player.
		 */
		public function Player() {
			radius *= scaleX;
		} // ends Player

		/** 
		 * Update design pattern.
		 * @return void This method should not return anything.
		 */
		public function update(): void {

			// Change angle based on mouse position and rotate player. 
			var tx: Number = parent.mouseX - x;
			var ty: Number = parent.mouseY - y;
			angle = Math.atan2(ty, tx);
			angle *= 180 / Math.PI;
			rotation = angle + 90;

			var speed: Number = 200;

			// Tells player which direction to move based on what key is pressed.
			if (KeyboardInput.keyLeft) x -= speed * Time.dtScaled;
			if (KeyboardInput.keyUp) y -= speed * Time.dtScaled;
			if (KeyboardInput.keyRight) x += speed * Time.dtScaled;
			if (KeyboardInput.keyDown) y += speed * Time.dtScaled;

			// Keeps player from being able to move off the screen.
			if (x > 1000) {
				x = 1000;
			} else if (x < 0) {
				x = 0;
			}

			if (y > 600) {
				y = 600;
			} else if (y < 0) {
				y = 0;
			}

		} // ends update
	} // ends class
} // ends package