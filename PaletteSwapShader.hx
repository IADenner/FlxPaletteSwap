package shaders;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets.FlxShader;
import gameTools.things.MySprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author Isaac
 */
class PaletteSwapShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header
	uniform sampler2D mainPalette;
	uniform sampler2D secondPalette;
	
	void main()
	{
		vec4 color = texture2D(bitmap, openfl_TextureCoordv);
		
		//our final color, to be modified as you and I see fit
		vec4 ret = vec4(0);
		//tolerance here is how close the colors have to be for the swapping to take place. Useful for sprites with lots of dithering. 
		float colorTol = 0.15;
		
		//how many pixels are in our sprite strip
		float numSamples = 80.0;	
		
		for (float iterator = 0.0; iterator < numSamples; ++iterator)
		{
			//sample main palette
			vec4 val = texture2D(mainPalette, vec2((iterator) / numSamples, 0.5));
			
			//if sprites color is closer than colorTol to the main palettes current sampled color, 
			if ((distance(color.r, val.r) < colorTol) && (distance(color.g, val.g) < colorTol) && (distance(color.b, val.b) < colorTol) && ret.r == 0 && color.a > 0.2)
				{
					//sample the second palette at the same point weve sampled the first
					vec4 secondVal = texture2D(secondPalette,  vec2((iterator) / numSamples, 0.5));
					ret = secondVal;
				}
		}
		
		//if we havent modified ret, just return our original color
		if (ret == vec4(0)) ret = color;
		
		//prevent swapping alpha
		ret.a = color.a;
		gl_FragColor = ret;
	}
	')

	
	//this takes two 80x1 palettes and swaps them. Change numsamples in the code above to use different palette sizes!
	public function new(tMainPalette:String, tSecondPalette:String) 
	{
		super();
		
		
		//for some reason I couldn't get BitmapData.loadFile() to work
		var mp:MySprite = new MySprite(0, 0, tMainPalette);
		var sp:MySprite = new MySprite(0, 0, tSecondPalette);
		
		
		data.mainPalette.input = mp.graphic.bitmap;
		data.secondPalette.input = sp.graphic.bitmap;
		
		
	}
	

	
}