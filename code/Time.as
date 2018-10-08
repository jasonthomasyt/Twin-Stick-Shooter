package code {
	import flash.utils.getTimer;
	
	public class Time {

		/** Delta time variable. */
		public static var dt:Number = 0;
		
		/** Scaled delta time variable. */
		public static var dtScaled:Number = 0;
		
		/** Current time variable. */
		public static var time:Number = 0;

		/** Current time scale. */
		public static var scale:Number = 1;
		
		/** Previous Time variable. */
		private static var timePrev:Number = 0;
		
		/**
		 * The Update design pattern.
		 * Determines the current scaled time based on FPS.
		 */
		public static function update():void {
			time = getTimer();
			dt = (time - timePrev) / 1000;
			dtScaled = dt * scale;
			timePrev = time; // cache for next frame
		} // ends update
	} // ends class
} // ends package
