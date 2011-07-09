/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.utilities {

public class ColorModifier {

    public function ColorModifier() {
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
    public static function brightness(color:uint,multiplier:Number):uint{

        var rgb:Object=hexToRGB(color);
        var m:Number=multiplier;

        if(m<0)m=0;
        else if (m>1)m=1;

        rgb.red=getMultipliedColor(rgb.red,m);
        rgb.green=getMultipliedColor(rgb.green,m);
        rgb.blue=getMultipliedColor(rgb.blue,m);

        return RGBToHex(rgb);
    }
    private static function getMultipliedColor(color:uint,multiplier:Number):uint{

        return color+multiplier*(255-color);
    }
 }
}
