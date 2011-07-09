/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget {
import flash.display.Sprite;
import flash.events.Event;
import vfold.core.Core;

public class Notifier extends Sprite {
    private var nV:Vector.<Notification>=new Vector.<Notification>();
    private var i:uint;
    public function notify(text:String):void{
        nV.push(new Notification());
        i=nV.length-1;
        addChild(nV[i]);
        nV[i].index=i;
        nV[i].cI=getChildIndex(nV[i]);
        nV[i].label=text;
        nV[i].addEventListener("exiting",popNotification);
        nV[i].addEventListener("exited",removeNotification);
    }
    private function popNotification(e:Event):void{
        if(nV.length!=1){
            for(var a:uint=e.target.constructor.vI+1;a<nV.length;a++){
                nV[a].index--;
            }
        }
        nV.splice(e.target.constructor.vI,1);
    }
    private function removeNotification(e:Event):void{
        removeChildAt(e.target.constructor.cI);
    }
}
}
import com.greensock.TweenMax;
import vfold.controls.button.ButtonLabel;
import flash.events.Event;

class Notification extends ButtonLabel{
    private var d:Number=.4;
    public var cI:uint;

    override public function set label(value:String):void {
        super.label = value;
        x=-width;
        tween();
    }
    private function tween():void{

        TweenMax.killTweensOf(this);
        TweenMax.to(this,d,{alpha:1,y:-index*(height+3)-height,onComplete:onNotifyComplete});
    }
    private function onNotifyComplete():void{
        TweenMax.killTweensOf(this);
        TweenMax.to(this,d,{alpha:0,y:-index*(height+3),onStart:onStart,onComplete:onComplete,delay:8});
    }
    private function onStart():void{dispatchEvent(new Event("exiting"));}
    private function onComplete():void{dispatchEvent(new Event("exited"));}
}
