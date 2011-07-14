/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.menu {
import com.greensock.TimelineLite;
import com.greensock.TweenMax;
import flash.display.Sprite;
import vfold.controls.button.ButtonOptions;
public class MenuButtons extends Sprite{

    // Button Vector
    private var bV:Vector.<MenuParent>=new Vector.<MenuParent>();
    // Button Color
    private var bC:uint;
    // Button Gap
    private var bG:uint;

    // Tween Time-line Lite
    private var ttl:TimelineLite;
    // Tween-Max Array
    private var tma:Array=[];
    // Tween-Objects Array
    private var toa:Array=[];
    // Tween Duration
    private var tdr:Number=.35;

    // Previous Index
    private var pI:uint;

    public function MenuButtons(buttonColor:uint,buttonGap:uint) {

        mouseEnabled=false;
        mouseChildren=false;
        bC=buttonColor;
        bG=buttonGap;

        ttl = new TimelineLite({paused:true});
    }
    public function addButtons(dataButtons:Vector.<ButtonOptions>):void {

        var i:uint=0;
        var j:uint=bV.length;
        var mxW:Number=0;

        for (i=j;i<dataButtons.length;i++){
            bV[i]=new MenuParent(
                    bC,
                    bG,
                    dataButtons[i]);
            bV[i].button.index=i;
            bV[i].button.alpha=0;
            if(i!=0){

                bV[i].y+=i*(bV[i-1].height+bG);
            }
            if(i!=j){

                mxW=Math.max(mxW,bV[i].button.width);
            }
            else{

                mxW=bV[i].button.width;
            }
            toa.push(bV[i].button);
            addChild(bV[i]);
        }

        i=j;
        if(j>1)if(mxW>bV[j-1].button.width)i=0;

        for (i;i<bV.length;i++){

            bV[i].width=mxW;
        }
        ttl.clear();
        tma=TweenMax.allFromTo(toa,tdr,{alpha:0,y:"50"},{alpha:1,y:"-50"},tdr/toa.length);
        ttl.insertMultiple(tma);
    }
    public function fadeIn():void{

        ttl.play();
        mouseChildren=true;
    }
    public function fadeOut():void{

        ttl.reverse();
        mouseChildren=false;

        if(bV.length>0){

            bV[pI].buttonContainer.fadeOut();
        }
    }
    public function set previousIndex(value:uint):void{pI=value}
}
}
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;

import vfold.controls.menu.MenuButtons;
import vfold.controls.button.*;
import vfold.core.Core;
import vfold.utilities.Draw;
import vfold.display.text.TextSimple;
import flash.display.Graphics;
import flash.display.Shape;
import vfold.utilities.ColorFunction;
class MenuParent extends Sprite{

    // Button Container
    private var bC:MenuButtons;
    // Button Label
    private var bL:MenuButton;
    // Button Gap
    private var bG:uint;

    public function MenuParent(buttonColor:uint,buttonGap:uint,buttonData:ButtonOptions=null):void{
        bG=buttonGap;
        bC=new MenuButtons(buttonColor,bG);
        bL=new MenuButton(buttonColor,buttonData,buttonData.buttonVector.length>0);

        addChild(bC);
        addChild(bL);

        if(buttonData)bC.addButtons(buttonData.buttonVector);
    }
    public function get buttonContainer():MenuButtons{return bC}
    public function get button():MenuButton{return bL}

    override public function set width(value:Number):void {

        bL.width = value;
        bC.x=value+bG;
    }
    override public function get height():Number {
        return bL.height;
    }
}
class MenuButton extends Button {

    // Text Field: Label
    private var tfl:TextSimple=new TextSimple(13,0xFFFFFF);
    // Background Shape
    private var bgs:Shape=new Shape;
    // Highlight Shape
    private var hls:Shape=new Shape;
    // Color
    private var clr:uint;
    // Gap
    private var gap:uint=6;
    // Arrow Shape
    private var arr:Shape = new Shape;
    // Button Width
    private var wdt:Number=0;
    // Menu Button Data
    private var d:ButtonOptions;

    public function MenuButton(color:uint,data:ButtonOptions,arrow:Boolean=false) {
        d=data;
        tfl.rightMargin=gap;
        tfl.leftMargin=gap;
        tfl.leading=gap;
        tfl.text=d.title;
        tfl.y=gap/2;

        clr=color;

        addChild(bgs);
        addChild(hls);
        addChild(arr);
        addChild(tfl);

        mouseChildren=false;

        hls.alpha=0;

        wdt=super.width;
        if(arrow){
            arr.graphics.drawGraphicsData(new <IGraphicsData>[new GraphicsSolidFill(0xFFFFFF,.8),Draw.arrowRight(0,0,tfl.height/4,tfl.height/2.5)]);
            arr.y=(tfl.height-arr.height)/2;
            arr.x=tfl.width;
            wdt=super.width+gap/2;
        }
    }
    override public function set alpha(value:Number):void {
        super.alpha = value;
        if(value==0)visible=false;
        else if(!visible)visible=true;
    }
    public function set text(value:String):void{

        tfl.text=value?value:"";
        width=super.width;
        draw();
    }
    private function draw():void{
        drawRectangle(bgs.graphics,clr,.86,wdt);
        drawRectangle(hls.graphics,0xFFFFFF,.8,wdt);
        arr.x=wdt-gap-arr.width;
    }
    override public function set width(value:Number):void {
        wdt=value;
        draw();
    }
    private function drawRectangle(g:Graphics,c:uint,a:Number,w:Number):void{

        g.clear();
        g.lineStyle(2,ColorFunction.brightness(c,.55),1,true);
        g.beginFill(c,a);
        g.drawRoundRect(0,0,w,tfl.height,15);
        g.endFill();
    }
    override public function get width():Number {return wdt}
    override protected function onOver():void{if(hls.alpha!=1)hls.alpha=.6;}
    override protected function onOut():void{hls.alpha=0;}
    override protected function onDown():void {if(d.description)Core.folderHandler.addFolder(d.description);}
}
