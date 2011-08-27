package zachg.minerals
{
	import zachg.Mineral;
	
	public class Diasporium extends Mineral
	{
		public function Diasporium()
		{
			super();
			fullName = "Diasporium"; 
			description = "Formed in a single casket deep in the earth, the crystals burst the vein and threw this mineral everywhere.";
			imageName = "UICargoIconIron";
			rupeeValue = 5;
			resourceValue = 6;
			weight = 1;
			probability = 1-0.6;
		}
	}
}