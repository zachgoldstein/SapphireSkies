package zachg.minerals
{
	import zachg.Mineral;
	
	public class JeremyClarkson extends Mineral
	{
		public function JeremyClarkson()
		{
			super();
			fullName = "The Ghost of Jeremy Clarkson"; 
			description = " The fossilized remains of jeremy clarkson stand over piers morgan's body, with gasoline and a match.";
			imageName = "UICargoIconIron";
			rupeeValue = 8.5;
			resourceValue = 1;
			weight = 1;
			probability = 1-0.9;
		}
	}
}