package com.vexhel
{
	
	/**
	* ...
	* @author Vexhel
	*/
	public class FlxPathfindingNode {
		public var x:int;
		public var y:int;
		public var g:int = 0;
		public var h:int = 0;
		public var f:int = 0;
		public var cost:int;
		public var parent:FlxPathfindingNode = null;
		public var walkable:Boolean;


		function FlxPathfindingNode(x:int, y:int, walkable:Boolean=true)	{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
	}
}

