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

		/** Checks if the game is still in wave one. */
		var waveOne: Boolean = true;

		/** Checks if the game is still in wave two. */
		var waveTwo: Boolean = false;

		/** Checks if the game is still in wave three. */
		var waveThree: Boolean = false;

		/** Checks if the game is ready to spawn the boss. */
		var bossWave: Boolean = false;

		/** Checks if wave one has ended. */
		var waveOneEnd: Boolean = false;

		/** Checks if wave two has ended. */
		var waveTwoEnd: Boolean = false;

		/** Checks if wave three has ended. */
		var waveThreeEnd: Boolean = false;

		/** Checks if boss wave has ended. */
		var bossWaveEnd: Boolean = false;

		/** Instantiates the Player object. */
		public var player: Player;

		public var bossHealth: BossHealth = new BossHealth();

		/** Helps determine which powerup will spawn. */
		var powerSelector: int = 0;

		/** The number frames to wait before spawning the next enemy object. */
		var delaySpawn: int = 0;

		/** The number frames to wait before spawning the next Bullet object. */
		var delayBullets: int = 0;

		/** The number frames to wait before spawning the next powerup object. */
		var delayPowerUps: int = (Math.random() * 240 + 240); // 10 to 20 seconds;

		var enemyCounter: int = 0;

		private var enemySelector = 0;

		/** Max Health of the player. */
		var playerMaxHealth: Number = 10;

		/** Current Health of the player. */
		var playerCurrentHealth: Number = playerMaxHealth;

		/** Max Health of the boss. */
		var bossMaxHealth: Number = 50;

		/** Current Health of the boss. */
		var bossCurrentHealth: Number = bossMaxHealth;

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

			Time.update(); // Update Time

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

			// Player wins if they defeat the boss!
			if (bossWaveEnd) return new SceneWin();

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
		 * Spawns each wave of enemy tanks to the scene.
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
		}

		/**
		 * Spawns the second wave of enemies.
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
		}

		/**
		 * Spawns the third wave of enemies.
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
		}

		/**
		 * Spawns the final boss.
		 */
		private function spawnBoss(): void {
			if (enemyCounter < 1){
				var b: Boss = new Boss();
				addChild(b);
				enemyTanks.push(b);
			}
			enemyCounter++;
		}

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
		public function spawnEnemyBullet(basicTank: BasicTank = null, doubleTank: DoubleTank = null, tripleTank: TripleTank = null, boss: Boss = null): void {
			if (basicTank) {
				var e: EnemyBullet = new EnemyBullet(player, basicTank);
				addChild(e);
				enemyBullets.push(e);
			} else if (doubleTank) {
				var f: EnemyBullet = new EnemyBullet(player, null, doubleTank);
				f.x -= 15;
				addChild(f);
				enemyBullets.push(f);

				var f2: EnemyBullet = new EnemyBullet(player, null, doubleTank);
				f2.x += 15;
				addChild(f2);
				enemyBullets.push(f2);
			} else if (tripleTank) {
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
			} else if (boss) {
				var h: EnemyBullet = new EnemyBullet(player, null, null, null, boss);
				h.scaleX *= 5;
				h.scaleY *= h.scaleX;
				addChild(h);
				enemyBullets.push(h);
			}
		} // ends spawnEnemyBullet

		/**
		 * Decrements the delayPowerUps countdown timer.  When it hits 0, it spawns a random powerup.
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
		 * Updates enemies for every frame.
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
		}

		/** The double shot power up function.
		 * Spawns two bullets simultaneously next to each other when the user clicks the left mouse button.
		 */
		private function doubleShot(): void {
			var b: Bullet = new Bullet(player);
			b.x -= 20;
			addChild(b);
			bullets.push(b);

			var b2: Bullet = new Bullet(player);
			b2.x += 20;
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
		 * Detects collision for enemy tanks, bullets, player, and powerups.
		 */
		private function collisionDetection(): void {
			EnemyCollision();
			PowerUpCollision();
			PlayerCollision();
		} // ends collisionDetection

		private function EnemyCollision(): void {
			for (var i: int = 0; i < enemyTanks.length; i++) {
				for (var j: int = 0; j < bullets.length; j++) {

					var dx: Number = enemyTanks[i].x - bullets[j].x;
					var dy: Number = enemyTanks[i].y - bullets[j].y;
					var dis: Number = Math.sqrt(dx * dx + dy * dy);
					if (dis < enemyTanks[i].radius + bullets[j].radius) {
						// collision!
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

		private function PowerUpCollision(): void {
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
		} // ends PowerUpCollision

		private function PlayerCollision(): void {
			for (var m: int = 0; m < enemyBullets.length; m++) {
				var dx3: Number = player.x - enemyBullets[m].x;
				var dy3: Number = player.y - enemyBullets[m].y;
				var dis3: Number = Math.sqrt(dx3 * dx3 + dy3 * dy3);

				/** If enemy bullet and player hit, increase player hit counter. */
				if (dis3 < player.radius + enemyBullets[m].radius) {
					if (bossWave) {
						playerCurrentHealth -= 2;
					}
					else {
						playerCurrentHealth--;
					}
					enemyBullets[m].isDead = true;
				}

				if (playerCurrentHealth <= 0) {
					player.isDead = true;
				}
			} // ends for loop
		} // ends PlayerCollision
	} // ends class
} // ends package