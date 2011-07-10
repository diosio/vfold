/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.dashboard{

import com.greensock.TweenMax;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.system.Capabilities;

import vfold.core.Core;
import vfold.core.CoreView;
import vfold.display.assets.Images;
import vfold.utilities.ColorModifier;

public class DashboardWallpaper extends CoreView {

    // Wallpaper
    private var wl:Bitmap;

    public function DashboardWallpaper() {
        makeWallpaper();
    }
    private function makeWallpaper():void{

        var m:Matrix=new Matrix;
        var t:Bitmap=new Images.WallpaperTile as Bitmap;

        wl=new Bitmap(new BitmapData(Capabilities.screenResolutionX,Capabilities.screenResolutionY,false));

        // x-axis repeats
        var xR:uint=wl.width/t.width+1;
        // y-axis repeats
        var yR:uint=wl.height/t.height+1;

        for (var i:uint=0;i<xR;i++){

            m.tx=i*t.width;

            for (var j:uint=0;j<yR;j++){

                m.ty=j*t.height;

                wl.bitmapData.draw(t,m);
            }
        }
        color=Core.color;
        addChild(wl);
    }
    public function set color(value:uint):void{
        TweenMax.to(wl,0,{colorMatrixFilter:{colorize:ColorModifier.brightness(value,.2),amount:1}});
    }
}
}
