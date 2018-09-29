package code  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	/**
	 * This class is an abstract class for our
	 * GameScene FSM. All game scenes are child classes
	 * of this class.
	 */
	public class GameScene extends MovieClip {
		
		/** This array holds only Bullet objects. */
		var bullets: Array = new Array();

		/**
		 * Each game scene should override this method
		 * and add specific implementation.
		 */
		public function update(keyboard:KeyboardInput):GameScene {
			return null;
		} // ends update
		
		/**
		 * Tells each scene what to do when it begins.
		 */
		public function onBegin():void {
			
		} // ends onBegin
		
		/**
		 * Tells each scene what to do when it ends.
		 */
		public function onEnd():void {
			
		} // ends onEnd

	}
	
}
