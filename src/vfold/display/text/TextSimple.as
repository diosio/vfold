/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.display.text {
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public  class TextSimple extends TextField{
    private var f:TextFormat=new TextFormat;
    public function TextSimple(s:uint=13,c:uint=0,bold:Boolean=false,align:String="left",alpha:Number=1):void{

        f.size = s;
        f.color=c;
        f.font="arial";
        f.bold=bold;
        f.align=align;
        selectable=false;
        autoSize=TextFieldAutoSize.LEFT;
        text="untitled";
        this.alpha=alpha;
        configureText();
    }
    public function get textFormat():TextFormat{return f}
    public function get leading():uint{return f.leading as uint}

    public function set leftMargin(value:uint):void{f.leftMargin=value;configureText();}
    public function set rightMargin(value:uint):void{f.rightMargin=value;configureText();}
    public function set bold(value:Boolean):void{f.bold=value;configureText();}
    public function set size(value:Number):void{f.size=value;configureText();}
    public function set leading(value:uint):void{f.leading=value;configureText();}
    public function set underline(value:Boolean):void{f.underline=value;configureText();}
    public function set color(value:uint):void{f.color=value;configureText();}
    public function set textFormat(value:TextFormat):void{f=value;configureText();}
    private function configureText():void{
        setTextFormat(f);
        defaultTextFormat=f;
    }
    override public function set width(value:Number):void {
        var h:Number=height;
        autoSize=TextFieldAutoSize.NONE;
        super.width = value;
        height=h;
    }
    public function getNewTextWidth(value:String):Number{
        var t:String=text;
        text=value;
        var w:Number=width;
        text=t;
        return w;
    }
    public function boldSelection(beginIndex:uint,endIndex:uint):void{
        var s:String="";
        s+=text.substring(0,beginIndex);
        s+="<U><B>";
        s+=text.substring(beginIndex,endIndex);
        s+="</B></U>";
        s+=text.substring(endIndex);
        htmlText=s;
    }
}
}