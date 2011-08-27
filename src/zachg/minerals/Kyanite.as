package zachg.minerals
{
	import zachg.Mineral;
	
	public class Kyanite extends Mineral
	{
		public function Kyanite()
		{
			super();
			fullName = "Kyanite"; 
			description = "Crystalized and beautiful, this material can drive a man mad. Good for communications devices.";
			imageName = "UICargoIconIron";
			rupeeValue = 6;
			resourceValue = 10;
			weight = 1;
			probability = 1-0.7;
		}
	}
}