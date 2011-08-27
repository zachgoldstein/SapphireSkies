package zachg.minerals
{
	import zachg.Mineral;
	
	public class Exceediplutoriumite extends Mineral
	{
		public function Exceediplutoriumite()
		{
			super();
			fullName = "Exceediplutoriumite"; 
			description = "All weapons need warheads. Exceediplutoriumite go boom boom. ";
			imageName = "UICargoIconIron";
			rupeeValue = 4;
			resourceValue = 7;
			weight = 1;
			probability = 1-0.4;
		}
	}
}