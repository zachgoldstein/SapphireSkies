package zachg.minerals
{
	import zachg.Mineral;
	
	public class GamecubeControl extends Mineral
	{
		public function GamecubeControl()
		{
			super();
			fullName = "Gamecube Controller"; 
			description = "This extremely valuable device is legendary, if only for being downright awkward.";
			imageName = "UICargoIconIron";
			rupeeValue = 8;
			resourceValue = 1;
			weight = 1;
			probability = 1-0.8;
		}
	}
}