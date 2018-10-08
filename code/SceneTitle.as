package code {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * The class for the title scene of the game.
	 */
	public class SceneTitle extends GameScene {
		
		/** Boolean flag to check if the game should switch to play scene. */
		private var shouldSwitchToPlay:Boolean = false;
		
		/** 
		 * Overrides the update design pattern function from GameScene.
		 */
		override public function update():GameScene {
			
			// Play game if shouldSwitchToPlay is true
			if(shouldSwitchToPlay) return new ScenePlay();
			
			return null;
		} // ends update
		
		/**
		 * Overrides onBegin method from GameScene
		 * Specifies what should happen when scene begins.
		 */
		override public function onBegin():void {
			
			bttnPlay.addEventListener(MouseEvent.MOUSE_DOWN, handleClickPlay);
			
		} // ends onBegin
		
		/**
		 * Overrides onEnd method from GameScene
		 * Specifies what should happen when scene ends.
		 */
		override public function onEnd():void {
			
			bttnPlay.removeEventListener(MouseEvent.MOUSE_DOWN, handleClickPlay);
			
		} // ends onEnd
		
		/**
		 * Handles the play button click event.
		 */
		private function handleClickPlay(e:MouseEvent):void {
			
			// Start playing the game when clicked.
			shouldSwitchToPlay = true;
			
		} // ends handleClickPlay
	} // ends class
} // ends package
