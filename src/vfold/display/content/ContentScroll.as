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
    //Mask Graphics
    private var g:Graphics=mS.graphics;
    // ScrollBar
    private var sb:ScrollBar;
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
    // ScrollBar Gap
    private const sg:int=3;
    // Scroll Bar Height
    private var sh:Number;
    private var w:Number;

    public function ContentScroll(color:uint=0xFFFFFF):void{
        cnt.mask=mS;
        sb=new ScrollBar(color,onScrollStart,onContentScrolling);
        sb.y=sg;
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
        super.addChild(sb);
    }
    private function draw():void{
        g.clear();
        g.beginFill(0,1);
        g.drawRect(0,0,sb.visible?sb.x-sg:w,mH);
        g.endFill();
    }
    private function onStageMouseWheel(event:MouseEvent):void {
        spN -= event.delta*mH/1000;
        //set boundaries:
        if (spN > 1) spN = 1;
        if (spN < 0) spN = 0;
        moveContent();
        sb.thumbY=spN*tR;
    }
    private function onScrollStart():void {
        yoN = sb.parent.mouseY - sb.thumbY;
    }
    private function onContentScrolling():void {
        sb.thumbY = sb.parent.mouseY-yoN;
        //restrict the movement of the thumb:
        if (sb.thumbY < 0) sb.thumbY = 0;
        if (sb.thumbY > tR) sb.thumbY = tR;
        //calculate scrollPercent and make it do stuff:
        spN = (sb.thumbY) / tR;
        moveContent();
    }
    private function moveContent():void{TweenLite.to(cnt,cS,{y:-(spN * cR)})}
    public function reset():void {
        sb.thumbY=0;
        cnt.y=0;
        spN=0;
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
    public function get thumbnail():DisplayObject{return sb}
    public function get content():Sprite{return cnt}
    public function get barGap():int{return sb.visible?sg:0}

    public function updateContent():void{
        sb.x=cnt.width-sb.width-sg;
        updateValues();
    }
    override public function get height():Number{return mH}
    override public function set height(value:Number):void {
        mH=value;
        tR=mH-sb.thumbHeight;
        updateValues();
    }
    override public function set width(value:Number):void {
        w=value;
        sb.x=value-sb.width-sg;
        draw();
    }
    public function get maskWidth():Number {
        return mS.width;
    }

    private function updateValues():void{
        cR=cnt.height-mH;
        sh = mH-sg*2;
        if(cnt.height>mH){
            if(!sb.visible)sb.visible=true;
            if(we&&!wa)wheelActive=true;
            cnt.y=-spN*cR;
            sb.adjust(sh,(sh*mH)/cnt.height);
            tR=sh-sb.thumbHeight;
            sb.thumbY=spN*tR;
        }
        else{
            if(sb.visible)sb.visible=false;
            if(we&&wa){
                wheelActive=false;
            }
            cnt.y=0;
        }
        draw();
    }
}
}
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

import vfold.utilities.ColorUtility;

class ScrollBar extends Sprite{
    // Background Shape
    private var bs:Shape=new Shape();
    // Thumb Shape
    private var ts:Sprite=new Sprite();
    // Thumb Width
    private var w:Number=10;
    // Background Color
    private var bc:uint;
    // on Scroll Start Function
    private var ssf:Function;
    // on Scroll Moving Function
    private var smf:Function;
    // Gap
    private const gap:int=2;
    private var tc:uint;

    public function ScrollBar(color:uint,onScrollStart:Function,onScrollMoving:Function):void{
        tc=color;
        bc=ColorUtility.brightness(tc,-.3);
        ssf=onScrollStart;
        smf=onScrollMoving;
        addChild(bs);
        addChild(ts);
        ts.x=ts.y=gap;
        ts.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrollStart);
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
        g.drawRoundRect(0,0,w,height,w);
        g.endFill();
        g = ts.graphics;
        g.clear();
        g.beginFill(tc);
        g.drawRoundRect(0,0,w-(gap*2),thumbHeight-(gap*2),w-(gap*2));
        g.endFill();
    }
    public function get thumbHeight():Number{return ts.height+gap*2}
    public function set thumbY(value:Number):void{
        ts.y = value+gap;
    }
    public function get thumbY():Number{
        return ts.y-gap;
    }
    override public function get width():Number {
        return w;
    }
}
