/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.dashboard{
import com.greensock.TweenLite;
import flash.display.Bitmap;
import flash.events.Event;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.utility.ColorUtility;

public class DashboardFooter extends CoreView {

    // Wallpaper Tile Bitmap
    [Embed(source="/home/raphael/development/IdeaProjects/vfold/libraries/dashboard/assets/logo.dashboard.png")]
    private var Logo:Class;
    // VFold LOGO
    private var vf:Bitmap;

    public function DashboardFooter() {

        vf=new Logo as Bitmap;
        TweenLite.to(vf,0,{colorTransform:{tint:ColorUtility.brightness(Core.color,.7)}});
        addChild(vf);
    }
    override public function get height():Number {return vf.height}
    override public function onStageResize(e:Event = null):void {
    }
}
}
