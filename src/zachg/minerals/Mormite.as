package zachg.minerals
{
	import zachg.Mineral;
	
	public class Mormite extends Mineral
	{
		public function Mormite()
		{
			super();
			fullName = "Crude Mormite"; 
			description = "You struck brown gold! It will take a catalytic cracking plant to turn this into something 'fit for human consumption', but even in it's current crude form, Mormite is still delicious on toast.";
			imageName = "UICargoIconMormite";
			rupeeValue = 7;
			resourceValue = 7;
			weight = 1;
			probability = .2;
		}
	}
}