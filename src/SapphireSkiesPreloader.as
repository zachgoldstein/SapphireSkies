package
{
	import com.adobe.utils.StringUtil;
	import com.bit101.components.Label;
	import com.bit101.components.Text;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Linear;
	import com.gskinner.motion.easing.Sine;
	import com.senocular.display.duplicateDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import org.flixel.FlxG;
	
	
	/**
	 * This class handles the 8-bit style preloader.
	 */
	public class SapphireSkiesPreloader extends MovieClip
	{
		//[Embed(source="data/logo.png")] protected var ImgLogo:Class;
		
		[Embed(source='../data/fonts/chineseRocksFree.ttf', embedAsCFF="false", fontName="MenuFont", mimeType="application/x-font")] public static var FontForMenus:Class;
		[Embed(source='../data/UI/RFLogo.png')] public var UILogo:Class;
		[Embed(source='../data/UI/logov2lg.png')] public static var UISapphireSkiesLogoLarge:Class;
		[Embed(source='../data/UI/cloud1.png')] public var UICloud1:Class;
		[Embed(source='../data/UI/cloud2.png')] public var UICloud2:Class;
		[Embed(source='../data/UI/cloud3.png')] public var UICloud3:Class;
		[Embed(source='../data/UI/cloud4.png')] public var UICloud4:Class;
		[Embed(source='../data/backgrounds/preloaderBackground.png')] public var UIPreloaderBackground:Class;
		
		/**
		 * @private
		 */
		protected var _init:Boolean;
		/**
		 * Useful for storing "real" stage width if you're scaling your preloader graphics.
		 */
		protected var _width:uint;
		/**
		 * Useful for storing "real" stage height if you're scaling your preloader graphics.
		 */
		protected var _height:uint;
		/**
		 * @private
		 */
		protected var _min:uint;
		
		/**
		 * This should always be the name of your main project/document class (e.g. GravityHook).
		 */
		public var className:String;
		/**
		 * Set this to your game's URL to use built-in site-locking.
		 */
		public var myURL:String;
		public var myURLs:Array = new Array();;
		/**
		 * Change this if you want the flixel logo to show for more or less time.  Default value is 0 seconds.
		 */
		public var minDisplayTime:Number;
		
		public var topText:Label;
		public var topSubText:Text;
		public var bottomText:Label;
		public var _bmpBar:Bitmap;
		public var _buffer:Sprite;
		public var whiteOut:Sprite;
		
		public var RFLogo:DisplayObject;
		public var gameLogo:DisplayObject;
		public var clouds:Sprite;
		public var clouds2:Sprite;
		public var loopBreak:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function SapphireSkiesPreloader()
		{
			minDisplayTime = 0;
			
			stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Check if we are on debug or release mode and set _DEBUG accordingly
			try
			{
				throw new Error("Setting global debug flag...");
			}
			catch(e:Error)
			{
				var re:RegExp = /\[.*:[0-9]+\]/;
				FlxG.debug = re.test(e.getStackTrace());
			}
			myURL = "http://www.flashgamelicense.com";
			myURLs = ["http://www.flashgamelicense.com","https://www.flashgamelicense.com"];
			var tmp:Bitmap;
			
			var isURLValid:Boolean = false;
			for(var i:int = 0 ; i < myURLs.length ; i++){
				if( root.loaderInfo.url.indexOf(myURLs[i]) != -1){
					isURLValid = true;
				}
			}
			if( root.loaderInfo.url.indexOf(myURL) != -1){
				isURLValid = true;
			}	
			if(myURLs.length == 0 && myURL == null){
				isURLValid = true;
			}
			
			if(!FlxG.debug && (myURL != null) && (isURLValid == false ))
			{
				tmp = new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight,true,0xFFFFFFFF));
				addChild(tmp);
				
				var fmt:TextFormat = new TextFormat();
				fmt.color = 0x000000;
				fmt.size = 16;
				fmt.align = "center";
				fmt.bold = true;
				fmt.font = "system";
				
				var txt:TextField = new TextField();
				txt.width = tmp.width-16;
				txt.height = tmp.height-16;
				txt.y = 8;
				txt.multiline = true;
				txt.wordWrap = true;
				txt.embedFonts = true;
				txt.defaultTextFormat = fmt;
				txt.text = "" +
					"FlxG.debug:"+FlxG.debug + " \n " +
					"(myURL.length:" +myURL.length+ " \n " +
					"root.loaderInfo.url.indexOf('myURL'):" + root.loaderInfo.url.indexOf(myURL) + " \n " +
					"Hi there!  It looks like somebody copied this game without my permission.  Just click anywhere, or copy-paste this URL into your browser.\n\n"+myURL+"\n\nto play the game at my site.  Thanks, and have fun! Your current URL is: "+root.loaderInfo.url;
				addChild(txt);
				
				txt.addEventListener(MouseEvent.CLICK,goToMyURL);
				tmp.addEventListener(MouseEvent.CLICK,goToMyURL);
				return;
			}
			_init = false;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function goToMyURL(event:MouseEvent=null):void
		{
			navigateToURL(new URLRequest("http://"+myURL));
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(!_init)
			{
				if((stage.stageWidth <= 0) || (stage.stageHeight <= 0))
					return;
				create();
				_init = true;
			}
			var i:int;
			graphics.clear();
			var time:uint = getTimer();
			if((framesLoaded >= totalFrames) && (time > _min))
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				var mainClass:Class = Class(getDefinitionByName(className));
				if(mainClass)
				{
					var app:Object = new mainClass();
					addChild(app as DisplayObject);
				}
				removeChild(_buffer);
			}
			else
			{
				var percent:Number = root.loaderInfo.bytesLoaded/root.loaderInfo.bytesTotal;
				if((_min > 0) && (percent > time/_min))
					percent = time/_min;
				update(percent);
			}
		}
		
		/**
		 * Override this to create your own preloader objects.
		 * Highly recommended you also override update()!
		 */
		protected function create():void
		{
			_min = 0;
			if(!FlxG.debug)
				_min = minDisplayTime*1000;
			
			_buffer = new Sprite();
			_buffer.scaleX = 1;
			_buffer.scaleY = 1;
			addChild(_buffer);			
			
			var backgroundHolder:DisplayObject = new UIPreloaderBackground();
			_buffer.addChild(backgroundHolder);
			
			clouds = new Sprite();
			
			var cloudLeft:* = new UICloud3();
			cloudLeft.x = 110;
			cloudLeft.y = 0;
			clouds.addChild(cloudLeft);			
			
			var cloudMiddle:* = new UICloud2();
			cloudMiddle.x = 276;
			cloudMiddle.y = 81;
			clouds.addChild(cloudMiddle);
			
			var cloudRight:* = new UICloud1();
			cloudRight.x = 345;
			cloudRight.y = 42;
			clouds.addChild(cloudRight);
			
			clouds2 = new Sprite();
			var cloudLeft2:* = duplicateDisplayObject(cloudLeft);
			var cloudMiddle2:* = duplicateDisplayObject(cloudMiddle);
			var cloudRight2:* = duplicateDisplayObject(cloudRight);
			cloudLeft2.x = 110;
			cloudLeft2.y = 0;
			clouds2.addChild(cloudLeft2);			
			cloudMiddle2.x = 276;
			cloudMiddle2.y = 81;
			clouds2.addChild(cloudMiddle2);
			cloudRight2.x = 345;
			cloudRight2.y = 42;
			clouds2.addChild(cloudRight2);
			
			clouds.x = 40;
			clouds2.x = -600;	
			clouds.y = -40;
			clouds2.y = 40;				
			_buffer.addChild(clouds);
			_buffer.addChild(clouds2);
			
			_bmpBar = new Bitmap(new BitmapData(1,7,false,0x5f6aff));
			_bmpBar.x = 4;
			_bmpBar.y = _height-11;
			_buffer.addChild(_bmpBar);
			
			var greyedOutAreas:Sprite = new Sprite();
			greyedOutAreas.graphics.beginFill(0x000000,0.8)
			greyedOutAreas.graphics.drawRect(0,0,600,55);
			greyedOutAreas.graphics.drawRect(0,450-40,600,40);
			_buffer.addChild(greyedOutAreas);

			topText = new Label(_buffer,Math.round(600/2 - 250),3,"Sapphire Skies is loading, please standby","MenuFont",30,0xFFFFFF);
			topSubText = new Text(_buffer,5,30,"","MenuFont",15,0xFFFFFF,false);
			topSubText.selectable = false;
			topSubText.editable = false;
			topSubText.width = 600-10;
			topSubText.height = 20;
			var textFrmt:TextFormat = topSubText.textField.getTextFormat();
			textFrmt.align = TextFormatAlign.CENTER;
			topSubText.textField.defaultTextFormat = textFrmt;
			
			bottomText = new Label(_buffer,Math.round(600/2 - 250),450-40,"0%","MenuFont",30,0xFFFFFF);
			
			RFLogo = new UILogo();
			gameLogo = new UISapphireSkiesLogoLarge();
			_buffer.addChild(RFLogo);
			RFLogo.x = 600-120;
			RFLogo.y = 450-40-75;
			gameLogo.x = Math.round(stage.stageWidth/2 - gameLogo.width/2);
			gameLogo.y = Math.round(stage.stageHeight/2 - gameLogo.height/2);
			
			whiteOut = new Sprite();
			whiteOut.graphics.beginFill(0xFFFFFF,1);
			whiteOut.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			whiteOut.alpha = 0;
			_buffer.addChild(whiteOut);
			_buffer.addChild(gameLogo);
			
			//continueAnimation();
		}
		
		
		public function continueAnimation(e:Event = null):void
		{
			if(loopBreak == false){
				clouds.x = 0;
				clouds2.x = -600;
				var myTween:GTween = new GTween(clouds, 3, {x:(600)}, {ease:Linear.easeNone});
				var myTween2:GTween = new GTween(clouds2, 3, {x:(0)}, {ease:Linear.easeNone});
				myTween.addEventListener(Event.COMPLETE,continueAnimation,false,0,true);
			}			
		}
		
		/**
		 * Override this function to manually update the preloader.
		 * 
		 * @param	Percent		How much of the program has loaded.
		 */
		protected function update(Percent:Number):void
		{
			bottomText.text = String(Math.round(Percent*100)) + "% ";
			for(var i:int = 0 ; i < (Math.round(Percent*100)%10) ; i++){
				bottomText.text += ".";
			}
			var myTween3:GTween = new GTween(_bmpBar, .5, {scaleX:(Percent*(_width-8))}, {ease:Sine.easeOut});
			if(Percent > 0.99){
				loopBreak = true;
			}
			if(Percent > 0.9)
			{
				whiteOut.alpha = (Percent-0.9)/0.1;
			}
			
			if(Percent < 0.2)
			{
				topSubText.text = "Injecting gameplay with 15 randomly generating, fully destructible levels";
			}
			else if(Percent < 0.3)
			{
				topSubText.text = "Penning an intricate story spanning over 250 dialogues";
			}
			else if(Percent < 0.4)
			{
				topSubText.text = "Fueling mining bots and scattering 10 different cargo items all over the world."
			}
			else if(Percent < 0.5)
			{
				topSubText.text = "Arming 12 powerful ships for aerial combat";
			}
			else if(Percent < 0.7)
			{
				topSubText.text = "Loading payloads into 8 different types of weapons";
			}
			else if((Percent > 0.8) && (Percent < 0.9))
			{
				topSubText.text = "Painting 3 different lush backgrounds";
			}
			else if(Percent > 0.9)
			{
				topSubText.text = "Assembling 4 musical tracks and over 65 sound effects";
			}
						
		}
	}
}
