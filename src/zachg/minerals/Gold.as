package zachg.minerals
{
	import zachg.Mineral;
	
	public class Gold extends Mineral
	{
		public function Gold()
		{
			super();
			fullName = "Gold Ore"; 
			description = "Always valuable and rarely usefull, an odd combination, but it sure is real pretty.";
			imageName = "UICargoIconGold";
			rupeeValue = 10;
			resourceValue = 10;
			weight = 20;
			probability = 0.25;
		}
	}
}