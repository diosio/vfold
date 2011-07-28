/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.button {
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;


import vfold.core.Core;
import vfold.display.text.TextSimple;
import vfold.utility.ColorUtility;
import vfold.utility.MathUtility;

public class ButtonLabel extends Button {

    // Label
    private var tf:TextSimple;
    // Background Shape
    private var bg:Shape=new Shape;
    // Bitmap bg
    private var bbg:Shape = new Shape();
    // Action Function
    private var af:Function;
    // Tool Drop Box
    private var db:ButtonDropBox;
    // Button Style
    private var bs:ButtonStyle;
    // Button Label Radius
    private var rd:int = 6;
    // Bitmap
    private var bm:Bitmap;

    private var iR:Number;
    private var ir:Number;
    private var iD:Number;
    private var gf:GlowFilter=new GlowFilter();

    public function ButtonLabel(style:ButtonStyle=null):void {
        bs=style?style:new ButtonStyle(ColorUtility.brightness(Core.color,0.12),1,1,ColorUtility.brightness(Core.color,0.6));
        gf.color=bs.strokeColor;
        gf.strength=2.2;
        tf=new TextSimple(13,bs.textColor);
        tf.bold=bs.textBold;
        tf.leftMargin=tf.rightMargin=4;
        tf.y=tf.leading;
        addChild(bg);
        addChild(bbg);
        addChild(tf);
        onOut();
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    public function set label(value:String):void{
        tf.text=value;
        draw();
    }
    public function onStageDown(e:MouseEvent=null):void{
        if(e?!contains(e.target as DisplayObject):contains(db)){
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
            db.onClose();
            removeChild(db);
            onOut();
        }
    }
    private function draw():void{
        var g:Graphics=bg.graphics;
        g.clear();
        g.beginFill(bs.fillColor);
        if(bm){

            g.moveTo(iR,tf.y);
            g.lineTo(iD+tf.width-rd,tf.y);
            g.curveTo(iD+tf.width,tf.y,iD+tf.width,tf.y+rd);
            g.lineTo(iD+tf.width,tf.y+tf.height-rd);
            g.curveTo(iD+tf.width,tf.y+tf.height,iD+tf.width-rd,tf.y+tf.height);
            g.lineTo(iR,tf.y+tf.height);
            g.endFill();
            g.beginFill(bs.fillColor);
            g.drawCircle(iR,iR,iR);
        }
        else{
            g.drawRoundRect(0,0,tf.width,tf.height,10);
        }
        g.endFill();
        if(db)db.onButtonAdjust(bg.width,bg.height+3);
    }
    override protected function onOver():void {
        gf.blurX=gf.blurY=8;
        bg.filters=[gf];
        bbg.alpha=.75;
    }
    override protected function onOut():void {
        gf.blurX=gf.blurY=2;
        bg.filters=[gf];
        bbg.alpha=.4;
    }
    override protected function onDown():void {
        onOut();
        if(db){
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
            addChildAt(db,1);
            db.onOpen();
        }
        if(af)af.call(null);
    }
    override public function get height():Number {return bg.height}
    public function get style():ButtonStyle{return bs}
    public function get textField():TextSimple{return tf}
    public function set actionFunction(value:Function):void{af=value}
    public function set dropBox(value:ButtonDropBox):void {
        db=value;
        db.style=bs;
        db.onButtonAdjust(bg.width,bg.height);
    }
    public function set icon(i:Bitmap):void{
        if(bm)removeChild(bm);
        bm=i;
        if(bm){
            addChild(i);
            ir=MathUtility.findRadius(bm);
            iR=ir+4;
            iD=iR<<1;
            bm.x=(iD-bm.width)>>1;
            bm.y=(iD-bm.height)>>1;
            tf.x=iD;
            tf.y=(iD-tf.height)>>1;

            var g:Graphics = bbg.graphics;
            g.clear();
            g.beginFill(bs.strokeColor);
            g.drawCircle(iR,iR,ir);
            g.endFill();

            draw();
        }

    }
}
}
