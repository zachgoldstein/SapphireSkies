package zachg.minerals
{
	import zachg.Mineral;
	
	public class Whiskey extends Mineral
	{
		public function Whiskey()
		{
			super();
			fullName = "A Flask of Ancient Drambull Whiskey"; 
			description = "In ancient times, a crew of explorers got lost. 150 years later, their whisky appears again.";
			imageName = "UICargoIconIron";
			rupeeValue = 7;
			resourceValue = 1;
			weight = 1;
			probability = 1-0.7;
		}
	}
}