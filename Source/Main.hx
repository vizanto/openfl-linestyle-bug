import flash.display.Sprite;
import flash.display.Graphics;
import flash.geom.Point;

class Main extends Sprite
{
	public function new () {
		super ();
		var blub = new SpeechBubble(solidLine);
		addChild(blub);	
		blub.x = blub.y = 100;

		var blub2 = new SpeechBubble(radialGradientLine);
		addChild(blub2);	
		blub2.x = 100;
		blub2.y = 200;

		var blub3 = new SpeechBubble(linearGradientLine);
		addChild(blub3);	
		blub3.x = 100;
		blub3.y = 280;
	}

	function solidLine(g:Graphics) {
		g.lineStyle( SpeechBubble.lineWidth, 0, 1, true );
	}

	function radialGradientLine (g:Graphics) {
		var mat = new flash.geom.Matrix();
		var colors : Array<UInt> = [0xFF0000,0x000000];
		var alphas = [1., 1.];
		var ratios = [0,255];
		g.lineStyle( SpeechBubble.lineWidth );
		mat.createGradientBox(200, 80, 0, 0, 0);
		g.lineGradientStyle(flash.display.GradientType.RADIAL, colors, alphas, ratios, mat);
	}

	function linearGradientLine (g:Graphics) {
		var mat = new flash.geom.Matrix();
		var colors : Array<UInt> = [0xFF0000,0x000000];
		var alphas = [1., 1.];
		var ratios = [0,255];
		g.lineStyle( SpeechBubble.lineWidth );
		mat.createGradientBox(200, 80, 0, 0, 0);
		g.lineGradientStyle(flash.display.GradientType.LINEAR, colors, alphas, ratios, mat);
	}
}


enum Direction {
	Left;
	Right;
}

class SpeechBubble extends flash.display.Sprite
{
	static public var lineWidth = 8.0;

	//How many pixles the corner should take
	static private var cornerPixles : Float = 12;
	//Arrow offsets
	private var arrowOffset : Float = 40;
	//Arrow height
	static private var arrowHeight : Float = 15;
	//Arrow width
	static private var arrowWidth : Float = 25;

	var lineStyle : Graphics -> Void;

	function new(lineStyle) {
		this.lineStyle = lineStyle;
		super();
		drawBubble( 200, 40, Right );
	}

		//Draws a speechbubble
	private function drawBubble( bubbleWidth : Float, bubbleHeight: Float, arrowDirection : Direction ) {
		//Create a sprite
		var surroundings  = new Sprite();
		var g = surroundings.graphics;
		//Calcualate limits
		var lineLengthX : Float = bubbleWidth - (2 * cornerPixles);
		var lineLengthY : Float = bubbleHeight - (2 * cornerPixles);

		var arrowStart : Float;

		if ( arrowDirection == Direction.Left ) {
			arrowStart = arrowOffset;
		} else {
			arrowStart = lineLengthX - arrowOffset;
		}

		//First draw an roundrect
		//We draw our own since we don't want a line where the arrow's at.
		lineStyle(g);
		g.beginFill( 0xF1F1F1, 1 );
		g.moveTo( cornerPixles, 0 );
		g.lineTo( bubbleWidth - cornerPixles, 0 );
		g.curveTo( bubbleWidth, 0, bubbleWidth, cornerPixles );
		g.lineTo ( bubbleWidth, bubbleHeight - cornerPixles );
		g.curveTo( bubbleWidth, bubbleHeight, bubbleWidth - cornerPixles, bubbleHeight );

		if ( arrowDirection == Direction.Left ) {
			g.lineTo( cornerPixles + arrowStart, bubbleHeight );
		} else {
			g.lineTo( cornerPixles + arrowStart + arrowWidth, bubbleHeight );
		}

		//Invisible where the arrow is
		g.lineStyle( 1.0, 0x000000, 0, true );

		if ( arrowDirection == Direction.Left ) {
			g.lineTo( cornerPixles + arrowStart - arrowWidth, bubbleHeight );
		} else {
			g.lineTo( cornerPixles + arrowStart, bubbleHeight );
		}
		//Draw with black again
		lineStyle(g);
		g.lineTo( cornerPixles, bubbleHeight );
		g.curveTo( 0, bubbleHeight, 0, bubbleHeight - cornerPixles );
		g.lineTo ( 0, cornerPixles );
		g.curveTo( 0, 0, cornerPixles, 0);
		g.endFill();

		//Place it correctly
		surroundings.x = 0;
		surroundings.y = 0;

		//Add it to the canvas
		this.addChild( surroundings );

		//Create the arrow
		var arrow = drawSpeechArrow(new Point ( cornerPixles + arrowStart, bubbleHeight ), arrowDirection );

		//Add it to the canvas
		this.addChild( arrow );
	}

	//Draws the arrow down to the face of the speaker
	private function drawSpeechArrow ( startPoint : Point, arrowDirection : Direction) : Sprite {
		var arrow = new Sprite();
		var g = arrow.graphics;
		var lean : Float = 0.8;
		var lean2 : Float = 0.6;

		lineStyle(g);
		g.beginFill( 0xF1F1F1, 1. );
		g.moveTo( startPoint.x, startPoint.y );

		if ( arrowDirection == Direction.Right ) {
			g.lineTo( startPoint.x + ( lean * arrowWidth ), startPoint.y + arrowHeight);
			g.lineTo( startPoint.x + ( lean2 * arrowWidth ) , startPoint.y );
			g.lineTo( startPoint.x + arrowWidth, startPoint.y );

		} else {
			g.lineTo( startPoint.x - ( lean * arrowWidth ), startPoint.y + arrowHeight);
			g.lineTo( startPoint.x - ( lean2 * arrowWidth ) , startPoint.y );
			g.lineTo( startPoint.x - arrowWidth, startPoint.y );
		}

		//Close the arrow for the fill with an invisible line
		g.lineStyle( 1.0, 0xFFFFFF, 0, true );
		g.lineTo ( startPoint.x, startPoint.y );
		g.endFill();

		arrow.x = 0;
		arrow.y = 0;

		return arrow;
	}

}