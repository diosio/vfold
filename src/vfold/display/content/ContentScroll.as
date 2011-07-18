/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.display.content {

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import com.greensock.TweenLite;

public class ContentScroll extends Sprite {

    //content
    private var cnt:Sprite = new Sprite;
    //mask
    private var mS:Shape=new Shape;
    // Thumbnail
    private var tS:ContentThumbnail;
    // Thumbnail Range
    private var tR:Number;
    // Y Offset
    private var yoN:Number;
    // Scroll Percentage
    private var spN:Number;
    // Content Range
    private var cR:Number;
    // Content Speed
    private var cS:Number;
    // Mask Height
    private var mH:Number=0;
    private var we:Boolean=false;
    private var wa:Boolean=false;

    public function ContentScroll(color:uint=0xFFFFFF):void{
        cnt.mask=mS;
        tS=new ContentThumbnail(color,onScrollStart,onContentScrolling);
        width=200;
        height=300;
        addEventListener(Event.ADDED_TO_STAGE,init);
    }
    private function init(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE,init);
        draw();
        yoN=0;
        spN = 0;
        cS = 0.9;
        super.addChild(mS);
        super.addChild(cnt);
        super.addChild(tS);
    }
    private function drawMask(g:Graphics):void{
        g.clear();
        g.beginFill(0,1);
        g.drawRect(0,0,tS.x,mH);
        g.endFill();
    }
    private function onStageMouseWheel(event:MouseEvent):void {
        spN -= event.delta*mH/1000;
        //set boundaries:
        if (spN > 1) spN = 1;
        if (spN < 0) spN = 0;
        moveContent();
        tS.y=spN*tR;
    }
    private function onScrollStart():void {
        yoN = tS.parent.mouseY - tS.y;
    }
    private function onContentScrolling():void {
        tS.y = tS.parent.mouseY-yoN;
        //restrict the movement of the thumb:
        if (tS.y < 0) tS.y = 0;
        if (tS.y > tR) tS.y = tR;
        //calculate scrollPercent and make it do stuff:
        spN = (tS.y) / tR;
        moveContent();
    }
    private function moveContent():void{TweenLite.to(cnt,cS,{y:-(spN * cR)})}
    public function reset():void {
        tS.y=0;
        cnt.y=0;
        spN=0;
    }
    private function draw():void{
        drawMask(mS.graphics);
    }
    public function get scrollPercentage():Number{return spN}
    public function set wheelEnabled(value:Boolean):void {
        we=value;
        wheelActive=wa;
    }
    public function set wheelActive(value:Boolean):void{
        wa=value;
        if (wa)addEventListener(MouseEvent.MOUSE_WHEEL,onStageMouseWheel);
        else removeEventListener(MouseEvent.MOUSE_WHEEL,onStageMouseWheel);
    }
    public function get thumbnail():DisplayObject{return tS}
    public function get content():Sprite{return cnt}

    public function updateContent():void{
        tS.x=cnt.width-tS.width;
        updateValues();
    }
    override public function get height():Number{return mH}
    override public function set height(value:Number):void {
        mH=value;
        tR=mH-tS.height;
        updateValues();
    }
    override public function set width(value:Number):void {
        tS.x=value-tS.width;
        draw();
    }
    private function updateValues():void{
        cR=cnt.height-mH;
        if(cnt.height>mH){
            if(we&&!wa){
                wheelActive=true;
            }
            if(!tS.enabled)tS.enabled=true;
            cnt.y=-spN*cR;
            tS.height=(mH*mH)/cnt.height;
            tR=mH-tS.height;
            tS.y=spN*tR;
        }
        else{
            if(we&&wa){
                wheelActive=false;
            }
            tS.enabled=false;
            cnt.y=0;
            tS.y=0;
            tS.height=mH;
            tR=mH-tS.height;
        }
        draw();
    }
}
}
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

import vfold.utilities.ColorFunction;

class ContentThumbnail extends Sprite{
    // Background Shape
    private var bs:Shape=new Shape();
    // Thumb Shape
    private var ts:Shape=new Shape();
    // Thumb Width
    private var w:Number=9;
    // Thumb Color
    private var tc:uint;
    // Background Color
    private var bc:uint;
    // on Scroll Start Function
    private var ssf:Function;
    // on Scroll Moving Function
    private var smf:Function;
    // Gap
    private const gap:int=1;

    public function ContentThumbnail(color:uint,onScrollStart:Function,onScrollMoving:Function):void{
        tc=color;
        bc=ColorFunction.brightness(tc,-0.5);
        ssf=onScrollStart;
        smf=onScrollMoving;
        addChild(bs);
        addChild(ts);
        ts.x=ts.y=gap;
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
    public function adjust(height:Number,thumbHeight:Number):void{
        var g:Graphics=bs.graphics;
        g.clear();
        g.beginFill(bc);
        drawShape(g,w,height);
        g = ts.graphics;
        g.clear();
        g.beginFill(tc);
        drawShape(g,w-gap*2,thumbHeight-gap*2);
    }
    override public function get height():Number{return ts.height+gap*2}
    private function drawShape(g:Graphics,width:Number,height:Number):void{
        var w:Number = x+width,h:Number = y+height;
        g.beginFill(bc);
        g.curveTo(w,0,w,w);
        g.lineTo(w,h-w);
        g.curveTo(w,h,0,h);
        g.lineTo(0,0);
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
