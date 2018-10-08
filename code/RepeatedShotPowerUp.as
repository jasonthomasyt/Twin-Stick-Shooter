package code {
	
	import flash.display.MovieClip;
	
	
	/**
	 * This is the class for the Repeated Shot PowerUp object.
	 */
	public class RepeatedShotPowerUp extends MovieClip {

		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead: Boolean = false;

		/** Radius of the powerup. */
		public var radius: Number = 20;

		/** Lets the game know what kind of powerup has just been picked up. */
		public var selector: int = 3;

		/** Repeated Shot PowerUp constructor function. */
		public function RepeatedShotPowerUp() {
			/** Set coordinates, speed, and radius. */
			x = Math.random() * 550;
			y = Math.random() * 350;
			radius *= scaleX;
		} // ends RepeatedShotPowerUp

	} // ends class
	
} // ends package
