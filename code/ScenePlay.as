package code {
	import flash.events.MouseEvent;
	
	/**
	 * The class for the play scene.
	 */
	public class ScenePlay extends GameScene {

		/** Instantiates the Player object. */
		private var player:Player;
		
		/** 
		 * ScenePlay constructor function.
		 * Places the player on the stage.
		 */
		public function ScenePlay() {
			
			player = new Player();
			addChild(player);
			player.x = 270;
			player.y = 350;
			
		} // ends ScenePlay
		
		/**
		 * Overrides the update pattern of GameScene.
		 */
		override public function update(keyboard:KeyboardInput):GameScene {
			
			stage.addEventListener(MouseEvent.CLICK, handleClick);
			
			player.update(keyboard);
			
			updateBullets();
			
			// Game Over if player goes below bottom of screen.
			if(player.y > 400) return new SceneLose();
			
			return null;
		} // ends update
		
		/**
		 * Overrides onEnd method from GameScene
		 * Specifies what should happen when scene ends.
		 */
		override public function onEnd():void {
			
			stage.removeEventListener(MouseEvent.CLICK, handleClick);
			
		} // ends onEnd
		
		/**
		 * This event-handler is called everytime the left mouse button is down.
		 * It causes the player to shoot bullets.
		 * @param e The MouseEvent that triggered this event-handler.
		 */
		private function handleClick(e: MouseEvent): void {
			spawnBullet();
		} // ends handleClick
		
		/** 
		 * Spawns a bullet everytime the user clicks the left mouse button.
		 */
		private function spawnBullet(): void {
			
			var b: Bullet = new Bullet(player);
			addChild(b);
			bullets.push(b);
			
		} // ends spawnBullet
		
		/**
		 * Updates bullets for every frame.
		 */
		private function updateBullets(): void {
			
			// update everything:
			for (var i: int = bullets.length - 1; i >= 0; i--) {
				bullets[i].update(); // Update design pattern.

				/** If bullet is dead, remove it. */
				if (bullets[i].isDead) {
					// remove it!!

					// 1. remove the object from the scene-graph
					removeChild(bullets[i]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					bullets.splice(i, 1);
				}
			} // ends for loop updating bullets
		} // ends updateBullets
	} // ends class
} // ends package
