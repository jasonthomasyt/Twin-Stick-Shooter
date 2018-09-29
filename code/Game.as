package code  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;	
	
	
	public class Game extends MovieClip {
		
		/** Instantiates keyboard from KeyboardInput class. */
		private var keyboard:KeyboardInput;
		
		/**
		 * This stores the current scene using a FSM.
		 */
		private var gameScene:GameScene;
		
		/**
		 * This is where we setup the game.
		 */
		public function Game() {
			
			keyboard = new KeyboardInput(stage);
			
			switchScene(new SceneTitle());
			
			addEventListener(Event.ENTER_FRAME, gameLoop);
			
		} // ends Game
		
		/**
		 * The game loop design pattern.
		 */
		private function gameLoop(e:Event):void {
			
			if(gameScene) switchScene(gameScene.update(keyboard));
			
		} // ends gameLoop
		
		/**
		 * Switches to a new scene when called.
		 * @param newScene The new scene that we will be switching to.
		 */
		private function switchScene(newScene:GameScene):void {
			
			if(newScene){
				//switch scenes...
				if(gameScene) gameScene.onEnd();
				if(gameScene) removeChild(gameScene);					
				gameScene = newScene;
				addChild(gameScene);
				gameScene.onBegin();
			} // ends if statement
			
		} // ends switchScene()
	} // ends class
} // ends package