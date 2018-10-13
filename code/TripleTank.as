package code {
	
	import flash.display.MovieClip;
	
	
	public class TripleTank extends BasicTank {
		
		
		public function TripleTank() {
			selector = 3;
		}
		
		override public function update(scenePlay: ScenePlay): void {
			if (hitCounter >= 3){
				isDead = true;
			}
			
			// Randomly chooses when tank shoots.
			if (spawnDelay > 0) {
				spawnDelay -= Time.dtScaled;
			} else {
				scenePlay.spawnEnemyBullet(null, null, this);
				spawnDelay = Math.random() * 1.5 + .5;
			}
			
			// Changes its angle and rotation of where it fires so that it shoots at and follows the player.
			var dx: Number = scenePlay.player.x - x;
			var dy: Number = scenePlay.player.y - y;
			var angleToPlayer: Number = Math.atan2(dy, dx);

			velocityY = speed * Math.sin(angleToPlayer);
			velocityX = speed * Math.cos(angleToPlayer);

			angleToPlayer *= 180 / Math.PI;
			rotation = angleToPlayer + 90;

			x += velocityX * Time.dtScaled;
			y += velocityY * Time.dtScaled;
		}
	}
	
}
