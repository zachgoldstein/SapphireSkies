package zachg.minerals
{
	import zachg.Mineral;
	
	public class Gadolinite extends Mineral
	{
		public function Gadolinite()
		{
			super();
			fullName = "Gadolinite"; 
			description = "Gadzooks. This gargantuan mineral formation looks like it'd make perfect armor.";
			imageName = "UICargoIconIron";
			rupeeValue = 5;
			resourceValue = 8;
			weight = 1;
			probability = 1-0.7;
		}
	}
}