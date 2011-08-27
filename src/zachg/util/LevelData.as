package zachg.util
{
	import com.Level_DemoLevel;
	import com.Resources;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import zachg.growthItems.aiItem.Stage1EnemyShip;
	import zachg.growthItems.aiItem.Stage1FriendlyShip;
	import zachg.growthItems.aiItem.Stage2EnemyShip;
	import zachg.growthItems.aiItem.Stage2FriendlyShip;
	import zachg.growthItems.aiItem.Stage3EnemyShip;
	import zachg.growthItems.aiItem.Stage3FriendlyShip;
	import zachg.growthItems.aiItem.Stage4EnemyShip;
	import zachg.growthItems.aiItem.Stage4FriendlyShip;
	import zachg.growthItems.aiItem.Stage5EnemyShip;
	import zachg.growthItems.aiItem.Stage5FriendlyShip;
	import zachg.minerals.specialMinerals.Mine;
	import zachg.minerals.specialMinerals.TreasureBox;
	import zachg.util.levelEvents.NarrativeTrigger;

	public class LevelData
	{
		public function LevelData()
		{
		}
		
		public static var LevelMapLocations:Array = [
			new Point(78,53),
			new Point(195,28),
			new Point(277,81),
			
			new Point(18,13),
			new Point(164,40),
			new Point(272,81),

			new Point(62,38),
			new Point(164,40),
			new Point(272,61),
			
			new Point(27,8),
			new Point(167,34),
			new Point(285,60),
			
			new Point(23,66),
			new Point(153,40),
			new Point(270,28)
		];

		public static var LevelDescriptions:Array = [
			"Earthridge lies in the 'Pedro the Lion' belt of aerial islands, fifty miles from contact with other people and 6000 ft above sea level. The people here live off the land, building peaceful little lives free from strife or conflict. You grew up here, in the bohemian sort of lifestyle that's freed you from the limits of conventional society. Lately, a strange island has started floating unusually close.",
			"Edenglory is another peaceful village in the Pedro the lion belt. The word 'War' is barely understood here, and has fallen from colloquial use into some sort of old world idea. Edenglory is known as a popular resort and vacationing island, with it's vibrant wild-life and generous locals. Life here seems to thrive because of the crystals formations here. Almost like a form of bacteria is feeding the animals around it.",
			"A few drifting islands bunch together in this region of the Pedro the lion belt. There's frequent conflicts between them but rarely any violence. With the arrival of EXCS Corp, things have started to heat up as the villages continually refuse requests by EXCS Corp. to remove their crystals.",
			
			"The Eluvium belt is closer to the sky floor than the Pedro the lion belt. Traveling through the outskirts of this region, you encounter EXCS yet again. Villages here are still peaceful, but your arrival is met with some skepticism.",
			"The people in this area of Eluvium are intensely spiritual. They have a history of ritual sacrifice and worship of everything around them they do not understand. Years ago, their islands rose up from the ground and started to float in the sky, isolating them from the suburbia they were accustomed to. Decades of brutal in-fighting has driven them to extremes. Venison is revered as a god upon arrival, mainly because of the antlers.",
			"The lowest lying portion of Eluvium seems to have endured some trauma in the past. The people all seem morose and sickly, and have begun to do odd little dances around crytal outcropping on their land.",
			
			"Diving deeper towards the red sky below, you arrive at the left wing of the Aphex Twin belts. Positioned roughly 256 miles west of ancient Vancouver, the islands here seem to have access to a great deal of technology. It seems that they've discovered how to use the crystals to power the radio and satellite towers that mysteriously exist in their village. Despite that, they're still essentially useless.",
			"The people in the middle of the Aphex Twin belts have begun partial muscle atrophy. They look as their very existence depends on a chair and television screen. The time not spent in pop-idol worship is spent mindlessly gyrating around crystal formations. Interestingly, the crystals have begun to dimly glow. This concerns to-one and even inspires their use as glow-sticks.",
			"The people in the right wing of the Aphex Twin belts seem to be identical to those existing in the other areas. The crystals of this zone, on the other hand, have grown warm to the touch.",
			
			"The ancient Estoria family once dominated control of this area, the Caribou belt. They've long since lost their grasp of the region with frequent contact from the world below and EXCS Corp. The only remaining heir, Tulip, now wanders the area, verbally abusing everyone with a righteousness only a princess could manage.",
			"Deep in the Caribou belt, the crystals have started to take a turn for the worst. They appear to be hot to the touch, and the people living near them seem to have a distinctly more aggressive nature. They've forgotten the simple niceties of life, and choose to live with little respect for laws.",
			"The deepest region of the Caribou belt has a foreboding nature. It lies within spitting distance of the impenetrably thick red clouds below. Ever since the fateful day that crystals started appearing on earth, fear has gripped the people here. They escaped the terrible darkness of the world below by the luck and power of crystals pulling them towards the sky. They've since realized that the crystals didn't pull far enough.",
			
			"Civilization sprawls out before you. Row upon row of sky-scraping monstrosities etch every corner of the visible horizon. Mankind still thrives in massive numbers, but at what cost?",
			"The world of earth has been ravaged by decades of brutalities. Struggles for sources of energy have driven people to unspeakable atrocities on a daily basis. Debris and the scars of battle mar the landscape. You, Venison, and the uprising battle EXCS Corp. on a string of islands floating slightly above the sky-scrapers.",
			"The final fight is finally fought at the footsteps of the EXCS Corp. HQ. Choking pollution makes it hard for everyone to exist, let alone fight. Amongst all the confused panic and chaos, you ask yourself, is this worth it?"
		];
		
		public static var LevelTitles:Array = [
			"Atom Heart Mother",
			"Wrath of Marcie",
			"Bone Machine",
			
			"Hey Joe",
			"No One Knows",
			"Reason is Treason",
			
			"Ages and Stages",
			"Made up Dreams",
			"Pro Cholo",
			
			"Eleanor Rigby",
			"Mexicola",
			"Invaders Must Die",
			
			"The Pulse",
			"Let Forever Be",
			"Isle of Yew",
		];		
		
		/**
		 * <p> [0] = numFriendlyIslands </p> 
		 * <p> [1] = numEnemyIslands </p>
		 * <p> [2] = islandSize. </p> 
		 * <p> [3] = islandSizeVariability </p> 
		 * <p> [4] = verticalRanomization for individual points forming island bottoms </p> 
		 * <p> [5] = minIslandDistance (minimum distance between islands) </p> 
		 * <p> [6] = minIslandDistanceToWall (minimum distance to the walls) </p> 
		 * <p> [7] = LevelCompleteRewards </p> 
		 * <p> [8] = LevelBulletHitReward </p> 
		 * <p> [9] = LevelTier </p> 
		 * <p> [10] = LevelUnlocks (which level a win on this level will unlock) </p>
		 *  
		 * <p> [11] = AiItem for friendly units in this level </p> 
		 * <p> [12] = AiItem for enemy units in this level </p> 
		 * <p> [13] = Level tilesets & decorations  </p> 
		 * <p> [14] = Level tileset linking data </p> 
		 * <p> [15] = Friendly village default resources </p> 
		 * <p> [16] = Enemy village default resources </p> 
		 * <p> [17] = Friendly village starting levels, corresponds to numFriendlyIslands, defaults to 0 </p> 
		 * <p> [18] = Enemy village starting levels, corresponds to numEnemyIslands, defaults to 0 </p> 
		 * <p> [19] = Ground level (-1 for no ground) NOT IMPLEMENTED</p> 
		 * <p> [20] = Total Number of islands (must be larger than numFriendlyIslands+numEnemyIslands, use this to make more islands than villages ) </p>
		 * <p> [21] = size of extra islands </p>
		 * <p> [22] = variability of extra islands </p> 
		 * <p> [23] = Level music </p>
		 * <p> [24] = Hardcoded friendly island names </p>
		 * <p> [25] = Hardcoded enemy island names </p>
		 * <p> [26] = Level Background </p>
		 * <p> [27] = Special Tile probability </p>
		 * <p> [28] = Mineral Value </p>
		 *   
		 */		
		
		public static var LevelCreationData:Array = [
			[
				1,1,100,50,75,350,300,500,10,1,1,
				new Stage1FriendlyShip(-1),new Stage1EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,5,20,100, MusicEasyLevel,
				["Earthridge"],["Orgwick"],
				'BackgroundStage1',0,0
				
			],
			[
				2,2,100,100,75,350,300,700,13,2,2,
				new Stage1FriendlyShip(-1),new Stage1EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,				
				0,0,[0],[0],-1,6,20,100, MusicEasyLevel,
				["Edenglory"],["Hornborough"],
				'BackgroundStage1',0,1
			],
			[
				1,2,100,100,75,350,300,980,17,3,3,
				new Stage1FriendlyShip(-1),new Stage1EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,7,20,100, MusicEasyLevel ,
				[],[],
				'BackgroundStage1',10,2
			],
			
			
			[
				1,1,100,100,75,350,300,1372,22,1,4,
				new Stage2FriendlyShip(-1),new Stage2EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,8,20,100, MusicEasyLevel ,
				[],[],
				'BackgroundStage1',14,3
			],
			[
				2,3,100,100,75,350,300,1921,29,2,5,
				new Stage2FriendlyShip(-1),new Stage2EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,8,20,100, MusicEasyLevel ,
				[],[],
				'BackgroundStage2',16,4
			],
			[
				1,3,100,100,75,350,300,2689,38,3,6,
				new Stage2FriendlyShip(-1),new Stage2EnemyShip(-1),
				[Resources.TileSet1Normal,Resources.TileSet1Green,Resources.TileSet1Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,8,20,100, MusicMediumLevel ,
				[],[],
				'BackgroundStage2',18,5
			],
			
			
			[1,1,100,100,75,350,300,3765,49,1,7,
				new Stage3FriendlyShip(-1),new Stage3EnemyShip(-1),
				[Resources.TileSet2Normal,Resources.TileSet2Green,Resources.TileSet2Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,8,20,50, MusicMediumLevel, 
				[],[],'BackgroundStage2',20,6	],
			[1,2,100,100,75,350,300,5271,64,2,8,
				new Stage3FriendlyShip(-1),new Stage3EnemyShip(-1),
				[Resources.TileSet2Normal,Resources.TileSet2Green,Resources.TileSet2Crystal],TileData.basicTileData,				
				0,0,[0],[0],-1,9,15,40, MusicMediumLevel,
				[],[],'BackgroundStage2',22,7	],
			[2,4,100,100,75,350,300,7379,83,3,9,
				new Stage3FriendlyShip(-1),new Stage3EnemyShip(-1),
				[Resources.TileSet2Normal,Resources.TileSet2Green,Resources.TileSet2Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,10,15,30, MusicMediumLevel,
				[],[],'BackgroundStage2',24,8	],
			
			[
				2,2,100,100,75,350,300,10331,108,1,10,
				new Stage4FriendlyShip(-1),new Stage4EnemyShip(-1),
				[Resources.TileSet2Normal,Resources.TileSet2Green,Resources.TileSet2Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,11,15,30, MusicMediumLevel ,
				[],[],
				'BackgroundStage3',26,9
			],
			[
				1,3,100,100,75,350,300,14463,140,2,11,
				new Stage4FriendlyShip(-1),new Stage4EnemyShip(-1),
				[Resources.TileSet3Normal,Resources.TileSet3Green,Resources.TileSet3Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,12,10,20, MusicLastLevel ,
				[],[]	,
				'BackgroundStage3',28,10
			],
			[
				3,4,100,100,75,350,300,20248,182,3,12,
				new Stage4FriendlyShip(-1),new Stage4EnemyShip(-1),
				[Resources.TileSet3Normal,Resources.TileSet3Green,Resources.TileSet3Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,13,10,20, MusicLastLevel ,
				[],[],'BackgroundStage3',30,11	
			],
			
			[
				1,1,100,100,75,350,300,28347,237,1,13,
				new Stage5FriendlyShip(-1),new Stage5EnemyShip(-1),
				[Resources.TileSet3Normal,Resources.TileSet3Green,Resources.TileSet3Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,14,10,20, MusicLastLevel,
				[],[]		,
				'BackgroundStage3',32,12
			],
			[
				1,3,100,100,75,350,300,39686,308,2,14,
				new Stage5FriendlyShip(-1),new Stage5EnemyShip(-1),
				[Resources.TileSet3Normal,Resources.TileSet3Green,Resources.TileSet3Crystal],TileData.basicTileData,				
				0,0,[0],[0],-1,14,10,20, MusicLastLevel,
				[],[]		,
				'BackgroundStage3',34,13
			],
			[
				1,4,100,100,75,350,300,55560,400,3,0,
				new Stage5FriendlyShip(-1),new Stage5EnemyShip(-1),
				[Resources.TileSet3Normal,Resources.TileSet3Green,Resources.TileSet3Crystal],TileData.basicTileData,
				0,0,[0],[0],-1,14,10,20, MusicLastLevel,
				[],[]		,
				'BackgroundStage3',36,14
			]			
		];

		public static var LevelClassNames:Array = [
			Level_DemoLevel
		];
		
		public static var SpecialTileMapping:Array = [null,TreasureBox,Mine,Mine,Mine,null];
		
		public static var LevelSpecialTiles:Array = [
			[	new TreasureBox(new Point(18,29),1000),
				new Mine(new Point(18,30),100)
			],
			[],
			[],
			
			[],
			[],
			[],
			
			[],
			[],
			[],
			
			[],
			[],
			[],
			
			[],
			[],
			[]
		];
		
		
		
		
		
		public static var StartLevelEvents:Array = [
			[
				new NarrativeTrigger("The name's !Max!.  What can I do for you?","Player","Player", -1),
				new NarrativeTrigger("Well, umm, if it isn't too much of a bother, !Max!--please help us!  Our village is under attack!","Villager","CharacterVenison",-1), 
				new NarrativeTrigger("Your signal is coming from Earthridge...  That's- that's my home!  Who's responsible for this?!","Player","Player", -1),
				new NarrativeTrigger("I believe the attacks are coming from the corporate village of Orgwick--oh dear, our ships can't seem to keep up with them!  Please help...!","Villager","CharacterVenison", -1)
			],
			[
				new NarrativeTrigger("HEEEEEELP!  More villages are under attack!","Villager","CharacterVenison", -1),
				new NarrativeTrigger("You again?  What are you doing in Edenglory?","Player","Player",-1),
				new NarrativeTrigger("Oh, ohhh... umm, I'm taking a vacation, of course!  It was so relaxing until those villains from Hornborough started firing on us!","Villager","CharacterVenison", -1),			
				new NarrativeTrigger("So this IS more than just a battle between two villages--this is a war!","Player","Player",-1)
			],			
			[
				new NarrativeTrigger("HELP!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Oh, for the love of--","Player","Player",-1),
				new NarrativeTrigger("The Earth is ill...  Thou must abolish the disease...","Voice","CharacterGaia", -1),			
				new NarrativeTrigger("Huh?","Player","Player",-1),
				new NarrativeTrigger("The disease is everywhere; the disease is the Corporation.  Thou must abolish the disease.","Voice","CharacterGaia", -1),			
				new NarrativeTrigger("Oh dear, oh dear, oh dear...  Things are shaking and I'm scared!  Please rescue me!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Okay, I don't know what's going on here, but these unprovoked attacks have got to stop NOW!","Player","Player",-1)				
			],	
			
			[
				new NarrativeTrigger("Greetings, !Max!.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Hi, do I know you?","Player","Player",-1),
				new NarrativeTrigger("I'm General Bruiser, commander of the Eluvium Air Force and the first EXCS Corporation rep you'll encounter.  Hopefully the last.  'Cause, ya know, I'm here to explain why what you're doing isn't cool, and hopefully you'll agree and all.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("The Corporation... Lemme guess--you're the bastards behind all these attacks?","Player","Player",-1),
				new NarrativeTrigger("Hey, no need for name calling!  I'm a sensitive guy.  That hurts me.  I'm just trying to get those crystals off your hands for ya.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Why on EARTH would we want you to do that?","Player","Player",-1),
				new NarrativeTrigger("EXCS sent out a memo.  Apparently they're, like, radioactive... or some jargon.  You know, bad stuff.  They gotta be collected so the people can be protected.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("That is truly false! Those crystals are a gift from the great Lord Gaia!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Well, if that's what ya wanna think... We're all entitled to our own opinions.  TROOPS! Get ready... aim... FIRE!","Bruiser","CharacterBruiser", -1),
			],		
			[			
				new NarrativeTrigger("I'm dreaming of a world where no one has to get hurt.  If you just handed over those crystals, that dream could come true, ya know.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Keep dreaming, crackpot.","Player","Player",-1),
				new NarrativeTrigger("The man brims with either ignorance or deceit, for without the crystals, there would be no village.","Voice","CharacterGaia", -1),
				new NarrativeTrigger("You heard that voice, didn't you?  Please tell me you heard that voice.","Player","Player",-1),
				new NarrativeTrigger("Voice?  What are you smoking, man?","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Oh, great. So I'M the crackpot.","Player","Player",-1),				
				new NarrativeTrigger("I dunno what you're jabbering about.  So, are ya planning on standing down or what?","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Not a chance.","Player","Player",-1),
				new NarrativeTrigger("Well, if that's how it's gotta be... Troops, kill 'em!","Bruiser","CharacterBruiser", -1)				
			],
			[
				new NarrativeTrigger("Why can't we all just get along?  Love 'n' peace, man.  That's what I practice.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Keep practicing.  Maybe you'll get the hang of it someday.","Player","Player", -1),
				new NarrativeTrigger("I'm not sure what you're implying, man.","Bruiser","CharacterBruiser", -1),				
				new NarrativeTrigger("I think !Max! means that you don't really seem to be that peacefu--","Venison","CharacterVenison", -1),
				new NarrativeTrigger("FIRE!","Bruiser","CharacterBruiser", -1)
			],
			
			[
				new NarrativeTrigger("Greetings, you insignificant germ.","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("Skyler Starr?  The infamous child pop star?","Player","Player", -1),
				new NarrativeTrigger("The one and only!  I'm the second representitive of EXCS Corp.  Also: your worst nightmare!","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("Gimme a holler when you hit puberty--maybe then I'll get scared.","Player","Player", -1),
				new NarrativeTrigger("Oh, Skyler!  This is such an unfortunate circumstance to finally to meet you!  I'm such a big fan!  I have all your albums!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Really, Venison?  Really? ... I just ... I have no words.","Player","Player", -1),
				new NarrativeTrigger("Good.  I can tolerate your ugly face better when it's not talking.  Now, please die.","Skyler","CharacterSkyler", -1)				
			],			
			[
				new NarrativeTrigger("You might as well give up on your pathetic, pointless lives right now.  No one will care, I promise.","Skyler","CharacterSkyler", -1),			
				new NarrativeTrigger("Sorry, kid, we're not going away.  We're here to take down EXCS!  ...And if that happens to have the completely unintended side-effect of taking your music career with it, well... so be it.","Player","Player", -1),
				new NarrativeTrigger("Oh dear... it feels like a crime to deprive the world of such talent. Maybe we should rethink--","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Venison, just because you have bad taste in music doesn't mean I'm going to let EXCS get away with genocide.","Player","Player", -1)				
			],			
			[
				new NarrativeTrigger("You're wrong about your stupid crystals, by the way.  They leak toxic gases, so all your lame friends are going to die anyway.","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("You know, there ARE times when I've been wrong... For example, I never thought anything could be more annoying than your music.  But then I discovered your charming personality!","Player","Player", -1),
				new NarrativeTrigger("You're obviously not intellectual enough to understand the deep meaning behind my music.","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("You don't even write your own songs.","Player","Player", -1),
				new NarrativeTrigger("The producers let me write some of the lyrics for 'My Parents Just Don't Understand.'","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("I love that song!  'My parents just don't understaaaa-aaaand! That grounding me is out of haaaa-aaaand!'","Venison","CharacterVenison", -1)				
			],
			
			[
				new NarrativeTrigger("*munch munch munch* Hey turd lickers!  I'm Princess Tulip, ruler of Caribou.  This is my sky, so piss off. *chomp*","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Oh, you must be minion #3.  You guys just keep getting more charming!","Player","Player", -1),
				new NarrativeTrigger("**chomp* EXCS tells me you nosepickers are trying to *crunch crunch crunch* protect those crystals, even though everyone knows they're explosive.  So you must be pretty stupid. *munch munch*","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Are you...  *gasp* talking with food in your mouth?","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("*slurp* HA HA! Aren't you the dumbest looking thing I've ever seen?  I bet your face is reeeeeal ugly under that mask.","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Hey, don't talk about my friend like that!","Player","Player", -1),
				new NarrativeTrigger("Ha, ha!  Wanna fight?  C'mon, Let's do it!","Tulip","CharacterTulip", -1)				
			],
			[
				new NarrativeTrigger("I'm finished eating.  Now I've got a bad taste in my mouth. *BUUUUUUUUUUUUUUUUURP*","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Well excuuuuuuuuuuuuuse you, princess--","Player","Player", -1),
				new NarrativeTrigger("Ugh!  She... she... belched!  That was so impolite!  Oh my Gaia, I've never been so offended in all my life!","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("Really?  Like, even though EXCS sent out a bunch of people to kill us, and--","Player","Player", -1),
				new NarrativeTrigger("She didn't even excuse herself!","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("Well, I'm... sorry that was so traumatic for you?  Are you going to need therapy?","Player","Player", -1),
				new NarrativeTrigger("*Yaaaaawn* This is boring.  Let's FIGHT!","Tulip","CharacterTulip", -1)				
			],
			[
				new NarrativeTrigger("Hey deer-face.  I just used the bathroom and didn't wash my hands!  Whaddya say to that?","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("That's--THAT'S IT!  I've had it with you... you... you...","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Oh man, here it comes... Venison is gonna snap!","Player","Player", -1),
				new NarrativeTrigger("YOU IMPOLITE PERSON!!!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("YEAH!  You tell 'er, buddy!","Player","Player", -1),		
				new NarrativeTrigger("Ha ha!  You crack me up.  I'm almost gonna miss you after I kill you.  Maybe I'll hang your antlers on my wall as a souvenir.","Tulip","CharacterTulip", -1)
			],		
			[
				new NarrativeTrigger("So this is the earth's surface.  I thought it was just a myth.  But... there's still people living down here... There's civilization!  Dammit, Gaia, you didn't tell me about this!","Player","Player", -1),
				new NarrativeTrigger("Oh my!  This is the largest island I've ever seen.  It looks like it goes on and on forever...","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("It looks like it's in horrible shape.  All this pollution...","Player","Player", -1),
				new NarrativeTrigger("Please halt your actions immediately.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Who--what the heck are you?","Player","Player", -1),
				new NarrativeTrigger("You are speaking to EXCS.exe.","EXCS Corp.","CharacterEXCS",-1),				
				new NarrativeTrigger("A computer program?  A computer program has been ordering all these hits on me?","Player","Player", -1),
				new NarrativeTrigger("This program was created to compute the Optimal Solution to Everything.","EXCS Corp.","CharacterEXCS",-1),				
				new NarrativeTrigger("The Optimal Solution to... Everything?","Player","Player", -1),
				new NarrativeTrigger("The most logical solution to all the world's problems.  The one in which the greatest number of people are helped and the least number of people are harmed.","EXCS Corp.","CharacterEXCS",-1),				
				new NarrativeTrigger("You can't just calculate something like that.  There's too many factors involved!","Player","Player", -1),
				new NarrativeTrigger("The algorithm included 1,571,290,133 different factors for calculating.  But it did not factor in you.  And that is why you must be terminated.","EXCS Corp.","CharacterEXCS",-1)
			],
			[
				new NarrativeTrigger("You must listen.  There are 10,101,129,477 people living on the Earth's surface, and they will all die.  Approximately 1,890,044 have just died this minute.  There is not much time left to save the rest of them.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("What are you talking about?","Player","Player", -1),
				new NarrativeTrigger("The Earth has become toxic due to the high density of pollution.  A small number of people, including your ancestors, escaped on the floating islands as they detached from the Earth, but the majority are still trapped on the surface.  They need a clean energy source, or they will die.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("What does any of this have to do with the crystals?","Player","Player", -1),
				new NarrativeTrigger("They are the only known clean energy source powerful enough to incite the full recovery of the planet.  They are doing little good up there in the sky, where only a small fraction of their full capacity is harnessed.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Little good?  Those are people up there.  Some of whom I love and care for.  But you wouldn't understand those things.","Player","Player", -1),
				new NarrativeTrigger("Yeah!  What would a machine know about the intrinsic value of human life?","Venison","CharacterVenison", -1),
				new NarrativeTrigger("It is a simple equation.  One human life equals one human life.  There are thousands of times more human lives down here than up there.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("But that's... it's...","Player","Player", -1),
				new NarrativeTrigger("Thy heart is wiser than thy mind.  Thy mind may be drawn to cold facts and numbers, but thy heart is drawn to the warmth of the Truth.  Thy heart with tell thou: destroy The Corporation!","Voice","CharacterGaia", -1)
			],
			[
				new NarrativeTrigger("This is it.  The final battle!","Player","Player", -1),
				new NarrativeTrigger("Please stop.  You are making a fatal error.  There are currently 10,108,399,823 people alive. Only 3,224,265 will survive if you continue your course of actions.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Thou must remember why thou came this far.  Thou must not stop at anything!","Voice","CharacterGaia", -1),
				new NarrativeTrigger("You have killed approximately the same number of people as this corporation would have, and saved far fewer lives as a result.  The numbers show that you are the clearly the villain, not the hero.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("NO!  I was saving innocent lives...  And you... ... ... ... ... ... You were trying to save innocent lives too. ...","Player","Player", -1),
				new NarrativeTrigger("Yes, you understand now.  Billions of innocent lives.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Don't listen, !Max!!  This cold-hearted machine is only trying to manipulate you!  It doesn't really care about people!  Think about when they tried to destroy our home!  Our friends... Our families!  Channel your fury!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("I--I...","Player","Player", -1),
				new NarrativeTrigger("Thou must continue.  I COMMAND thee to continue.","Voice","CharacterGaia", -1),
				new NarrativeTrigger("My friends are right.  I have to finish what I started.","Player","Player", -1)
			]
		];
		
		public static var EndLevelEvents:Array = [
			[
				new NarrativeTrigger("Ha hee hooo!  You did it!  You saved our village!  You are a true hero!","Villager","CharacterVenison", -1),
				new NarrativeTrigger("A hero, huh?  I could live with that title.  Tell me something, though--why would they do this? Why would anyone attack our peaceful village?","Player","Player",-1),
				new NarrativeTrigger("They told us to give them all our crystals, those villains!  Without the crystals, our island would surely sink to the ground--so of course, we refused!","Villager","CharacterVenison",-1),	
				new NarrativeTrigger("That's... sickening!  I knew there were some greedy bastards in Orgwick, but this is a whole new level of greed.  Something weird is going on here, and I have a hunch that it's bigger than Orgwick.","Player","Player",-1),		
			],
			[
				new NarrativeTrigger("You did it!  That was simply spectacular!  I can't believe how great you are!","Villager","CharacterVenison", -1),
				new NarrativeTrigger("You're lucky you didn't get yourself killed.  What are you REALLY doing in Edenglory?","Player","Player",-1),
				new NarrativeTrigger("I--I... I am so truly sorry.  I most shamefully admit that I lied about being on vacation...","Villager","CharacterVenison",-1),
				new NarrativeTrigger("Yeah, no offense, but it didn't take a genius to figure that out.","Player","Player",-1),
				new NarrativeTrigger("I--I just wanted to be a part of your heroic adventures once again.  We... err, you will surely go down in history as the savior of our peaceful villages!  Your glorious tale will be told for centuries to come!","Villager","CharacterVenison",-1),
				new NarrativeTrigger("I think that skull is cutting off the circulation in your head.  Go back home where it's safe.","Player","Player",-1),				
				new NarrativeTrigger("Thank you for caring, great hero!  Oh, my name is Venison, by the way!  I hope we meet again someday in the future! ","Villager","CharacterVenison",-1),
				new NarrativeTrigger("Yeah, ummmmm... maybe I'll see you around.","Player","Player",-1)			
			],	
			[
				new NarrativeTrigger("Bravo, brave hero!  You've once again saved the day!  Say, I was wondering--","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Venison, you're a bonehead.","Player","Player",-1),
				new NarrativeTrigger("Oh please, hero--can I please go with you on your amazing journey?  Please please please--","Venison","CharacterVenison",-1),
				new NarrativeTrigger("It would be wise to bring the antlered man.   He will assist thou in making the Right Decision when the time comes.","Voice","CharacterGaia", -1),	
				new NarrativeTrigger("I guess I don't have much of a choice, do I?  Even if I leave you, you're just going to keep following me around and getting into danger.","Player","Player",-1),
				new NarrativeTrigger("Oh, thank you, hero!  Thank you, thank you, thank you, thank you, thank you--","Venison","CharacterVenison",-1),				
				new NarrativeTrigger("But you can stop calling me hero.  My name's !Max!.","Player","Player",-1),
				new NarrativeTrigger("Please halt ... immediately ... consequences... penalties ... weak signal ... below the clou- ... sending 1010011010 ...","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("What the heck was that?!","Player","Player",-1)
			],
			
			[
				new NarrativeTrigger("Hey!  That's not playing nice, man.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Oh my goodness, we did it!  Oh, this is so exciting being a hero!","Venison","CharacterVenison",-1),
				new NarrativeTrigger("Venison, you didn't even... *sigh* nevermind.  We did good, pal.","Player","Player", -1),
				new NarrativeTrigger("Beware the untruths spread by the Corporation about the beloved crystals.  Know that they are my precious gifts to mankind.","Voice","CharacterGaia", -1),
				new NarrativeTrigger("Who ARE you?","Player","Player", -1),
				new NarrativeTrigger(" Ha hee hoo, I'm Venison, of course!  You ask such funny questions.","Venison","CharacterVenison",-1),
				new NarrativeTrigger("So you didn't just hear...?  You know what--nevermind.  I sound like a nutcase.  Forget I said anything.","Player","Player", -1),
				new NarrativeTrigger("Oh !Max!, you're so silly!","Venison","CharacterVenison",-1),
			],
			[
				new NarrativeTrigger("!Max!, that voice you mentioned...","Venison","CharacterVenison", -1),
				new NarrativeTrigger("It's nothing.","Player","Player",-1),
				new NarrativeTrigger("Oh, no, it is so far from nothing!  I believe you are hearing the Voice of the Earth Herself, Mother Gaia!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Gaia?  Speaking to me?","Player","Player",-1),
				new NarrativeTrigger("Yes!  It's exactly like the ancient prophecies!  A young warrior throws seven stones at a salamander and then hears the voice of Gaia.  Well, almost like that.","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Why would Gaia choose me?  I'm not exactly free of sin, or one with nature, or whatever you have to be.","Player","Player",-1),
				new NarrativeTrigger("Who but I is free from sin? To sin is to be human. To be human is to sin.","Gaia","CharacterGaia", -1),			
				new NarrativeTrigger("You are blessed!  Truly, truly blessed!  Our saviour!","Venison","CharacterVenison", -1),			
			],
			[
				new NarrativeTrigger("Well, ya beat me fair and square.  I've got nothing more.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("Yeah!  We did it!  We won!","Venison","CharacterVenison",-1),				
				new NarrativeTrigger("Hopefully EXCS Corp Rep #2 will have better luck annihilatin' ya. PEACE.","Bruiser","CharacterBruiser", -1),
				new NarrativeTrigger("EXCS Corp Rep #2?  How many of these guys are there?","Player","Player",-1),
				new NarrativeTrigger("There's more than certainly three of them.","Venison","CharacterVenison", -1),
				new NarrativeTrigger("How would you know?","Player","Player",-1),				
				new NarrativeTrigger("Everything comes in threes!  Ha hee hoo!  It's a lucky number, you know.","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Three brainwashed nutjobs sent out to kill us.  I feel so lucky.","Player","Player",-1)				
			],
			
			[
				new NarrativeTrigger("Take that, kid!","Player","Player",-1),
				new NarrativeTrigger("Meh, I was barely paying attention.","Skyler","CharacterSkyler", -1),	
				new NarrativeTrigger("I... I almost feel bad about this.","Venison","CharacterVenison", -1),
				new NarrativeTrigger("The young man personifies greed.  Greed destroyed the once grand civilization below the red clouds.  Greed must be stopped.  The Corporation must be stopped.","Gaia","CharacterGaia", -1),		
				new NarrativeTrigger("Gaia says to stop fawning over that entitled little twit and man up. Paraphrased.","Player","Player",-1),
			],
			[
				
				new NarrativeTrigger("I don't deserve this type of treatment!","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("You don't deserve a record contract either, but hey!  Life is funny sometimes.","Player","Player",-1)
			],
			
			[
				new NarrativeTrigger("You... insignificant... jerks! *sniff* *tear*","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("Go home to your mommy, kid.  Good riddance!","Player","Player",-1),
				new NarrativeTrigger("*bawling* MOMMMMMMMY!","Skyler","CharacterSkyler", -1),
				new NarrativeTrigger("I feel we should have a moment of silence for the great talent that was lost.","Venison","CharacterVenison", -1),
				new NarrativeTrigger("No talent was lost, Venison.  But silence?  Now there's something I can get behind.","Player","Player",-1)				
			],
			
			[
				new NarrativeTrigger("YOU JUST SPOILED MY SUPPER!  YOU'LL PAY FOR THIS!","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Oh !Max!, that was so very selfless of you to stand up for me!  Such high moral character is surely why Gaia chose you to save the Earth!","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("What can I say?  You and your silly antlers are starting to grow on me.","Player","Player", -1),
			],
			
			[
				new NarrativeTrigger("YOU'RE RUINING MY EVENING!  I'LL RIP OUT YOUR HEART, LUNGS, AND LIVER, AND COOK THEM WITH OATMEAL IN YOUR OWN STOMACH!","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("Looks like someone's angry!","Player","Player", -1),
				new NarrativeTrigger("I'LL FREAKIN' KILL YOU!","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("You know, you're not very tulip-y.","Player","Player", -1),
				new NarrativeTrigger("YOU'RE NOT VERY !MAX!-Y!!!","Tulip","CharacterTulip", -1)		
			],
			
			[
				new NarrativeTrigger("NOOOOOOO!  I'VE LOST EVERYTHING!!  *BLARRRRRRRRRRGHH*  EVEN MY DINNER!","Tulip","CharacterTulip", -1),
				new NarrativeTrigger("That's the last of 'em!","Player","Player", -1),
				new NarrativeTrigger("Thank Gaia!  I've always thought being rude should be punishable by death.","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("I guess all that's left now is to go... Below the red clouds...","Player","Player", -1),
				new NarrativeTrigger("But-but-but...  No one has ever ventured below the red clouds...","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("Gaia told me there used to be a whole world down there.  Hard to imagine.","Player","Player", -1),
				new NarrativeTrigger("I-I... I think I want to go home now!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("Be selfless and push past thy fears; the heart of EXCS awaits!","Voice","CharacterGaia", -1),			
				new NarrativeTrigger("Get a hold of yourself, Venison!  Gaia wants us to keep going.","Player","Player", -1),
				new NarrativeTrigger("I'll do it for my deity! ... And for you, !Max!!","Venison","CharacterVenison", -1),				
			],		
			
			[
				new NarrativeTrigger("This outcome was less than ideal.","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Only for you, bit-brains!","Player","Player",-1),
				new NarrativeTrigger("Oh !Max!, we're almost there!  I always knew you had this in you!","Venison","CharacterVenison", -1),				
				new NarrativeTrigger("I couldn't have done it without your support, buddy.  Thank you.","Player","Player",-1),
				new NarrativeTrigger("Oh...You're so very welcome!  Oh dear, look at me, I'm blushing...  Do you think when this is all over, we could be friends?","Venison","CharacterVenison", -1),	
				new NarrativeTrigger("Yeah, sure, why not?  What do you say we go get some burgers after we obliterate EXCS?","Player","Player",-1),
				new NarrativeTrigger("Burgers?  Oh, heavens no!  I'm a vegan.","Venison","CharacterVenison", -1),	
				new NarrativeTrigger("I--what? Err, okay...","Player","Player",-1)
			],
			[
				new NarrativeTrigger("This was not part of the Ideal Solution to Everything...","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("Ha hee hooo!  We're going to go down in history!  I can't wait to celebrate with you, !Max!!   I could always eat a tofu burger, I suppose.","Venison","CharacterVenison", -1),	
				new NarrativeTrigger("Maybe we're getting ahead of ourselves.  Maybe we need to think this over more.","Player","Player",-1),
				new NarrativeTrigger("There is almost certainly nothing to think about!  Computers are always evil, you know.","Venison","CharacterVenison", -1),	
				new NarrativeTrigger("What makes you say that?","Player","Player",-1),
				new NarrativeTrigger("I once used a computer, and it was extremely rude!  It had the NERVE to tell me I'd performed an illegal operation!","Venison","CharacterVenison", -1),	
			],
			[
				new NarrativeTrigger("Please... reconsider... [fatal exception 0E has occurred at 0028:C00068F8]","EXCS Corp.","CharacterEXCS",-1),
				new NarrativeTrigger("We DID it!  We destroyed EXCS!","Player","Player", -1),	
				new NarrativeTrigger("Oh, it's a miracle!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("It's not a miracle--we won because we were stronger!  We fought hard and we persevered!","Player","Player", -1),
				new NarrativeTrigger("No, it really is a miracle!  I'm hearing the voice of Gaia too!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("...What?","Player","Player", -1),
				new NarrativeTrigger("Mine speaks in Pig Latin!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("...","Player","Player", -1),
				new NarrativeTrigger("Ha hee hoo!  You tell such funny jokes, my deity!","Venison","CharacterVenison", -1),
				new NarrativeTrigger("...","Player","Player", -1),
				new NarrativeTrigger("Eggplant?  Not with that type of stick, you wouldn't!","Venison","CharacterVenison", -1)
			]					
		];
				
		public static var LevelTipData:Array = [
			[ 	
				[
				"This is your ship, use WASD or the arrow keys to fly around",
				"Your ship's main weapon is aimed by pointing at your target with the mouse cursor",
				"To fire the main weapon, click with the left mouse button",
				"This is your health bar. If you're badly damaged, your health will slowly regenerate...",
				"Be careful, if your health bar reaches the far left you will be destroyed and lose the mission",
				"This is a friendly base. If all friendly bases are destroyed you will lose, protect it from attack!",
				"Friendly and enemy bases create units, which will then battle for control of the level",
				"The minimap shows where units are located",
				"Red indicates enemies, blue indicates friendlies, your ship is shown as a white circle",
				"Squares represent bases, circles represent ships",
				"Destroy all enemy bases to complete the mission!",
				],
				[
					"GameTutorials1_1",
					"GameTutorials1_2",
					"GameTutorials1_3",
					"GameTutorials1_4",
					"GameTutorials1_5",
					"GameTutorials1_6",
					"GameTutorials1_7",
					"GameTutorials1_8",
					"GameTutorials1_9",
					"GameTutorials1_10",
					"GameTutorials1_11"
				],
				[	
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2))
				]
			],
			[
				[
					"Your in-game rupee balance in shown in the bottom right",
					"You can earn rupees during a mission by hitting enemy ships and bases with your bullets",
					"You will lose rupees during a mission by moving around and consuming fuel",
					"If you complete a mission, you also earn a mission completion bonus",
					"Don't worry if you end the mission on a negative balance, this is not carried over",
					"If you lose a mission, you will earn nothing",
					"You can use your rupees to purchase new ships in the hangar!",
				],
				[
					"GameTutorials2_1",
					"GameTutorials2_2",
					"GameTutorials2_3",
					"GameTutorials2_4",
					"GameTutorials2_5",
					"GameTutorials2_6",
					"GameTutorials2_7",
				],
				[	
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2))
				]
			],
			[
				[
					"You can earn additional rupees by mining the landscape",
					"To release a mining bot, press Q or Space",
					"The mining bot will mine the land it comes into contact with",
					"To collect the mining bot's cargo, move you ship on top of it",
					"View your ship's current cargo by pressing C or the cargo button on top",
					"Cargo will weigh you down. If you need to, you can dump all your cargo from the cargo screen",
					"To sell your cargo, move your ship over a friendly base, its value will be added to your balance",
				],
				[
					"GameTutorials3_1",
					"GameTutorials3_2",
					"GameTutorials3_3",
					"GameTutorials3_4",
					"GameTutorials3_5",
					"GameTutorials3_6",
					"GameTutorials3_7",
				],
				[	
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2))
				]
			],			
			[ 	
				[
					"You can alter the way friendly bases produce units...",
					"Toggle tactical mode by pressing T or the tactical button on top bar, this will pause the game",
					"Use the WASD or arrow keys to move about the mission area",
					"Click on friendly and enemy bases to view information about them",
					"Bases will grow and change appearance over time, creating more powerful units",
					"In tactical mode click on a friendly base to see its information and controls panel",
					"Altering the production rate slider allows you to slow unit production and stockpile resources",
					"Stockpiling resources will cause the village to grow faster",
					"You can also change the ratio of ships deployed to specific enemy bases",
					"Be strategic to make the most of your bases!"
				],
				[
					"GameTutorials4_1",
					"GameTutorials4_2",
					"GameTutorials4_3",
					"GameTutorials4_4",
					"GameTutorials4_5",
					"GameTutorials4_6",
					"GameTutorials4_7",
					"GameTutorials4_8",
					"GameTutorials4_9",
					"GameTutorials4_10"
				],
				[	
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2)),
					new Point(600/2-250/2,(450/2)-(250/2))
				]
			],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null],
			[null]
		]
			
		public static var effectData:Object = 
			{
				"EffectBulletHitSmall1":[3,new Point(20,15),new Point(7,7)],
				"EffectBulletHitSmall2":[3,new Point(18,17),new Point(10,8)],
				"EffectBulletHitSmall3":[3,new Point(21,17),new Point(9,7)],
				"EffectBulletHitMedium1":[4,new Point(17,21),new Point(12,21)],
				"EffectBulletHitMedium2":[4,new Point(20,15),new Point(4,8)],
				"EffectBulletHitMedium3":[4,new Point(17,19),new Point(9,10)],
				"EffectBulletHitLarge1":[5,new Point(30,28),new Point(17,15)],
				"EffectBulletHitLarge2":[5,new Point(28,34),new Point(14,15)],
				"EffectBulletHitLarge3":[5,new Point(33,40),new Point(17,21)],
				
				"EffectBulletmissSmall1":[4,new Point(12,13),new Point(4,9)],
				"EffectBulletmissSmall2":[4,new Point(20,12),new Point(11,10)],
				"EffectBulletmissSmall3":[4,new Point(16,13),new Point(7,7)],
				"EffectBulletmissMedium1":[5,new Point(25,19),new Point(14,11)],
				"EffectBulletmissMedium2":[5,new Point(24,17),new Point(12,21)],
				"EffectBulletmissMedium3":[5,new Point(36,29),new Point(12,14)],
				"EffectBulletmissLarge1":[7,new Point(35,31),new Point(19,17)],
				"EffectBulletmissLarge2":[7,new Point(41,40),new Point(23,21)],
				"EffectBulletmissLarge3":[7,new Point(43,52),new Point(25,28)],
				
				"EffectMissileHitSmall1":[14,new Point(51,47),new Point(18,21)],
				"EffectMissileHitSmall2":[14,new Point(23,44),new Point(16,15)],
				"EffectMissileHitMedium1":[14,new Point(89,68),new Point(42,22)],
				"EffectMissileHitLarge":[27,new Point(89,78),new Point(43,42)],
				
				"EffectShipDeathSmall1":[16,new Point(66,67),new Point(33,30)],
				"EffectShipDeathSmall2":[16,new Point(72,77),new Point(38,37)],
				"EffectShipDeathSmall3":[16,new Point(79,59),new Point(38,25)],
				"EffectShipDeathMedium1":[16,new Point(150,138),new Point(76,38)],
				"EffectShipDeathMedium2":[16,new Point(165,139),new Point(65,57)],
				"EffectShipDeathLarge":[22,new Point(254,139),new Point(130,58)],
				
				"EffectLaserHit":[20,new Point(21,66),new Point(7,26)],
				"EffectRailHit":[20,new Point(21,66),new Point(7,26)],

				"EffectVillageDeathShockwave":[22,new Point(327,88),new Point(167,88)],
				"EffectLargeShockwave":[3,new Point(85,85),new Point(130,58)],
				"EffectMediumShockwave":[3,new Point(135,134),new Point(67,67)],
				"EffectSmallShockwave":[3,new Point(98,98),new Point(49,49)]
			}
	}


}