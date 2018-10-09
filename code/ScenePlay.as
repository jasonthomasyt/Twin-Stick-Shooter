package code {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * The class for the play scene.
	 */
	public class ScenePlay extends GameScene {
		
		/** Checks if a powerup has been spawned in the scene. */
		var powerUpSpawned: Boolean = false;

		/** Checks if the double shot powerup has been picked up. */
		var doubleShotPower: Boolean = false;

		/** Checks if the triple shot powerup has been picked up. */
		var tripleShotPower: Boolean = false;

		/** Checks if the repeated shot powerup has been picked up. */
		var repeatedShotPower: Boolean = false;

		/** Instantiates the Player object. */
		public var player: Player;

		/** Helps determine which powerup will spawn. */
		var powerSelector: int = 0;
		
		/** The number frames to wait before spawning the next enemy object. */
		var delaySpawn: int = 0;

		/** The number frames to wait before spawning the next Bullet object. */
		var delayBullets: int = 0;

		/** The number frames to wait before spawning the next powerup object. */
		var delayPowerUps: int = (Math.random() * 240 + 240); // 10 to 20 seconds;
		
		/** Counts current score for the game. */
		var score: int = 0;
		
		var maxHealth: Number = 10;
		
		var currentHealth: Number = maxHealth;

		/** 
		 * ScenePlay constructor function.
		 * Places the player on the stage.
		 */
		public function ScenePlay() {

			// Spawn Player.
			player = new Player();
			addChild(player);
			player.x = 270;
			player.y = 350;

		} // ends ScenePlay

		/**
		 * Overrides the update pattern of GameScene.
		 * Spawns and updates all necessary objects.
		 */
		override public function update(): GameScene {

			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			
			spawnEnemyTanks();

			spawnPowerUps();

			player.update();
			
			updateEnemyTanks();

			updateBullets();

			updatePowerUps();

			collisionDetection();
			
			hud.update(this);

			// Game Over if player gets hit too many times
			if (player.isDead) return new SceneLose();
			
			// Player wins if score reaches 10.
			if (score == 10) return new SceneWin();

			return null;
		} // ends update

		/**
		 * Overrides onEnd method from GameScene
		 * Specifies what should happen when scene ends.
		 */
		override public function onEnd(): void {

			stage.removeEventListener(MouseEvent.CLICK, handleClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

		} // ends onEnd

		/**
		 * This event-handler is called everytime the left mouse button is down.
		 * It causes the player to shoot bullets (and changes shot pattern based on what powerup they have).
		 * @param e The MouseEvent that triggered this event-handler.
		 */
		private function handleClick(e: MouseEvent): void {
			if (doubleShotPower == true) {
				doubleShot();

				setTimeout(function () {
					doubleShotPower = false;
					powerUpSpawned = false;
					delayPowerUps = (Math.random() * 240 + 240); // spawn every 10 to 20 seconds.
				}, 10000);
			} else if (tripleShotPower == true) {
				tripleShot();

				setTimeout(function () {
					tripleShotPower = false;
					powerUpSpawned = false;
					delayPowerUps = (Math.random() * 240 + 240); // spawn every 10 to 20 seconds.
				}, 10000);
			} else if (repeatedShotPower == true) {
				stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

				setTimeout(function () {
					repeatedShotPower = false
					stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
					powerUpSpawned = false;
					delayPowerUps = (Math.random() * 240 + 240); // spawn every 10 to 20 seconds.
				}, 10000);
			} else {
				spawnBullet();
			}
		} // ends handleClick
		
		/** Used only for the repeated shot powerup.
		 * Ensures that every frame will run this function.
		 * @param e The event for entering each frame.
		 */
		private function onStageEnterFrame(e: Event): void {
			repeatedShot();
		} // ends onStageEnterFrame
		
		/**
		 * This event-handler is called when the repeated shot powerup is active and the user has released the left mouse button.
		 * It removes the onStageEnterFrame and onStageMouseUp event handlers from the stage.
		 * This allows the bullets to stop firing when the user has unclicked the left mouse button.
		 * @param e The MouseEvent that triggered this event-handler.
		 */
		private function onStageMouseUp(e: MouseEvent): void {
			stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

			delayBullets = 0;

		} // end onStageMouseUp
		
		/**
		 * Spawns enemy tanks to the scene.
		 */
		private function spawnEnemyTanks(): void {
			delaySpawn -= Time.dtScaled;
			if (delaySpawn <= 0) {
				var b: BasicTank = new BasicTank();
				addChild(b);
				enemyTanks.push(b);
				delaySpawn = (int)(Math.random() * 100 + .5);
			}
		} // ends spawnEnemyTanks

		/** 
		 * Spawns a bullet from the player everytime the user clicks the left mouse button.
		 */
		private function spawnBullet(): void {

			var b: Bullet = new Bullet(player);
			addChild(b);
			bullets.push(b);

		} // ends spawnBullet
		
		/**
		 * Spawns a bullet from the enemy.
		 */
		public function spawnEnemyBullet(basicTank: BasicTank): void {
			var e: EnemyBullet = new EnemyBullet(player, basicTank);
			addChild(e);
			enemyBullets.push(e);
		} // ends spawnEnemyBullet
		
		/**
		 * Decrements the delayPowerUps countdown timer.  When it hits 0, it spawns a random powerup.
		 */
		private function spawnPowerUps(): void {
			// spawn powerups:
			delayPowerUps--;
			if (delayPowerUps <= 0 && powerUpSpawned == false) {
				// This selects a random number between 1 and 4 to help determine which powerup gets spawned next.
				powerSelector = 1;
				if (powerSelector >= 1 && powerSelector < 2) {
					var d: DoubleShotPowerUp = new DoubleShotPowerUp();
					addChild(d);
					powerUps.push(d);
				} else if (powerSelector >= 2 && powerSelector < 3) {
					var t: TripleShotPowerUp = new TripleShotPowerUp();
					addChild(t);
					powerUps.push(t);
				} else if (powerSelector >= 3 && powerSelector < 4) {
					var r: RepeatedShotPowerUp = new RepeatedShotPowerUp();
					addChild(r);
					powerUps.push(r);
				}
				powerUpSpawned = true;
			}
		} // ends spawnPowerUps
		
		/**
		 * Updates enemies for every frame.
		 */
		private function updateEnemyTanks(): void {
			// update everything:
			for(var i = enemyTanks.length - 1; i >= 0; i--){
				enemyTanks[i].update(this);
				if(enemyTanks[i].isDead){
					// remove it!!
					
					// 1. remove the object from the scene-graph
					removeChild(enemyTanks[i]);
					
					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					enemyTanks.splice(i, 1);
				}
			} // for loop updating snow
		} // ends updateEnemyTanks
		
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
			
			for(var j = enemyBullets.length - 1; j >= 0; j--){
				enemyBullets[j].update();
				if(enemyBullets[j].isDead){
					removeChild(enemyBullets[j]);
					enemyBullets.splice(j, 1);
				}
			} // for loop updating bullets	
		} // ends updateBullets
		
		/**
		 * Updates powerups for every frame.
		 */
		private function updatePowerUps(): void {
			// update everything:
			for (var i: int = powerUps.length - 1; i >= 0; i--) {
				/** If powerup is dead, remove it. */
				if (powerUps[i].isDead) {
					// remove it!!

					// 1. remove the object from the scene-graph
					removeChild(powerUps[i]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					powerUps.splice(i, 1);
				} // ends if statement
			} // ends for loop
		} // ends updatePowerUps
		
		/** The double shot power up function.
		 * Spawns two bullets simultaneously next to each other when the user clicks the left mouse button.
		 */
		private function doubleShot(): void {
			var b: Bullet = new Bullet(player);
			b.x -= 20;
			b.x = b.x * Math.cos(b.angle);
			addChild(b);
			bullets.push(b);

			var b2: Bullet = new Bullet(player);
			b2.x += 20;
			b2.x = b2.x * Math.cos(b2.angle);
			addChild(b2);
			bullets.push(b2);
		} // ends doubleShot
		
		/** The triple shot power up function.
		 * Spawns three bullets in an arc formation.
		 */
		private function tripleShot(): void {
			var b: Bullet = new Bullet(player);
			addChild(b);
			bullets.push(b);

			var b2: Bullet = new Bullet(player);
			addChild(b2);
			bullets.push(b2);
			b2.angle = (player.rotation - 135) * Math.PI / 180;
			b2.velocityX = b2.SPEED * Math.cos(b2.angle);
			b2.velocityY = b2.SPEED * Math.sin(b2.angle);

			var b3: Bullet = new Bullet(player);
			addChild(b3);
			bullets.push(b3);
			b3.angle = (player.rotation - 45) * Math.PI / 180;
			b3.velocityX = b3.SPEED * Math.cos(b3.angle);
			b3.velocityY = b3.SPEED * Math.sin(b3.angle);
		} // ends tripleShot
		
		/** The repeated shot function.
		 * Spawns repeated bullets when the user holds down the left mouse button.
		 */
		private function repeatedShot(): void {
			delayBullets--;
			if (delayBullets <= 0) {
				var b: Bullet = new Bullet(player);
				addChild(b);
				bullets.push(b);
				delayBullets = 8;
			}
		} // ends repeatedShot
		
		/**
		 * Detects collision for snowflakes, bullets, and powerups.
		 */
		private function collisionDetection(): void {
			for(var i:int = 0; i < enemyTanks.length; i++){
				for(var j:int = 0; j < bullets.length; j++){
					
					var dx:Number = enemyTanks[i].x - bullets[j].x;
					var dy:Number = enemyTanks[i].y - bullets[j].y;
					var dis:Number = Math.sqrt(dx * dx + dy * dy);
					if(dis < enemyTanks[i].radius + bullets[j].radius){
						// collision!
						enemyTanks[i].isDead = true;
						bullets[j].isDead = true;
						score++;
						
					} // ends if statement
				} // ends second for loop			
			} // ends first for loop
			
			for (var k: int = 0; k < bullets.length; k++) {
				for (var l: int = 0; l < powerUps.length; l++) {
					var dx2: Number = powerUps[l].x - bullets[k].x;
					var dy2: Number = powerUps[l].y - bullets[k].y;
					var dis2: Number = Math.sqrt(dx2 * dx2 + dy2 * dy2);

					/** If a bullet and powerup hit, remove them and activate powerup. */
					if (dis2 < powerUps[l].radius + bullets[k].radius) {
						// collision!
						powerUps[l].isDead = true;
						bullets[k].isDead = true;

						if (powerUps[l].selector == 1) {
							doubleShotPower = true;
						} else if (powerUps[l].selector == 2) {
							tripleShotPower = true;
						} else if (powerUps[l].selector == 3) {
							repeatedShotPower = true;
						}
					} // ends if statement
				} // ends for loop
			} // ends for loop
			
			for (var m: int = 0; m < enemyBullets.length; m++) {
				var dx3: Number = player.x - enemyBullets[m].x;
				var dy3: Number = player.y - enemyBullets[m].y;
				var dis3: Number = Math.sqrt(dx3 * dx3 + dy3 * dy3);
				
				/** If enemy bullet and player hit, increase player hit counter. */
				if (dis3 < player.radius + enemyBullets[m].radius) {
					currentHealth--;
					enemyBullets[m].isDead = true;
				}
				
				if (currentHealth <= 0){
					player.isDead = true;
				}
			} // ends for loop
		} // ends collisionDetection
	} // ends class
} // ends package