package code  {
	
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	
	/**
	 * The KeyboardInput class.
	 * Handles all keyboard input events.
	 */
	public class KeyboardInput {
		
		/** Boolean flag for each key that is pressed. */
		public var keyLeft:Boolean = false;
		public var keyUp:Boolean = false;
		public var keyRight:Boolean = false;
		public var keyDown:Boolean = false;
		public var keyEnter:Boolean = false;

		/**
		 * Constructor function for KeyboardInput
		 */
		public function KeyboardInput(stage:Stage) {
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
		} // ends KeyboardInput
		
		/** 
		 * Updates the key booleans when a certain key is pressed.
		 */
		private function updateKey(keyCode:int, isDown:Boolean):void {
			
			if(keyCode == 13) keyEnter = isDown;
			if(keyCode == 65) keyLeft = isDown;
			if(keyCode == 87) keyUp = isDown;
			if(keyCode == 68) keyRight = isDown;
			if(keyCode == 83) keyDown = isDown;
			
		} // ends updateKey
		
		/**
		 * If key is pressed, set boolean to true.
		 */
		private function handleKeyDown(e:KeyboardEvent):void {
			
			updateKey(e.keyCode, true);
			
		} // ends handleKeyDown
		
		/**
		 * If key is not pressed, set boolean to false.
		 */
		private function handleKeyUp(e:KeyboardEvent):void {
			
			updateKey(e.keyCode, false);
			
		} // ends handleKeyUp
	} // ends class
} // ends package
