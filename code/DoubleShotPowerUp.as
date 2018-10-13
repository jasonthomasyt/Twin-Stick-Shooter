package code {
	
	import flash.display.MovieClip;
	
	
	/**
	 * This is the class for the Double Shot PowerUp object.
	 */
	public class DoubleShotPowerUp extends MovieClip {

		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead: Boolean = false;

		/** Radius of the powerup. */
		public var radius: Number = 20;

		/** Lets the game know what kind of powerup has just been picked up. */
		public var selector: int = 1;

		/** Double Shot PowerUp constructor function. */
		public function DoubleShotPowerUp() {
			/** Set coordinates, speed, and radius. */
			x = Math.random() * 1000;
			y = Math.random() * 350;
			radius *= scaleX;
		} // ends DoubleShotPowerUp
		
	} // ends class
} // ends package
