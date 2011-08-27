package zachg.minerals
{
	import zachg.Mineral;
	
	public class Worms extends Mineral
	{
		public function Worms()
		{
			super();
			fullName = "Worms"; 
			//description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ut mauris vel ante suscipit pellentesque. Proin quis massa erat, sed malesuada nulla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nec nisl diam, sed facilisis massa. Donec porta dui a magna porttitor tincidunt. Ut libero arcu, imperdiet in vehicula et, lacinia a mauris. Fusce vulputate viverra aliquam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Quisque vel arcu risus, sed dignissim lacus. Quisque in nibh nulla. Nulla ultrices convallis volutpat. In hac habitasse platea dictumst";
			description = "Eeeew, your mining bot found a can of worms, don't worry someone will take it off your hands. For a price of course. - NOTE: Causes a resonably large loss of Rupees.";
			imageName = "UICargoIconWorms";
			rupeeValue = 2;
			resourceValue = 5;
			weight = 5;
			probability = 0.2;
		}
	}
}