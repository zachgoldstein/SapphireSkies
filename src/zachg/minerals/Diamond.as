package zachg.minerals
{
	import zachg.Mineral;
	
	public class Diamond extends Mineral
	{
		public function Diamond()
		{
			super();
			fullName = "Diamond"; 
			description = "The hardest material ever known, and the source of countless ancient conflicts and lost lives";
			imageName = "UICargoIconIron";
			rupeeValue = 10;
			resourceValue = 7;
			weight = 1;
			probability = 1-0.95;
		}
	}
}