package code {
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import sounds.*;

	/**
	 * The class for the play scene.
	 */
	public class ScenePlay extends GameScene {

		/** Checks if a powerup has been spawned in the scene. */
		private var powerUpSpawned: Boolean = false;

		/** Checks if the double shot powerup has been picked up. */
		private var doubleShotPower: Boolean = false;

		/** Checks if the triple shot powerup has been picked up. */
		private var tripleShotPower: Boolean = false;

		/** Checks if the repeated shot powerup has been picked up. */
		private var repeatedShotPower: Boolean = false;

		/** Checks if the game is still in wave one. */
		public var waveOne: Boolean = true;

		/** Checks if the game is still in wave two. */
		public var waveTwo: Boolean = false;

		/** Checks if the game is still in wave three. */
		public var waveThree: Boolean = false;

		/** Checks if the game is ready to spawn the boss. */
		public var bossWave: Boolean = false;

		/** Checks if wave one has ended. */
		private var waveOneEnd: Boolean = false;

		/** Checks if wave two has ended. */
		private var waveTwoEnd: Boolean = false;

		/** Checks if wave three has ended. */
		private var waveThreeEnd: Boolean = false;

		/** Checks if boss wave has ended. */
		private var bossWaveEnd: Boolean = false;

		/** Instantiates the Player object. */
		public var player: Player;

		/** The healthbar of the boss. */
		public var bossHealth: BossHealth = new BossHealth();

		/** Helps determine which powerup will spawn. */
		private var powerSelector: int = 0;

		/** The number frames to wait before spawning the next enemy object. */
		private var delaySpawn: int = 0;

		/** The number frames to wait before spawning the next Bullet object. */
		private var delayBullets: int = 0;

		/** The number frames to wait before spawning the next powerup object. */
		private var delayPowerUps: int = Math.random() * 600 + 600; // 10 to 20 seconds

		/** The number of frames to wait before spawning the next health pickup object. */
		private var delayHealth: int = Math.random() * 1800 + 1800; // 30 to 60 seconds

		/** This delays how much damage the player takes when colliding with an enemy. */
		private var delayHits: int = 0;

		/** Counts how many enemies are currently in the scene. */
		private var enemyCounter: int = 0;

		/** Helps select which enemy to spawn next. */
		private var enemySelector = 0;

		/** Max Health of the player. */
		public var playerMaxHealth: Number = 10;

		/** Current Health of the player. */
		public var playerCurrentHealth: Number = playerMaxHealth;

		/** Max Health of the boss. */
		public var bossMaxHealth: Number = 100;

		/** Current Health of the boss. */
		public var bossCurrentHealth: Number = bossMaxHealth;

		/** The sound for shooting bullets. */
		private var shootSound: ShootSound = new ShootSound();

		/** The sound for each powerup that is hit. */
		private var powerUpSound: PowerUpSound = new PowerUpSound();

		/** The sound played when the player or an enemy gets hit. */
		private var hitSound: HitSound = new HitSound();

		/** The sound played when it's game over. */
		private var gameOverSound: GameOverSound = new GameOverSound();

		/** The sound played when a player picks up a health pickup. */
		private var healthSound: HealthSound = new HealthSound();

		/** The sound played when the player wins. */
		private var winSound: WinSound = new WinSound();

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
		 * @return GameScene The game scene that should be returned.
		 */
		override public function update(): GameScene {

			Time.update(); // Update Time

			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);

			spawnEnemyTanks();

			spawnPowerUps();

			spawnHealth();

			player.update();

			updateEnemyTanks();

			updateBullets();

			updatePowerUps();

			collisionDetection();

			hud.update(this);

			// Game Over if player gets hit too many times
			if (player.isDead) {
				gameOverSound.play();
				return new SceneLose();
			}

			// Player wins if they defeat the boss!
			if (bossWaveEnd) {
				winSound.play();
				return new SceneWin();
			}

			return null;
		} // ends update

		/**
		 * Overrides onEnd method from GameScene
		 * Specifies what should happen when scene ends.
		 * @return void This method should not return anything.
		 */
		override public function onEnd(): void {

			stage.removeEventListener(MouseEvent.CLICK, handleClick);
			stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

		} // ends onEnd

		/**
		 * This event-handler is called everytime the left mouse button is down.
		 * It causes the player to shoot bullets (and changes shot pattern based on what powerup they have).
		 * @param e The MouseEvent that triggered this event-handler.
		 * @return void This method should not return anything.
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
		 * @return void This method should not return anything.
		 */
		private function onStageEnterFrame(e: Event): void {
			repeatedShot();
		} // ends onStageEnterFrame

		/**
		 * This event-handler is called when the repeated shot powerup is active and the user has released the left mouse button.
		 * It removes the onStageEnterFrame and onStageMouseUp event handlers from the stage.
		 * This allows the bullets to stop firing when the user has unclicked the left mouse button.
		 * @param e The MouseEvent that triggered this event-handler.
		 * @return void This method should not return anything.
		 */
		private function onStageMouseUp(e: MouseEvent): void {
			stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);

			delayBullets = 0;

		} // end onStageMouseUp

		/**
		 * Spawns each wave of enemy tanks to the scene.
		 * @return void This method should not return anything.
		 */
		private function spawnEnemyTanks(): void {
			if (waveOne == true) {
				spawnWaveOne();
			} else if (waveTwo == true) {
				spawnWaveTwo();
			} else if (waveThree == true) {
				spawnWaveThree();
			} else if (bossWave == true) {
				spawnBoss();
			}
		} // ends spawnEnemyTanks

		/**
		 * Spawns the first wave of enemies.
		 * Only spawns 10 enemies to the stage.
		 * All enemies in this wave are of the Basic Tank object.
		 * @return void This method should not return anything.
		 */
		private function spawnWaveOne(): void {
			if (enemyCounter < 10) {
				if (delaySpawn > 0) {
					delaySpawn -= Time.dtScaled;
				} else {
					var b: BasicTank = new BasicTank();
					addChild(b);
					enemyTanks.push(b);
					enemyCounter++;
					delaySpawn = (int)(Math.random() * 100 + 90);
				}
			}

			if (enemyCounter == 10) {
				enemyCounter = 0;
				waveOne = false;
				waveOneEnd = true;
			}
		} //ends spawnWaveOne

		/**
		 * Spawns the second wave of enemies.
		 * Only spawns 15 enemies to the stage.
		 * All enemies in this wave are of the Basic Tank object and the Double Tank object.
		 * @return void This method should not return anything.
		 */
		private function spawnWaveTwo(): void {
			if (enemyCounter < 15) {
				enemySelector = Math.random() * 2 + 1;
				if (delaySpawn > 0) {
					delaySpawn -= Time.dtScaled;
				} else {
					if (enemySelector >= 1 && enemySelector < 2) {
						var b: BasicTank = new BasicTank();
						addChild(b);
						enemyTanks.push(b);
					} else if (enemySelector >= 2 && enemySelector < 3) {
						var d: DoubleTank = new DoubleTank();
						addChild(d);
						enemyTanks.push(d);
					}
					enemyCounter++;
					delaySpawn = (int)(Math.random() * 50 + 40);
				}
			}

			if (enemyCounter == 15) {
				enemyCounter = 0;
				waveTwo = false;
				waveTwoEnd = true;
			}
		} // ends spawnWaveTwo

		/**
		 * Spawns the third wave of enemies.
		 * Only spawns 20 enemies to the stage.
		 * All enemies in this wave are of the Double Tank object and Triple Tank object.
		 * @return void This method should not return anything.
		 */
		private function spawnWaveThree(): void {
			if (enemyCounter < 20) {
				enemySelector = Math.random() * 2 + 1;
				if (delaySpawn > 0) {
					delaySpawn -= Time.dtScaled;
				} else {
					if (enemySelector >= 1 && enemySelector < 2) {
						var d: DoubleTank = new DoubleTank();
						addChild(d);
						enemyTanks.push(d);
					} else if (enemySelector >= 2 && enemySelector < 3) {
						var t: TripleTank = new TripleTank();
						addChild(t);
						enemyTanks.push(t);
					}
					enemyCounter++;
					delaySpawn = (int)(Math.random() * 50 + 40);
				}
			}

			if (enemyCounter == 20) {
				enemyCounter = 0;
				waveThree = false;
				waveThreeEnd = true;
			}
		} // ends spawnWaveThree

		/**
		 * Spawns the final boss.
		 * Only one boss is spawned.
		 * @return void This method should not return anything.
		 */
		private function spawnBoss(): void {
			if (enemyCounter < 1) {
				var b: Boss = new Boss();
				addChild(b);
				enemyTanks.push(b);
			}
			enemyCounter++;
		} // ends spawnBoss

		/** 
		 * Spawns a bullet from the player everytime the user clicks the left mouse button.
		 * This is the default shoot action if the player has not picked up a powerup.
		 * @return void This method should not return anything.
		 */
		private function spawnBullet(): void {
			shootSound.play();

			var b: Bullet = new Bullet(player);
			addChild(b);
			bullets.push(b);

		} // ends spawnBullet

		/**
		 * Spawns a bullet from the enemy.
		 * Enemy shot patterns change based on what type of enemy they are.
		 * @param basicTank The BasicTank enemy object.
		 * @param doubleTank The DoubleTank enemy object.
		 * @param tripleTank The TripleTank enemy object.
		 * @param boss The Boss enemy object.
		 * @return void This method should not return anything.
		 */
		public function spawnEnemyBullet(basicTank: BasicTank = null, doubleTank: DoubleTank = null, tripleTank: TripleTank = null, boss: Boss = null): void {
			shootSound.play();
			if (basicTank) {
				spawnBasicTankBullets(basicTank);
			} else if (doubleTank) {
				spawnDoubleTankBullets(doubleTank);
			} else if (tripleTank) {
				spawnTripleTankBullets(tripleTank);
			} else if (boss) {
				spawnBossBullets(boss);
			}
		} // ends spawnEnemyBullet

		/**
		 * Spawns the bullets for the basic tank enemy.
		 * @param basicTank The BasicTank enemy object.
		 * @return void This method should not return anything.
		 */
		private function spawnBasicTankBullets(basicTank: BasicTank): void {
			var e: EnemyBullet = new EnemyBullet(player, basicTank);
			addChild(e);
			enemyBullets.push(e);
		} // ends spawnBasicTankBullets

		/**
		 * Spawns the double shot bullets from the Double Tank enemy.
		 * @param doubleTank The DoubleTank enemy object.
		 * @return void This method should not return anything.
		 */
		private function spawnDoubleTankBullets(doubleTank: DoubleTank): void {
			var f: EnemyBullet = new EnemyBullet(player, null, doubleTank);
			f.x = f.x - 15 * Math.cos(doubleTank.rotation * Math.PI / 180);
			f.y = f.y - 15 * Math.sin(doubleTank.rotation * Math.PI / 180);
			addChild(f);
			enemyBullets.push(f);

			var f2: EnemyBullet = new EnemyBullet(player, null, doubleTank);
			f2.x = f2.x + 15 * Math.cos(doubleTank.rotation * Math.PI / 180);
			f2.y = f2.y + 15 * Math.sin(doubleTank.rotation * Math.PI / 180);
			addChild(f2);
			enemyBullets.push(f2);
		} // ends spawnDoubleTankBullets

		/**
		 * Spawns the triple shot bullets from the Triple Tank enemy.
		 * @param tripleTank The TripleTank enemy object.
		 * @return void This method should not return anything.
		 */
		private function spawnTripleTankBullets(tripleTank: TripleTank): void {
			var g: EnemyBullet = new EnemyBullet(player, null, null, tripleTank);
			addChild(g);
			enemyBullets.push(g);

			var g2: EnemyBullet = new EnemyBullet(player, null, null, tripleTank);
			addChild(g2);
			enemyBullets.push(g2);
			g2.angle = (tripleTank.rotation - 135) * Math.PI / 180;
			g2.velocityX = g2.SPEED * Math.cos(g2.angle);
			g2.velocityY = g2.SPEED * Math.sin(g2.angle);

			var g3: EnemyBullet = new EnemyBullet(player, null, null, tripleTank);
			addChild(g3);
			enemyBullets.push(g3);
			g3.angle = (tripleTank.rotation - 45) * Math.PI / 180;
			g3.velocityX = g3.SPEED * Math.cos(g3.angle);
			g3.velocityY = g3.SPEED * Math.sin(g3.angle);
		} // ends spawnTripleTankBullets

		/**
		 * Spawns giant bullets from the boss.
		 * @param boss The Boss enemy object.
		 * @return void This method should not return anything.
		 */
		private function spawnBossBullets(boss: Boss): void {
			var h: EnemyBullet = new EnemyBullet(player, null, null, null, boss);
			h.scaleX *= 5;
			h.scaleY *= h.scaleX;
			addChild(h);
			enemyBullets.push(h);
		} // ends spawnBossBullets

		/**
		 * Decrements the delayPowerUps countdown timer.  When it hits 0, it spawns a random powerup.
		 * @return void This method should not return anything.
		 */
		private function spawnPowerUps(): void {
			// spawn powerups:
			delayPowerUps--;
			if (delayPowerUps <= 0 && powerUpSpawned == false) {
				// This selects a random number between 1 and 4 to help determine which powerup gets spawned next.
				powerSelector = Math.random() * 3 + 1;
				if (powerSelector >= 1 && powerSelector < 2) {
					var d: DoubleShotPowerUp = new DoubleShotPowerUp();
					addChild(d);
					powerUps.push(d);
				} else if (powerSelector >= 2 && powerSelector < 3) {
					var t: TripleShotPowerUp = new TripleShotPowerUp();
					addChild(t);
					powerUps.push(t);
				} else if (powerSelector >= 3 && powerSelector <= 4) {
					var r: RepeatedShotPowerUp = new RepeatedShotPowerUp();
					addChild(r);
					powerUps.push(r);
				}
				powerUpSpawned = true;
			}
		} // ends spawnPowerUps

		/**
		 * Decrements the delayHealth countdown timer.  When it hits 0, it spawns a new health pickup.
		 * @return void This method should not return anything.
		 */
		private function spawnHealth(): void {
			delayHealth--;
			if (delayHealth <= 0) {
				var h: HealthPickup = new HealthPickup();
				addChild(h);
				powerUps.push(h);
				delayHealth = Math.random() * 1800 + 1800;
			}
		} // ends spawnHealth

		/**
		 * Updates enemies for every frame.
		 * @return void This method should not return anything.
		 */
		private function updateEnemyTanks(): void {
			// update everything:
			for (var i = enemyTanks.length - 1; i >= 0; i--) {
				enemyTanks[i].update(this);
				if (enemyTanks[i].isDead) {
					// remove it!!

					// 1. remove the object from the scene-graph
					removeChild(enemyTanks[i]);

					// 2. nullify any variables pointing to it
					// if the variable is an array,
					// remove the object from the array
					enemyTanks.splice(i, 1);
				}
			} // for loop updating snow

			if (enemyTanks.length == 0) {
				UpdateWave();
			}
		} // ends updateEnemyTanks

		/**
		 * Updates bullets for every frame.
		 * @return void This method should not return anything.
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

			for (var j = enemyBullets.length - 1; j >= 0; j--) {
				enemyBullets[j].update();
				if (enemyBullets[j].isDead) {
					removeChild(enemyBullets[j]);
					enemyBullets.splice(j, 1);
				}
			} // for loop updating bullets	
		} // ends updateBullets

		/**
		 * Updates powerups for every frame.
		 * @return void This method should not return anything.
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

		/**
		 * Changes to a new wave when one ends.
		 * @return void This method should not return anything.
		 */
		private function UpdateWave(): void {
			if (waveOneEnd == true) {
				waveTwo = true;
				waveOneEnd = false;
			} else if (waveTwoEnd == true) {
				waveThree = true;
				waveTwoEnd = false;
			} else if (waveThreeEnd == true) {
				bossWave = true;
				waveThreeEnd = false;
			}
		} // ends UpdateWave

		/** The double shot power up function.
		 * Spawns two bullets simultaneously next to each other when the user clicks the left mouse button.
		 * @return void This method should not return anything.
		 */
		private function doubleShot(): void {
			shootSound.play();

			var b: Bullet = new Bullet(player);
			b.x = b.x - 20 * Math.cos(player.rotation * Math.PI / 180);
			b.y = b.y - 20 * Math.sin(player.rotation * Math.PI / 180);
			addChild(b);
			bullets.push(b);

			var b2: Bullet = new Bullet(player);
			b2.x = b2.x + 20 * Math.cos(player.rotation * Math.PI / 180);
			b2.y = b2.y + 20 * Math.sin(player.rotation * Math.PI / 180);
			addChild(b2);
			bullets.push(b2);
		} // ends doubleShot

		/** The triple shot power up function.
		 * Spawns three bullets in an arc formation.
		 * @return void This method should not return anything.
		 */
		private function tripleShot(): void {
			shootSound.play();

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
		 * @return void This method should not return anything.
		 */
		private function repeatedShot(): void {
			delayBullets--;
			if (delayBullets <= 0) {
				shootSound.play();
				var b: Bullet = new Bullet(player);
				addChild(b);
				bullets.push(b);
				delayBullets = 8;
			}
		} // ends repeatedShot

		/**
		 * Detects collision for enemy tanks, bullets, player, and powerups.
		 * @return void This method should not return anything.
		 */
		private function collisionDetection(): void {
			EnemyCollision();
			PowerUpCollision();
			PlayerCollision();
		} // ends collisionDetection

		/**
		 * Detects when a player bullet collides with an enemy.
		 * @return void This method should not return anything.
		 */
		private function EnemyCollision(): void {
			for (var i: int = 0; i < enemyTanks.length; i++) {
				for (var j: int = 0; j < bullets.length; j++) {

					var dx: Number = enemyTanks[i].x - bullets[j].x;
					var dy: Number = enemyTanks[i].y - bullets[j].y;
					var dis: Number = Math.sqrt(dx * dx + dy * dy);
					if (dis < enemyTanks[i].radius + bullets[j].radius) {
						hitSound.play();
						if (enemyTanks[i].selector == 1) {
							enemyTanks[i].isDead = true;
							bullets[j].isDead = true;
						} else if (enemyTanks[i].selector == 2) {
							enemyTanks[i].hitCounter++;
							bullets[j].isDead = true;
						} else if (enemyTanks[i].selector == 3) {
							enemyTanks[i].hitCounter++;
							bullets[j].isDead = true;
						} else if (enemyTanks[i].selector == 4) {
							bossCurrentHealth--;
							bullets[j].isDead = true;

							if (bossCurrentHealth <= 0) {
								enemyTanks[i].isDead = true;
								bossWaveEnd = true;
							}
						}
					} // ends if statement
				} // ends second for loop			
			} // ends first for loop
		} // ends EnemyCollision

		/**
		 * Detects when a player bullet collides with a powerup.
		 * @return void This method should not return anything.
		 */
		private function PowerUpCollision(): void {
			for (var i: int = 0; i < bullets.length; i++) {
				for (var j: int = 0; j < powerUps.length; j++) {
					var dx: Number = powerUps[j].x - bullets[i].x;
					var dy: Number = powerUps[j].y - bullets[i].y;
					var dis: Number = Math.sqrt(dx * dx + dy * dy);

					/** If a bullet and powerup hit, remove them and activate powerup. */
					if (dis < powerUps[j].radius + bullets[i].radius) {
						powerUps[j].isDead = true;
						bullets[i].isDead = true;

						if (powerUps[j].selector == 1) {
							powerUpSound.play();
							doubleShotPower = true;
						} else if (powerUps[j].selector == 2) {
							powerUpSound.play();
							tripleShotPower = true;
						} else if (powerUps[j].selector == 3) {
							powerUpSound.play();
							repeatedShotPower = true;
						} else if (powerUps[j].selector == 4) {
							healthSound.play();
							playerCurrentHealth += 3;
							if (playerCurrentHealth > playerMaxHealth) {
								playerCurrentHealth = playerMaxHealth;
							}
						}
					} // ends if statement
				} // ends for loop
			} // ends for loop
		} // ends PowerUpCollision

		/**
		 * Detects when a enemy bullet collides with the player.
		 * @return void This method should not return anything.
		 */
		private function PlayerCollision(): void {
			for (var i: int = 0; i < enemyBullets.length; i++) {
				var dx: Number = player.x - enemyBullets[i].x;
				var dy: Number = player.y - enemyBullets[i].y;
				var dis: Number = Math.sqrt(dx * dx + dy * dy);

				/** If enemy bullet and player hit, decrease player health */
				if (dis < player.radius + enemyBullets[i].radius) {
					hitSound.play();
					if (bossWave) {
						playerCurrentHealth -= 2;
					} else {
						playerCurrentHealth--;
					}
					enemyBullets[i].isDead = true;
				}
			} // ends for loop

			for (var j: int = 0; j < enemyTanks.length; j++) {
				var dx2: Number = player.x - enemyTanks[j].x;
				var dy2: Number = player.y - enemyTanks[j].y;
				var dis2: Number = Math.sqrt(dx2 * dx2 + dy2 * dy2);

				/** If enemy tank and player hit, decrease health. */
				if (dis < player.radius + enemyTanks[j].radius) {
					hitSound.play();
					delayHits--;
					if (delayHits <= 0) {
						if (bossWave) {
							playerCurrentHealth -= 2;
						} else {
							playerCurrentHealth--;
						}
						delayHits = 10000;
					}
				}
			}

			if (playerCurrentHealth <= 0) {
				player.isDead = true;
			}
		} // ends PlayerCollision
	} // ends class
} // ends package