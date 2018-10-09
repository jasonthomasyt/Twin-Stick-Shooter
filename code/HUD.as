package code {
	
	import flash.display.MovieClip;
	
	
	public class HUD extends MovieClip {
		
		
		public function HUD() {
			// constructor code
		}
		
		public function update(game:ScenePlay): void {
			parent.setChildIndex(this, parent.numChildren - 1);
			
			scoreboard.text = "Score: " + game.score + "/10";
			healthbar.scaleX = game.currentHealth / game.maxHealth;
		}
	}
	
}
