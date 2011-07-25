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

import vfold.core.Core;
import vfold.display.text.TextSimple;
import vfold.utility.ColorUtility;

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
    private const fc:uint=ColorUtility.brightness(Core.color,.5);
    // Stroke Color
    private var sc:uint=0;

    public function FormDynamic():void{
        oh=tf.height;
        tf.leftMargin=3;
        width=120;
        addChild(bg);
        addChild(tf);
        text="";
    }
    protected function draw():void{
        g.clear();
        if(s!=Form.UNSET)g.lineStyle(2,sc,1,true);
        else{g.lineStyle(1,0,1,true)}
        g.beginFill(fc);
        g.drawRoundRect(0,0,w,tf.height,8);
        g.endFill();
    }
    public function onChange():void{if(af)af.call()}

    override public function set width(value:Number):void {w=tf.width=value;draw();}
    override public function get width():Number {return w}

    public function get text():String{return tf.text}
    public function set text(value:String):void{tf.text=value}
    public function get status():String{return s}
    public function get changeFunction():Function{return af}
    public function set changeFunction(value:Function):void{af=value}
    public function set maxChars(value:uint):void{tf.maxChars=value}
    public function set password(value:Boolean):void{tf.displayAsPassword=value}
    public function get statusMessage():String{return sm}
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

    public function setStatus(value:String,message:String="undefined"):void{
        sm=message;
        s=enabled?value:Form.UNSET;
        switch (s){
            case Form.OK:
                sc=0x7CCF53;
                break;
            case Form.WARNING:
                sc=0xF2BB05;
                break;
            case Form.ERROR:
                sc=0xC94444;
                break;
        }
        draw();
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
    public function get enabled():Boolean{return en}
    protected function get textField():TextSimple{return tf}
    protected function get background():Shape{return bg}
    protected function get strokeColor():uint{return sc}
    protected function get fillColor():uint{return fc}
}
}
