package code {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import sounds.*;

	/**
	 * The class for the title scene of the game.
	 */
	public class SceneTitle extends GameScene {

		/** Boolean flag to check if the game should switch to play scene. */
		private var shouldSwitchToPlay: Boolean = false;

		/** The background music for the game. */
		var bgMusic: BGMusic = new BGMusic();

		/** 
		 * The constructor function for SceneTitle.
		 * Plays background music throughout the game.
		 */
		public function SceneTitle() {
			bgMusic.play();
		} // ends SceneTitle

		/** 
		 * Overrides the update design pattern function from GameScene.
		 * @return GameScene Must return a new scene or returns null.
		 */
		override public function update(): GameScene {

			Time.update(); // Update Time

			// Play game if shouldSwitchToPlay is true
			if (shouldSwitchToPlay) return new ScenePlay();

			return null;
		} // ends update

		/**
		 * Overrides onBegin method from GameScene
		 * Specifies what should happen when scene begins.
		 * @return void This method should not return anything.
		 */
		override public function onBegin(): void {

			bttnPlay.addEventListener(MouseEvent.MOUSE_DOWN, handleClickPlay);

		} // ends onBegin

		/**
		 * Overrides onEnd method from GameScene
		 * Specifies what should happen when scene ends.
		 * @return void This method should not return anything.
		 */
		override public function onEnd(): void {

			bttnPlay.removeEventListener(MouseEvent.MOUSE_DOWN, handleClickPlay);

		} // ends onEnd

		/**
		 * Handles the play button click event.
		 * @return void This method should not return anything.
		 */
		private function handleClickPlay(e: MouseEvent): void {

			// Start playing the game when clicked.
			shouldSwitchToPlay = true;

		} // ends handleClickPlay
	} // ends class
} // ends package