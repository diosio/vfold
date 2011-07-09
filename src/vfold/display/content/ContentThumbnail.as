/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.display.content {

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class ContentThumbnail extends Sprite{

    private var bg:Shape=new Shape();
    private const tg:uint=6;
    private var w:Number=9;
    private var h:Number=20;
    private var c:uint=0xFFFFFF;
    private var ssf:Function;
    private var smf:Function;

    public function ContentThumbnail(onScrollStart:Function,onScrollMoving:Function):void{
        addChild(bg);
        drawShape(bg.graphics);
        ssf=onScrollStart;
        smf=onScrollMoving;
        addEventListener(MouseEvent.MOUSE_DOWN,this.onScrollStart);
    }
    private function onScrollStart(e:MouseEvent):void {
        ssf.call(null);
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onContentScrolling);
        stage.addEventListener(MouseEvent.MOUSE_UP,onContentStopScrolling);
    }
    private function onContentScrolling(e:MouseEvent):void {
        smf.call(null);
        e.updateAfterEvent();
    }
    private function onContentStopScrolling(e:MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onContentScrolling);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onContentStopScrolling);
    }
    override public function set width(value:Number):void {
        w=value;
        drawShape(bg.graphics);
    }
    override public function set height(value:Number):void {
        h=value;
        drawShape(bg.graphics);
    }
    override public function get height():Number{return h}
    override public function get width():Number{return w+tg}
    private function drawShape(g:Graphics):void{
        g.clear();
        g.beginFill(c,1);
        g.drawRoundRect(tg,0,w,h,w);
        g.endFill();
    }
    public function get enabled():Boolean{return alpha==1}

    public function set enabled(value:Boolean):void{
        if(value){
            alpha=1;
        }
        else{
            alpha=.5;
        }
    }
}
}
