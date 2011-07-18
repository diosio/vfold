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
    // Wheel Speed
    private var wS:Number;
    // Mask Height
    private var mH:Number=0;
    // Content Width
    private var cW:Number=0;
    // Content Height
    private var cH:Number=0;

    public function ContentScroll(thumbnailColor:uint=0xFFFFFF):void{
        cnt.mask=mS;
        tS=new ContentThumbnail(onScrollStart,onContentScrolling);
        width=200;
        height=300;
        addEventListener(Event.ADDED_TO_STAGE,init);
        mouseEnabled=false;
    }

    override public function addChild(child:DisplayObject):DisplayObject {
        cnt.addChild(child);
        return null;
    }

    private function init(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE,init);
        draw();
        yoN=0;
        spN = 0;
        cS = 0.9;
        wS = 0.005;
        super.addChild(mS);
        super.addChild(cnt);
        super.addChild(tS);
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
    public function get content():DisplayObject{return cnt}

    public function updateContent():void{
        cW=cnt.width-tS.width;
        tS.x=cW;
        cH=cnt.height;
        updateValues();


    }
    private function updateValues():void{
        cR=cH-mH;
        if(cH>mH){
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
    override public function get height():Number{return mH}
    override public function set height(value:Number):void {
        mH=value;
        tR=mH-tS.height;
        updateValues();
    }
}
}