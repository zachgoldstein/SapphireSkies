package zachg.minerals
{
	import zachg.Mineral;
	
	public class Titanite extends Mineral
	{
		public function Titanite()
		{
			super();
			fullName = "Titanite"; 
			description = "Widespread use of titanium grew rare after the onset of titanite, its 10x lighter, 10x stronger cousin.";
			imageName = "UICargoIconIron";
			rupeeValue = 5;
			resourceValue = 8;
			weight = 1;
			probability = 1-0.7;
		}
	}
}