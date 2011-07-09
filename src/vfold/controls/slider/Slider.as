/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.slider {

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class Slider extends Sprite{

    // Background
    private var bg:Shape=new Shape;
    // Slider
    private var sl:Shape=new Shape;
    // Width
    private var w:Number;
    private var h:Number;
    // Value
    private var v:Number;
    // Toggle
    private var t:Boolean;
    // onChange Function
    private var oc:Function;

    public function Slider(width:Number,height:Number,value:Number,onChange:Function,toggle:Boolean=false){

        oc=onChange;

        v=value;
        w=width;
        h=height;
        t=toggle;

        addChild(bg);
        addChild(sl);

        v=v<0?0:v;
        v=v>1?1:v;

        if(t)v=v<.5?0:1;


        adjust();

        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    private function onMouseDown(e:MouseEvent):void {

        if(t){
            if(v==1){

                v=0;
                drawSlider(sl.graphics,0);
                oc.call(null,0);
            }
            else{

                v=1;
                drawSlider(sl.graphics,w);
                oc.call(null,1);
            }
        }
        else{

            stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        }

    }

    private function onMouseMove(e:MouseEvent):void {
    }

    private function onMouseUp(e:MouseEvent):void {

        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }

    public function adjust():void{

        drawSlider(sl.graphics,v==1?w:0);
        drawBg(bg.graphics);
    }
    public function set value(n:Number):void{

        v=n;
        if(t){
            if(v==1){
                drawSlider(sl.graphics,w);
            }
            else{
                drawSlider(sl.graphics,0);
            }
        }

    }
    private function drawSlider(g:Graphics,w:Number):void{

        g.clear();
        g.beginFill(0xFFFFFF,.83);
        g.drawRect(0,0,w*v,h);
    }
    private function drawBg(g:Graphics,a:Number=.4):void{

        g.clear();
        g.beginFill(0xFFFFFF,a);
        g.drawRect(0,0,w,h);
        g.endFill();
    }
}
}