package com
{
	import org.flixel.FlxPoint;

	public class GlobalVariables
	{

		//TODO: combine this class with playerStats class.
		
		public static var gravityAcceleration:FlxPoint = new FlxPoint(0,220);
		public static var showHealthBars:Boolean = false;
		public static var showLevelBars:Boolean = false;
		public static var showMineProgress:Boolean = true;
		
		public static var gameStarted:Boolean = true;
		public static var introShown:Boolean = false;
		public static var doRestart:Boolean = false;
		
		public static var tutorialShown:Boolean = false;
		
		public static var versionNumber:Number = 0.9;
		public static var cheatsUsed:Boolean = false;
		
		public static var globalFrameRate:Number = 60;
		
		public static var showHealthDuration:Number = 10;
		public static var showLevelDuration:Number = 10;
		
		public static var playerTotalScore:Number = 0;
	}
}