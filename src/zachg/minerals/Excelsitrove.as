package zachg.minerals
{
	import zachg.Mineral;
	
	public class Excelsitrove extends Mineral
	{
		public function Excelsitrove()
		{
			super();
			fullName = "Excelsitrove"; 
			description = "The unique weight constraints of an aerial society requires this light mineral.";
			imageName = "UICargoIconIron";
			rupeeValue = 5;
			resourceValue = 7;
			weight = 1;
			probability = 1-0.5;
		}
	}
}