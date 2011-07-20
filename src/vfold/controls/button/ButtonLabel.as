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
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;

import vfold.core.Core;
import vfold.display.text.TextSimple;
import vfold.utilities.ColorUtility;

public class ButtonLabel extends Button {

    // Label
    private var tf:TextSimple;
    // Background Shape
    private var bg:Shape=new Shape;
    // Action Function
    private var af:Function;
    // Tool Drop Box
    private var db:ButtonDropBox;
    // Button Style
    private var bs:ButtonStyle;

    public function ButtonLabel(style:ButtonStyle=null):void {
        bs=style?style:new ButtonStyle(ColorUtility.brightness(Core.color,0.12),1,1,ColorUtility.brightness(Core.color,0.6));
        tf=new TextSimple(13,bs.textColor);
        tf.bold=bs.textBold;
        tf.rightMargin=2;
        tf.leftMargin=2;
        tf.y=tf.leading;
        addChild(bg);
        addChild(tf);

        onOut();
        tf.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        tf.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        tf.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    public function modify(data:ButtonOptions):void{

    }
    public function set label(value:String):void{
        tf.text=value;
        drawBackground(bg.graphics,bs.fillColor,bs.fillAlpha);
        if(db)db.onButtonAdjust(bg.width,bg.height+3);
    }
    private function drawBackground(g:Graphics,color:uint,alpha:Number):void{
        g.clear();
        g.beginFill(color,alpha);
        g.lineStyle(bs.strokeThickness,bs.strokeColor,bs.strokeAlpha,true);
        g.drawRoundRect(0,0,tf.width,tf.height,10);
        g.endFill();
    }
    override public function get height():Number {return bg.height}
    override protected function onOver():void {
        bg.alpha=1;
        tf.alpha=1;
    }
    override protected function onOut():void {
        bg.alpha=.6;
        tf.alpha=.7;
    }
    override protected function onDown():void {
        onOut();
        if(db){
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            tf.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
            tf.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
            addChildAt(db,1);
        }
        if(af)af.call(null);
    }
    public function onStageDown(e:MouseEvent=null):void{
        if(e?!contains(e.target as DisplayObject):contains(db)){
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            tf.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
            tf.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
            removeChild(db);
            onOut();
        }
    }
    public function get textField():TextSimple{return tf}
    public function set actionFunction(value:Function):void{af=value}
    public function setDropBox(content:DisplayObject, dispatcher:DisplayObject):void {
        db=new ButtonDropBox(content, dispatcher, bs);
        db.onButtonAdjust(bg.width,bg.height);
    }
}
}
