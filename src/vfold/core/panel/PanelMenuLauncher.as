/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {

import com.greensock.TweenMax;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.display.images.Icon;
import vfold.utilities.ColorModifier;

public class PanelMenuLauncher extends CoreView {

    // Clicked Boolean
    private var cB:Boolean = false;
    // Tween Max
    private var TM:TweenMax;
    // Logo Bitmap
    private var bL:Bitmap=new Icon.VFoldMenu;
    // Height
    private var h:Number;

    public function PanelMenuLauncher():void {
        var c:Object=ColorModifier.hexToRGB(Core.color);
        TweenMax.to(bL,0,{colorTransform:{redOffset:c.red,greenOffset:c.green,blueOffset:c.blue}});
        addChild(bL);
        h=Core.panelHandler.contentHeight;
        x=5;
        alpha=.8;

        addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
        addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);

        TweenMax.to(this,0,{glowFilter:{color:0xFFFFFF, blurX:30, blurY:7,alpha:1,strength:1.3}});
        TM=TweenMax.to(this,.15,{paused:true,glowFilter:{blurX:7, blurY:7,alpha:1}});
    }
    public function changeLogo(logo:Bitmap):void{
        if(logo)bL.bitmapData=logo.bitmapData;
        y=(height-bL.height)/2;
    }
    private function onMouseDown(e:MouseEvent = null):void {
        if(cB){
            cB=false;
            Core.panelHandler.menu.fadeOut();
            onBtnOut();
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
        }
        else {
            onBtnOver();
            Core.panelHandler.menu.fadeIn();
            cB=true;
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
        }
    }
    private function onStageDown(e:Event):void{if(e.target!=this){onMouseDown()}}
    private function onBtnOver(e:MouseEvent=null):void{if(!cB)TM.play()}
    private function onBtnOut(e:MouseEvent=null):void{if(!cB)TM.reverse()}

    override public function get width():Number {return x*2+super.width}
    override public function get height():Number {return h}

}
}