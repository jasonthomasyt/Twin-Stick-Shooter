package code {

	import flash.display.MovieClip;

	/**
	 * The class for the HealthPickup object.
	 * When the player shoots it, they get more health!
	 */
	public class HealthPickup extends MovieClip {

		/** If this is true, the object is queued up to be destroyed!! */
		public var isDead: Boolean = false;

		/** Radius of the health pickup. */
		public var radius: Number = 20;

		/** Lets the game know what kind of powerup has just been picked up. */
		public var selector: int = 4;

		/**
		 * The constructor function for HealthPickup.
		 * Sets the coordinates to a random location.
		 */
		public function HealthPickup() {
			/** Set coordinates, speed, and radius. */
			x = Math.random() * 1000;
			y = Math.random() * 350;
			radius *= scaleX;
		} // ends HealthPickup
	} // ends class
} // ends package