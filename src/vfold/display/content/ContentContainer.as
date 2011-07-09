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
import vfold.core.Core;

public class ContentContainer extends Sprite{

    // Width
    private var w:Number=0;
    // Height
    private var h:Number=0;
    // Background Shape
    private var bg:Shape=new Shape();
    // Background Graphics
    private var g:Graphics=bg.graphics;
    // Container
    private var cn:Sprite=new Sprite;
    // Border
    private var bd:uint=4;
    // Color
    private var cl:uint;
    // Radius
    private var rd:uint=8;

    public function ContentContainer() {
        cl=Core.color;
        cn.x=cn.y=bd;
        super.addChild(bg);
        super.addChild(cn);
    }
    protected function set color(value:uint):void{cl=value;draw()}
    protected function set radius(value:uint):void{rd=value;draw();}
    override public function set width(value:Number):void {w=value+bd*2;draw();}
    override public function set height(value:Number):void {h=value+bd*2;draw();}
    override public function addChild(child:DisplayObject):DisplayObject{
        cn.addChild(child);
        w=cn.width+bd*2;
        h=cn.height+bd*2;
        draw();
        return null;
    }
    public function draw():void{
        g.clear();
        g.beginFill(cl);
        g.drawRoundRect(0,0,w,h,rd*2);
        g.endFill();
    }
}
}
