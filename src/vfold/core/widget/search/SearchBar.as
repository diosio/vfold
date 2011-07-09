/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget.search {
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextFieldType;

import vfold.display.icons.IconsSystem;
import vfold.display.text.TextSimple;

public class SearchBar extends Sprite{

    // Search Text Field
    private var sTF:TextSimple=new TextSimple(13,0xFFFFFF);
    // Search Bar Width
    private var sBW:Number=170;
    // Search Icon Bitmap
    private var sBM:Bitmap;
    // Search Icon Container
    private var sIC:Sprite=new Sprite;
    // Search Background Shape
    private var sBS:Shape=new Shape;
    // Search Function
    private var sFN:Function;
    // Search Container
    private var sCN:Sprite=new Sprite;

    // Category Function
    private var cFN:Function;
    // Category Icon
    private var cIC:Bitmap=new Bitmap();
    // Category Container
    private var cCN:Sprite=new Sprite;
    // Category Key
    private var cKY:String;

    // Color
    private var cl:uint;
    // Border Gap
    private var bG:uint=4;
    // Width
    private var w:Number;



    public function SearchBar(onSearch:Function,onCategory:Function,color:uint):void{

        x=y=0;

        sBM=new IconsSystem.Find() as Bitmap;

        cl=color;
        sFN=onSearch;

        sTF.text="εύρεση...";
        sTF.leftMargin=8;
        sTF.rightMargin=8;
        sTF.leading=6;
        sTF.selectable=true;
        sTF.type=TextFieldType.INPUT;
        sTF.width=sBW-sBM.width;
        sTF.y=sTF.textFormat.leading as Number;
        sTF.y/=2;

        sBM.x=sTF.width;
        sBM.y=(sTF.height-sBM.height)/2;

        drawBackground(sBS.graphics);

        sIC.buttonMode=true;
        sIC.addChild(sBM);

        sCN.addChild(sBS);
        sCN.addChild(sTF);
        sCN.addChild(sIC);

        addChild(sCN);

        sTF.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
        sTF.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
        sIC.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    private function onMouseDown(e:MouseEvent):void {

        sFN.call(null,sTF.text);
    }
    public function setCategory(icon:Bitmap,key:String):void{

        cIC.bitmapData=icon.bitmapData;
        cKY=key;
    }
    public function set text(value:String):void{

        sTF.text=value;
    }
    private function drawBackground(g:Graphics):void{

        g.clear();
        g.lineStyle(1,0xFFFFFF,1);
        g.beginFill(cl,.75);
        g.drawRoundRect(0,0,sBW,sTF.height,sTF.height);
        g.endFill();
    }
    private function onFocusIn(e:FocusEvent):void{

        stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
    }
    private function onFocusOut(e:FocusEvent):void{

        stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
    }
    private function onKeyDown(e:KeyboardEvent):void{

        if( e.charCode == 13 ){

            sFN.call(null,sTF.text);
        }
    }
    override public function set x(value:Number):void {

        super.x = bG+value;
    }
    override public function set y(value:Number):void {

        super.y = bG+value;
    }
    override public function get width():Number {

        return w;
    }
    override public function set width(value:Number):void {

        w=value;
        sCN.x=w-sBW-2*bG;

    }
    override public function get height():Number {

        return sBS.height+bG*2;
    }
}
}
