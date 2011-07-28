/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.form {

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;

import vfold.display.text.TextSimple;

public class FormDynamic extends Sprite{
    // Input Field
    private var tf:TextSimple=new TextSimple();
    // Background
    private var bg:Shape=new Shape();
    // Background Graphics
    private var g:Graphics=bg.graphics;
    // Action Function
    private var af:Function=null;
    // Enable
    private var en:Boolean=true;
    // Status Message
    public var sm:String;
    // Status
    private var s:String=Form.UNSET;
    // Original Height
    private var oh:Number;
    // Width
    private var w:Number;
    // Fill Color
    private var fc:uint=0xFFFFFF;
    // Glow
    private var gf:GlowFilter=new GlowFilter();


    public function FormDynamic():void{
        gf.strength=2.2;
        oh=tf.height;
        tf.leftMargin=3;
        width=120;
        addChild(bg);
        addChild(tf);
        tf.text="";
        tf.y=tf.leading;
        active=false;
    }
    private function draw():void{
        g.clear();
        g.beginFill(fc);
        g.drawRoundRect(0,0,w,tf.height,8);
        g.endFill();
    }
    public function onChange():void{if(af)af.call()}

    public function setStatus(value:String,message:String="undefined"):void{
        sm=message;
        s=enabled?value:Form.UNSET;
        var sc:uint;
        switch (s){
            case Form.OK:
                sc=0x7CCF53;
                break;
            case Form.WARNING:
                sc=0xF2BB05;
                break;
            case Form.ERROR:
                sc=0xFF7575;
                break;
        }
        draw();
        gf.color=sc;
        bg.filters=[gf];
    }
    override public function set width(value:Number):void {w=tf.width=value;draw();}
    override public function get width():Number {return w}

    protected function get background():Shape{return bg}

    public function get enabled():Boolean{return en}
    public function get textField():TextSimple{return tf}
    public function get fillColor():uint{return fc}
    public function get status():String{return s}
    public function get changeFunction():Function{return af}
    public function get statusMessage():String{return sm}
    public function set changeFunction(value:Function):void{af=value}
    public function set maxChars(value:uint):void{tf.maxChars=value}
    public function set password(value:Boolean):void{tf.displayAsPassword=value}
    public function set textColor(value:uint):void{tf.color=value}
    public function set fillColor(value:uint):void{fc=value}
    public function set text(value:String):void{tf.text=value}
    public function get text():String{return tf.text}
    public function set numLines(value:uint):void{
        if(value>1){
            tf.multiline=tf.wordWrap=true;
            tf.height=oh*value;
        }
        else{
            tf.multiline=tf.wordWrap=false;
            tf.height=oh;
        }
    }
    public function set enable(value:Boolean){
        if(value&&!en){
            mouseEnabled=mouseChildren=true;
            tf.restrict=null;
            alpha=1;
        }
        else if(!value&&en){
            setStatus(Form.UNSET,null);
            tf.restrict="*";
            tf.text="";
            mouseEnabled=mouseChildren=false;
            alpha=.4;
        }
        en=value;
    }
    public function set active(value:Boolean):void{
        if(value){
            gf.blurX=gf.blurY=6;
        }
        else{
            gf.blurX=gf.blurY=2;
        }
        bg.filters=[gf];
    }
}
}
