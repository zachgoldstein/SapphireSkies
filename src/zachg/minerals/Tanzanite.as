package zachg.minerals
{
	import zachg.Mineral;
	
	public class Tanzanite extends Mineral
	{
		public function Tanzanite()
		{
			super();
			fullName = "Tanzanite"; 
			description = "This material expands after contact with water. It's like supernatural styrofoam.";
			imageName = "UICargoIconIron";
			rupeeValue = 3;
			resourceValue = 10;
			weight = 1;
			probability = 1-0.6;
		}
	}
}