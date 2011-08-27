package zachg.minerals
{
	import zachg.Mineral;
	
	public class Dirt extends Mineral
	{
		public function Dirt()
		{
			super();
			fullName = "Dirt"; 
			description = "You dug up 2.5 tons of dirt and you found... 2.5 tons of dirt, lucky you.";			
			imageName = "UICargoIconDirt";
			rupeeValue = 1;
			resourceValue = 1;
			weight = 10;
			probability = 0.75;
		}
	}
}