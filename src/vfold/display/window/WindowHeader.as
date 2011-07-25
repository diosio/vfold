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
import flash.events.MouseEvent;
import vfold.display.text.TextSimple;
import vfold.utility.ColorUtility;


public class WindowHeader extends Sprite {

    // Title
    private var tT:TextSimple=new TextSimple(13,0xFFFFFF,true);
    // Color
    private var cUI:uint=0;
    // Background
    private var bSH:Shape=new Shape;
    // Radius
    private var R:uint;
    // Width
    private var w:Number;
    // Minimize Window Button
    private var mwB:ButtonMinimize;

    public function WindowHeader(radius:uint=22) {

        R=radius;
        mwB=new ButtonMinimize(R-12);

        tT.y=(radius-tT.height)/2;
        mwB.y=(radius-mwB.height)/2;

        addChild(bSH);
        addChild(tT);
        //TODO: Fix minimize button
        //addChild(mwB);

        mwB.addEventListener(MouseEvent.MOUSE_DOWN,minimize);
    }

    private function drawBackground(g:Graphics):void{

        g.clear();
        g.beginFill(cUI,1);
        g.moveTo(0,R);
        g.curveTo(0,0,R,0);
        g.lineTo(width-R,0);
        g.curveTo(width,0,width,R);
        g.lineTo(0,R);
        g.endFill();
        g.lineStyle(2,ColorUtility.brightness(cUI,.8),1,true);
        g.moveTo(0,R);
        g.curveTo(0,0,R,0);
        g.lineTo(width-R,0);
        g.curveTo(width,0,width,R);
    }
    public function minimize():void {

    }
    public function set color(value:uint):void{

        cUI=value;
    }
    public function set titleText(value:String):void{

        tT.text=value;
        positionText();
    }
    override public function set width(value:Number):void {

        w=value;
        positionText();
        drawBackground(bSH.graphics);
    }
    private function positionText():void{

        tT.x=(w-tT.width)/2;
        mwB.x=w-mwB.width-(R-mwB.width);
    }
    override public function get width():Number {

        return w;
    }
    override public function set alpha(value:Number):void {

        bSH.alpha = value;
    }
    override public function get alpha():Number {

        return bSH.alpha;
    }

    override public function get height():Number {
        return R;
    }
}
}

import flash.display.Shape;
import flash.events.MouseEvent;
import vfold.controls.button.Button;
import vfold.utility.GraphicUtility;

class ButtonMinimize extends Button{

    private var ovA:Number=.8;
    private var otA:Number=.4;
    private var a:Shape = new Shape;

    public function ButtonMinimize(size:uint):void{

        GraphicUtility.arrowDown(a.graphics,size,size);
        addChild(a);

        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);

        alpha=otA;
    }
    override protected function onOver():void {

        alpha=ovA;
    }
    override protected function onOut():void {

        alpha=otA;
    }
    override protected function selectAction():void {

        otA=.7;
        onOut();
    }
    override protected function deselectAction():void {

        otA=.4;
        onOut();
    }
}
