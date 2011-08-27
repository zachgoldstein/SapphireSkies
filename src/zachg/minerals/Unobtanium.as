package zachg.minerals
{
	import zachg.Mineral;
	
	public class Unobtanium extends Mineral
	{
		public function Unobtanium()
		{
			super();
			fullName = "Unobtanium"; 
			description = "An existential crisis decided to embed itself in rock, it doesn't know if it even exists.";
			imageName = "UICargoIconIron";
			rupeeValue = 3;
			resourceValue = 4;
			weight = 1;
			probability = 1-0.4;
		}
	}
}