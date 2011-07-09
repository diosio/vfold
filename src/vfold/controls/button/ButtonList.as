/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.button {
import flash.display.Sprite;
import flash.events.MouseEvent;
import vfold.display.content.ContentScroll;

public class ButtonList extends ContentScroll{

    // Gap between buttons
    private const gp:Number=5;
    // Button Array
    private var bA:Vector.<ButtonLabel>=new Vector.<ButtonLabel>;
    // Action Function
    private var aF:Function;
    // Width
    private var w:Number=100;
    // Current index of selected Button
    private var cI:int=-1;

    // Button Style
    private var bs:ButtonStyle;
    // Container
    private var cn:Sprite=new Sprite;


    public function ButtonList(actionFunction:Function,style:ButtonStyle=null):void {
        super(cn);
        bs=style;
        aF=actionFunction;
        mouseEnabled=false;
        mouseEnabled=false;
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    public function addButtons(oV:Vector.<ButtonOptions>):void{
        var i:uint=0;
        deselectSelected();
        for (i=0;i<oV.length;i++){
            if(i==bA.length){addButton(oV[i])}
            else modifyButton(i,oV[i]);
        }
        var j:int=bA.length;
        while (j-->i){
            cn.removeChild(bA[j]);
            bA.pop();
        }
    }
    public function addButton(button:ButtonOptions):void{
        var i:uint=bA.length;
        bA[i]=new ButtonLabel(bs);
        bA[i].index=i;
        modifyButton(i,button);
        bA[i].width=w-2*gp;
        cn.addChild(bA[i]);
    }
    private function modifyButton(i:uint,data:ButtonOptions):void{
        bA[i].modify(data);
        if(i!=0){
            bA[i].y=bA[i-1].y+bA[i-1].height;
            bA[i].y+=gp;
        }
    }
    public function deselectSelected():void{
        if(cI!=-1)bA[cI].deselect();
        cI=-1;
    }
    public function selectButton(index:uint):void{
        if(index!=cI){
            bA[index].select();
            if(cI!=-1)bA[cI].deselect();
            cI=index;
        }
    }
    private function onMouseOver(e:MouseEvent):void{e.target.onMouseOver()}
    private function onMouseOut(e:MouseEvent):void{e.target.onMouseOut()}
    private function onMouseDown(e:MouseEvent):void {if(e.target.selectable)aF.call(null,e.target.index)}

    public function setSelectableButton(index:uint,value:Boolean):void{bA[index].selectable=value}
    public function getSelectableButton(index:uint):Boolean{return bA[index].selectable}

    override public function get width():Number {return w+2*gp}
    override public function set width(value:Number):void{w=value}
    override public function get height():Number {return super.height+2*gp}
}
}