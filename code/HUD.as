package code {
	
	import flash.display.MovieClip;
	
	
	public class HUD extends MovieClip {
		
		
		public function HUD() {
			// constructor code
		}
		
		public function update(game:ScenePlay): void {
			parent.setChildIndex(this, parent.numChildren - 1);
			
			if (game.waveOne == true){
				waveCounter.text = "Wave: 1/3";
			}
			else if (game.waveTwo == true){
				waveCounter.text = "Wave: 2/3";
			}
			else if (game.waveThree == true){
				waveCounter.text = "Wave: 3/3";
			}
			else if (game.bossWave == true){
				waveCounter.text = "BOSS HEALTH";
				game.addChild(game.bossHealth);
				game.bossHealth.x = 835;
				game.bossHealth.y = 570;
				
				waveCounter.x = 590;
				waveCounter.y = 465;
			}
			
			healthbar.barColor.scaleX = game.playerCurrentHealth / game.playerMaxHealth;
			
			game.bossHealth.bossBarColor.scaleX = game.bossCurrentHealth / game.bossMaxHealth;
		}
	}
	
}
