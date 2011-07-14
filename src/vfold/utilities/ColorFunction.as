/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.utilities {
import vfold.utilities.MathFunction;

public class ColorFunction {

    public function ColorFunction() {
    }
    public static function hexToRGB(hex:Number):Object
    {
        return {
            red: ((hex & 0xFF0000) >> 16),
            green: ((hex & 0x00FF00) >> 8),
            blue: ((hex & 0x0000FF))
        };

    }
    public static function RGBToHex(RGB:Object):uint{

        return RGB.red << 16 | RGB.green << 8 | RGB.blue;
    }


    public static function brightness(rgb:uint, mult:Number):uint {

        return adjustBrightness(rgb, mult*255);
    }
	/**
	 *  Performs a linear brightness adjustment of an RGB color.
	 *
	 *  <p>The same amount is added to the red, green, and blue channels
	 *  of an RGB color.
	 *  Each color channel is limited to the range 0 through 255.</p>
	 *
	 *  @param rgb Original RGB color.
	 *
	 *  @param brite Amount to be added to each color channel.
	 *  The range for this parameter is -255 to 255;
	 *  -255 produces black while 255 produces white.
	 *  If this parameter is 0, the RGB color returned
	 *  is the same as the original color.
	 *
	 *  @return New RGB color.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static function adjustBrightness(rgb:uint, brite:Number):uint
	{
		var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
		var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
		var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);

		return (r << 16) | (g << 8) | b;
	}

    public static function convertHSBtoRGB(hue:Number, saturation:Number,
                                           brightness:Number):uint
    {
        // Conversion taken from Foley, van Dam, et al
        var r:Number, g:Number, b:Number;
        if (saturation == 0)
        {
            r = g = b = brightness;
        }
        else
        {
            var h:Number = (hue % 360) / 60;
            var i:int = int(h);
            var f:Number = h - i;
            var p:Number = brightness * (1 - saturation);
            var q:Number = brightness * (1 - (saturation * f));
            var t:Number = brightness * (1 - (saturation * (1 - f)));
            switch (i) {
                case 0:
                    r = brightness;
                    g = t;
                    b = p;
                    break;
                case 1:
                    r = q;
                    g = brightness;
                    b = p;
                    break;
                case 2:
                    r = p;
                    g = brightness;
                    b = t;
                    break;
                case 3:
                    r = p;
                    g = q;
                    b = brightness;
                    break;
                case 4:
                    r = t;
                    g = p;
                    b = brightness;
                    break;
                case 5:
                    r = brightness;
                    g = p;
                    b = q;
                    break;
            }
        }
        r *= 255;
        g *= 255;
        b *= 255;
        return (r << 16 | g << 8 | b);
    }
    public static function randomColor(hueFrom:Number=0,hueTo:Number=1,saturationFrom:Number=0,saturationTo:Number=1,brightnessFrom:Number = 0,brightnessTo:Number = 1):uint{
        return convertHSBtoRGB(MathFunction.randomNumber(hueFrom,hueTo),MathFunction.randomNumber(saturationFrom,saturationTo),MathFunction.randomNumber(brightnessFrom,brightnessTo));
    }
}
}
