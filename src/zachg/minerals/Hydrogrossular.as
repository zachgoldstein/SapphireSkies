package zachg.minerals
{
	import zachg.Mineral;
	
	public class Hydrogrossular extends Mineral
	{
		public function Hydrogrossular()
		{
			super();
			fullName = "Hydrogrossular"; 
			description = "A glowing apparition decries the value of this blue stone. It'd make a good energy conduit.";
			imageName = "UICargoIconIron";
			rupeeValue = 4;
			resourceValue = 9;
			weight = 1;
			probability = 1-0.8;
		}
	}
}