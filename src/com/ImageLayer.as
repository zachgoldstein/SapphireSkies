package com
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * NOTE that the name of the image layer within the DAME editor has to correspond to the
	 * embed Class name.
	 *  
	 * @author zachgoldstein
	 *  
	 */ 
	public class ImageLayer extends FlxSprite	{
		public function ImageLayer(X:Number,Y:Number,scrollX:Number,scrollY:Number, embedName:String)
		{
			super(X,Y);
			x = X;
			y = Y;
			if(Resources[embedName] != null){;
				loadGraphic(Resources[embedName],false,false);
			}
			scrollFactor = new FlxPoint(scrollX,scrollY);
		}
	}
}
