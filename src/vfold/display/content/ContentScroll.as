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

class ContentThumbnail extends Sprite{

    private var bg:Shape=new Shape();
    private const tg:uint=6;
    private var w:Number=9;
    private var h:Number=20;
    private var c:uint;
    private var ssf:Function;
    private var smf:Function;

    public function ContentThumbnail(color:uint,onScrollStart:Function,onScrollMoving:Function):void{
        c = color;
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
