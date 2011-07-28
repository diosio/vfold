/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.button {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;

import flash.filters.BlurFilter;

import vfold.utility.GraphicUtility;
import vfold.utility.MathUtility;

public class ButtonSymbol extends Button {
    // Background
    private var bg:Shape=new Shape;
    // Circle Radius
    private var rd:Number;
    // Gap
    private var gp:uint=1;
    // Sprite Container
    private var smc:Sprite=new Sprite;
    // Color
    private var cl:uint=0;
    public function ButtonSymbol(){
        bg.alpha=0;
        super.addChild(bg);
        super.addChild(smc);
        smc.mouseEnabled=smc.mouseChildren=false;
    }
    private function draw():void{
        bg.graphics.clear();
        rd=MathUtility.findRadius(smc,gp);
        GraphicUtility.circle(bg.graphics,rd*2,cl,1);
        smc.x=smc.y=rd+1;
    }
    override public function addChild(child:DisplayObject):DisplayObject {
        child.x=-child.width/2;
        child.y=-child.height/2;
        smc.addChild(child);
        draw();
        return null;
    }
    override protected function onOver():void {bg.alpha=1;}
    override protected function onOut():void {bg.alpha=0;}

    public function get background():DisplayObject{return bg}
    public function set color(value:uint):void{cl=value;draw();}
    public function set gap(value:uint):void{gp=value;draw();}
}
}