/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.display.window {

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import vfold.utilities.ColorUtility;

public class WindowSimple extends Sprite{

    // Border Thickness
    private var bTh:uint=10;
    // Border Color
    private var bCl:uint=0xFFFFFF;
    // Border Alpha
    private var bAl:Number=.8;
    // Border Container
    private var bCn:Sprite=new Sprite;

    // Content Background Shape
    private var cbS:Shape=new Shape;
    // Window Background Shape
    private var wbS:Shape=new Shape;

    // Content
    private var cnt:Sprite;
    // Header
    private var wH:WindowHeader;

    // X Offset
    private var xO:Number;
    // Y Offset
    private var yO:Number;

    // Width
    private var w:Number;
    // Height
    private var h:Number;


    public function WindowSimple(content:Sprite):void {

        cnt=content;

        wH=new WindowHeader();

        width=200;
        height=300;

        addEventListener(Event.ADDED_TO_STAGE,init);
    }
    private function init(e:Event):void{

        removeEventListener(Event.ADDED_TO_STAGE,init);

        wH.color=bCl;
        cnt.x=bTh;
        cnt.y=wH.height+bTh;

        wbS.alpha=bAl;
        wH.alpha=bAl;

        wH.width=width;

        bCn.addChild(wbS);
        bCn.addChild(wH);

        addChild(bCn);
        addChild(cbS);
        addChild(cnt);

        bCn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }
    public function draw():void{

        drawWindowBackground(wbS.graphics);
        drawContentBackground(cbS.graphics);
    }
    private function onMouseDown(e:MouseEvent):void {

        yO = parent.mouseY - y;
        xO = parent.mouseX - x;

        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }
    private function onMouseMove(e:MouseEvent):void {

        x = parent.mouseX - xO;
        y = parent.mouseY - yO;

        if (y < 0) y = 0;
        else if (y > stage.stageHeight-parent.y-wH.height-bTh) y = stage.stageHeight-parent.y-wH.height-bTh;

        if (x < -xO) x = -xO;
        else if (x > stage.stageWidth-xO) x = stage.stageWidth-xO;
    }
    private function onMouseUp(e:MouseEvent):void {

        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }
    private function drawContentBackground(g:Graphics):void{

        g.clear();
        g.beginFill(ColorUtility.brightness(bCl,.75),1);
        g.drawRect(bTh,wH.height+bTh,cnt.width,cnt.height);
        g.endFill();
    }
    private function drawWindowBackground(g:Graphics):void{

        var h:Number=height-bTh;

        g.clear();
        g.lineStyle(2,ColorUtility.brightness(bCl,.8),1,true);
        g.beginFill(bCl,1);
        g.moveTo(0,wH.height);
        g.lineTo(0,h);
        drawFooter(g,0,height-bTh,width,bTh);
        g.lineTo(width, wH.height);
        g.lineTo(0, wH.height);
        g.endFill();
    }
    private function drawFooter(g:Graphics,x:Number,y:Number,width:Number,height:Number):void{

        var w:Number=x+width;
        var h:Number=y+height;

        g.moveTo(x,y);
        g.curveTo(x,h,height,h);
        g.lineTo(w-height,h);
        g.curveTo(width,h,width,y);
    }

    public function set titleText(value:String):void{

        wH.titleText=value;
    }
    public function minimize():void{

    }
    override public function get width():Number {

        return w;
    }
    override public function set width(value:Number):void {

        w=value;
        cnt.width = w-bTh*2;
    }
    override public function get height():Number {

        return h;
    }
    override public function set height(value:Number):void {

        h=value;
        cnt.height = h-bTh*2-wH.height;
    }
    protected function get borderThickness():uint{

        return bTh;
    }
    protected function set borderThickness(value:uint):void{

        bTh=value;
    }
    protected function get borderColor():uint{

        return bCl;
    }
    protected function set borderColor(value:uint):void {

        bCl=value;
    }
    protected function get borderAlpha():Number{

        return bAl;
    }
    protected function set borderAlpha(value:Number):void{

        bAl=value;
    }
}
}
