/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.tabs {
import com.greensock.TweenLite;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.engine.TabAlignment;
import flash.utils.Dictionary;

import vfold.utility.ColorUtility;

public class Tabs extends Sprite{
    // Tab vector
    private var tV:Vector.<Tab>=new Vector.<Tab>;
    // Blank Shape (A Child Replacement)
    private var bnk:Shape=new Shape;
    // Boundaries
    private var bds:Rectangle;
    // Current Selected Vector Index
    private var vI:int=0;
    // Current Selected Order Index
    private var oI:int=0;
    // Tab's Vector Index - Order Index Relation
    private var iV:Vector.<uint>=new Vector.<uint>;
    // Tab Radius
    public static const RADIUS:Number=24;
    //  Width
    private var w:Number;
    // Sum of Tab TextField Widths
    private var stw:Number=0;
    // Sum of Tab (Widths-TextField Widths)
    private var stg:Number=0;
    // Tab Height
    private var th:Number;
    // Select Function
    private var sf:Function;
    // Close Function
    private var cf:Function;
    // Dark Color
    private var cl:uint;
    // Bright Color
    private var bcl:uint;
    // Data Dictionary
    private var dd:Dictionary=new Dictionary();

    public function Tabs(height:Number,color:uint,bm:Number,onSelect:Function,onClose:Function) {
        const dif:Number=.3;
        cl=bm>dif?ColorUtility.brightness(color,bm-dif):color;
        bcl=ColorUtility.brightness(color,bm);
        sf=onSelect;
        cf=onClose;
        th=height;

        bds=new Rectangle(0,0,0,0);
        addChild(bnk);
        mouseEnabled=false;
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    /****************************************
     *
     *        MOUSE EVENT HANDLERS
     *
     * **************************************
     * */
    private function onMouseOver(e:MouseEvent):void {
        if(e.target is CloseButton)CloseButton(e.target).onMouseOver();
    }
    private function onMouseOut(e:MouseEvent):void {
        if(e.target is CloseButton)CloseButton(e.target).onMouseOut();
    }
    private function onMouseDown(e:MouseEvent):void {
        if(e.target is CloseButton){
            closeTab(Tab(e.target.parent).index);
        }
        else if(e.target is Tab)onSelect(Tab(e.target).index);
    }
    /****************************************
     *
     *        ADD TAB
     *
     * **************************************
     * */
    public function addTab(label:String="untitled",data:*=null):Tab {
        var i:uint=tV.length;
        tV.push(new Tab(th,cl,bcl,i));
        dd[data]=i;
        tV[i].data=data;
        tV[i].label=label;
        addChildAt(tV[i],0);
        if(i!=0){
            var a:uint=iV[iV.length-1];
            tV[i].x=tV[a].x+tV[a].width-RADIUS;
        }
        else {
            if(!tV[i].selected)tV[i].select();
            swapChildren(tV[i],bnk);
        }
        tV[i].posX=tV[i].x;
        stw+=tV[i].textWidthOrig;
        stg+=tV[i].width-tV[i].textWidthOrig;
        if(i!=0)stg-=RADIUS;
        iV.push(i);
        checkWidth();
        return tV[i];
    }
    /****************************************
     *
     *        CHANGE LABEL
     *
     * **************************************
     * */
    public function changeLabelAt(label:String,i:uint):void{
        var twd:Number,wd:Number;
        twd=tV[i].textWidthOrig;
        wd=tV[i].widthOrig;
        tV[i].label=label;
        twd-=tV[i].textWidthOrig;
        wd-=tV[i].widthOrig;
        stg-=twd;
        stw-=wd;
        checkWidth();
    }
    /****************************************
     *
     *  TAB ADJUSTMENT
     *
     * **************************************
     * */
    public function adjust(width:Number):void{
        w=width;
        checkWidth();
    }
    private function checkWidth():void{
        if(stg+stw>width)adjustTabs();
    }
    private function adjustTabs():void{
        var a:uint;
        var n:Number;
        n=(w-stg)/stw;
        for (var i:uint=0;i<tV.length;i++){
            a=iV[i];
            tV[a].changeWidth(n);
            if(i!=0){
                tV[a].x=tV[iV[i-1]].x+tV[iV[i-1]].width-RADIUS;
                tV[a].posX=tV[a].x;
            }
        }
    }
    /****************************************
     *
     *  SELECT TAB
     *
     * **************************************
     * */
    public function selectTab(data:*):void{
        selectTabByIndex(dd[data]);
    }
    private function selectTabByIndex(i:int):void{
        if(vI!=i){
            tV[vI].deselect();
            swapChildren(tV[vI],bnk);
            swapChildren(tV[i],bnk);
        }
        if(!tV[i].selected)tV[i].select();
        vI=i;
    }
    private function onSelect(i:uint):void{
        if(!tV[i].selected){
            selectTabByIndex(i);
            oI=tV[i].orderIndex;
            bds.width=width-(tV[i].width);

            sf.call();
        }
        tV[i].startDrag(false,bds);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
    }
    /****************************************
     *
     *  TAB MOVING
     *
     * **************************************
     * */
    private function onMouseMove(e:MouseEvent):void{
        if (oI!=0)if(tV[vI].x<tV[iV[oI-1]].posX+tV[iV[oI-1]].width/2){
            moveLeft(oI-1);
            oI--;
        }
        if (oI!=tV.length-1)if(tV[vI].x+tV[vI].width>tV[iV[oI+1]].posX+tV[iV[oI+1]].width/2){
            moveRight(oI+1);
            oI++;
        }
    }
    private function onMouseUp(e:MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        tV[vI].stopDrag();
        TweenLite.to(tV[vI],.3,{x:tV[vI].posX});
    }
    private function moveLeft(i:uint):void{
        tV[vI].posX=tV[iV[i]].posX;
        tV[iV[i]].posX+=tV[vI].width-RADIUS;
        switchOrder(i);
    }
    private function moveRight(i:uint):void{
        tV[iV[i]].posX=tV[vI].posX;
        tV[vI].posX=tV[iV[i]].posX+tV[iV[i]].width-RADIUS;
        switchOrder(i);
    }
    private function switchOrder(i:uint):void{
        swapChildren(tV[iV[i]],bnk);
        var t:Number;
        TweenLite.to(tV[iV[i]],.3,{x:tV[iV[i]].posX });
        tV[iV[i]].orderIndex=tV[vI].orderIndex;
        tV[vI].orderIndex=i;
        t=iV[oI];
        iV[oI]=iV[i];
        iV[i]=t;
    }
    /****************************************
     *
     *  REMOVE TAB
     *
     * **************************************
     * */
    public function removeTabByData(data:*):void {
        removeTabByIndex(dd[data]);
    }
    private function closeTab(i:uint):void{
        var t:int=vI;
        vI=i;
        cf.call();
        vI=t;
        removeTabByIndex(i);
    }
    public function removeTabByIndex(i:uint):void {
        stw-=tV[i].textWidthOrig;
        stg-=(tV[i].widthOrig-tV[i].textWidthOrig);
        if(tV.length!=1)stg+=RADIUS;
        var cT:Tab;
        var pT:Tab;
        var j:uint;
        if(tV.length>1){
            if(vI==i){
                if(vI>0){
                    vI--;
                    swap(i);
                }
                if(vI==0){
                    vI++;
                    swap(i);
                    vI--;
                }
            }
            else if(vI>=i&&vI!=0)vI--;
            else if(vI==tV.length-1)swap(i);
        }
        removeChild(tV[i]);
        var o:uint=tV[i].orderIndex;
        checkWidth();
        for (j=o+1;j<tV.length;j++){
            cT=tV[iV[j]];
            pT=tV[iV[j-1]];
            if(j==o+1)cT.posX=pT.posX;
            else cT.posX=pT.posX+pT.width-RADIUS;
            TweenLite.to(cT,.3,{x:cT.posX});
            cT.orderIndex--;
        }
        tV.splice(i,1);
        for(j=0;j<tV.length;j++){
            tV[j].index=j;
            dd[tV[j].data]=j;
        }
        iV.splice(o,1);
        for(j=0;j<iV.length;j++)if(iV[j]>i)iV[j]--;
    }
    private function swap(i:uint):void{
        swapChildren(tV[i],bnk);
        swapChildren(tV[vI],bnk);
        if(tV[i].selected&&!tV[vI].selected)tV[vI].select();
    }
    /****************************************
     *
     *  GETTERS AND SETTERS
     *
     * **************************************
     * */
    public function get currentIndex():uint{return vI}
    public function get length():uint{return tV.length}
    public function get minimumWidth():Number{return stg}
    public function get currentData():*{return tV[vI].data}

    override public function get height():Number{return th}
    override public function get width():Number{return super.width}
}
}

import vfold.controls.tabs.Tabs;
import vfold.core.Core;
import vfold.display.text.TextSimple;
import flash.text.TextFieldAutoSize;
import vfold.controls.button.ButtonSymbol;
import vfold.utility.GraphicUtility;
import vfold.controls.button.Button;
import flash.display.Graphics;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
class Tab extends Button{

    private var W:Number;
    private var H:Number;
    // Tab Radius
    private var r:Number=Tabs.RADIUS;
    private var t:TextSimple;
    // Vector Index
    private var vI:uint;
    // Order Index
    public var oI:uint;
    // Position X
    public var posX:Number;
    // Color
    private var cl:uint;
    // Bright Color
    private var bcl:uint;
    // Close Button
    private var cb:CloseButton;
    // Current Default Text Width
    private var ctw:Number;
    // Current Default Tab Width
    private var cw:Number;
    // Background
    private var bg:Shape=new Shape;
    // Shadow
    private var sh:Shape=new Shape;
    // Data
    public var data:*;

    public function Tab(height:Number,color:uint,brightColor:uint,index:uint):void{
        super(true);
        cl=color;
        bcl=brightColor;
        vI=index;
        oI=index;
        H=height;
        t=new TextSimple(13,0);
        t.x=r;
        t.y=(H-t.height)/2;
        t.mouseEnabled=false;
        addChild(sh);
        addChild(bg);
        addChild(t);
        cb = new CloseButton;
        cb.y=(H-cb.height)/2;
        addChild(cb);
        sh.filters=[new DropShadowFilter(0,90,0,1,12,0,1,1,false,true)];
        label="untitled";
    }
    public function set label(value:String):void{
        t.autoSize=TextFieldAutoSize.LEFT;
        t.text=value;
        ctw=t.width;
        adjustSize();
        cw=width;
    }
    private function adjustSize():void {
        W=r+t.width+(cb?cb.width/2:0);
        if(cb)cb.x=W-cb.width/2;
        draw(bg.graphics,selected?bcl:cl);
        draw(sh.graphics);
    }
    public function changeWidth(ratio:Number):void{
        if(ratio>=1){
            t.width=ctw;
        }
        else{
            if (ratio<1&&ratio>0)t.width=ctw*ratio;
            else t.width=0;
        }
        adjustSize();
    }
    private function draw(g:Graphics,c:uint=0xFFFFFF):void{
        g.clear();
        g.beginFill(c);
        g.moveTo(0,H);
        g.curveTo(r/4,H,r/2,H/2);
        g.curveTo(r/2+r/4,0,r,0);
        g.lineTo(W,0);
        g.curveTo(W+r/4,0,W+r/2,H/2);
        g.curveTo(W+r/2+r/4,H,W+r,H);
        g.endFill();

    }
    override protected function selectAction():void{draw(bg.graphics,bcl)}
    override protected function deselectAction():void{draw(bg.graphics,cl)}
    override public function get index():uint {return vI}
    override public function set index(i:uint):void{vI=i}
    public function get widthOrig():Number{return cw}
    public function get textWidthOrig():Number{return ctw}
    public function get orderIndex():uint{return oI}
    public function set orderIndex(value:uint):void{oI=value}
}
class CloseButton extends ButtonSymbol{

    private var ov:Shape=new Shape;

    public function CloseButton (){
        color=Core.color;
        onOut();
        addChild(ov);
    }
    override protected function onOver():void {
        super.onOver();
        ov.graphics.clear();
        GraphicUtility.close(ov.graphics,7,0xFFFFFF);
    }
    override protected function onOut():void {
        super.onOut();
        ov.graphics.clear();
        GraphicUtility.close(ov.graphics,7,Core.color);
    }
}