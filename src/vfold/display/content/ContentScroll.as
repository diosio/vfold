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
    private var cnt:DisplayObject;
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
    // Wheel Speed
    private var wS:Number;
    // Mask Height
    private var mH:Number=0;
    // Content Width
    private var cW:Number=0;
    // Content Height
    private var cH:Number=0;
    // Minimum Width
    private var mnW:Number=100;
    // Minimum Height
    private var mnH:Number=100;

    public function ContentScroll(content:DisplayObject,thumbnailColor:uint=0xFFFFFF):void{
        cnt=content;
        cnt.mask=mS;
        cH=cnt.height;
        tS=new ContentThumbnail(onScrollStart,onContentScrolling);
        width=200;
        height=300;
        addEventListener(Event.ADDED_TO_STAGE,init);
        cnt.addEventListener(Event.RESIZE,onContentResize);
        mouseEnabled=false;
    }
    private function init(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE,init);
        draw();
        yoN=0;
        spN = 0;
        cS = 0.9;
        wS = 0.005;
        addChild(mS);
        addChild(cnt);
        addChild(tS);
    }
    private function drawMask(g:Graphics):void{
        g.clear();
        g.beginFill(0,1);
        g.drawRect(0,0,cW,mH);
        g.endFill();
    }
    private function onStageMouseWheel(event:MouseEvent):void {
        spN -= event.delta * wS;
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
        if (value)cnt.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
        else cnt.removeEventListener(MouseEvent.MOUSE_WHEEL, onStageMouseWheel);
    }
    public function get thumbnail():ContentThumbnail{return tS}
    private function onContentResize(e:Event):void{
        cW=cnt.width;
        cH=cnt.height;
        cR=cH-mH;
        tS.x=cW;
        if(cnt.height>mH){
            if(!tS.enabled)tS.enabled=true;
            cnt.y=-spN*cR;
            tS.height=(mH*mH)/cH;
            tR=mH-tS.height;
            tS.y=spN*tR;
        }
        else{
            tS.enabled=false;
            cnt.y=0;
            tS.y=0;
            tS.height=mH;
            tR=mH-tS.height;
        }
        draw();
    }
    public function get minimumWidth():Number{return mnW}
    public function get minimumHeight():Number{return mnH}
    override public function set x(value:Number):void {super.x=value}
    override public function set y(value:Number):void {super.y=value}
    override public function get height():Number{return mH}
    override public function set height(value:Number):void {
        mH=value;
        tR=mH-tS.height;
        cR=cH-mH;
    }
    override public function get width():Number{return cW+tS.width}
    override public function set width(value:Number):void {
        cW=value-tS.width;
        draw();
    }
}
}