package  
{
	import Playtomic.*;
	
	import org.flixel.FlxPreloader;
	public class Preloader extends SapphireSkiesPreloader
	{
		
		public function Preloader() 
		{
			Log.View(2003, "af73296f34014f54", root.loaderInfo.loaderURL);
			className = "MainGame";
			//myURL = "file:///Users/zachgoldstein/Desktop/"
			//myURL = "http://reindeerflotilla.net"
			super();
		}
		
	}

}