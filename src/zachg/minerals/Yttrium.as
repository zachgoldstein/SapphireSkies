package zachg.minerals
{
	import zachg.Mineral;
	
	public class Yttrium extends Mineral
	{
		public function Yttrium()
		{
			super();
			fullName = "Yttrium"; 
			description = "Strong and slightly rare, this mineral forms the basis of many unique building materials";
			imageName = "UICargoIconIron";
			rupeeValue = 4;
			resourceValue = 5;
			weight = 1;
			probability = 1-0.5;
		}
	}
}