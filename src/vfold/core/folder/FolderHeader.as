/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {
import flash.events.Event;
import flash.utils.Dictionary;
import vfold.controls.tabs.Tabs;
import vfold.core.application.ApplicationView;
import vfold.utilities.ColorModifier;

public class FolderHeader extends FolderView{

    private var btn:HeaderButtons;
    private var tb:Tabs;
    private const g:Number=7;

    // Application Data Index Dictionary
    private var ad:Dictionary=new Dictionary();
    // Application Data Vector
    private var av:Vector.<ApplicationView>=new Vector.<ApplicationView>();

    public function FolderHeader(folder:Folder):void {

        super(folder);
        tb=new Tabs(headerHeight-borderThickness,folder.color,.7,onTabSelect,onTabClose,folder.title);
        btn=new HeaderButtons(folder.minimize,folder.maximize,folder.close);

        addChild(btn);
        addChild(tb);

        btn.y=(headerHeight-btn.height)/2;
        tb.y=borderThickness;
        tb.x=innerRadius;

        mouseEnabled=false;

    }
    public function changeView(view:ApplicationView):void{
        if(!ad[view])folder.minWidth=addView(view);
        else selectView(view);
    }
    private function addView(view:ApplicationView):Number {
        ad[view]=tb.length;
        tb.selectTab(tb.addTab(view.title).vectorIndex);
        return tb.minimumWidth+btn.width+outerRadius+g;
    }
    private function selectView(view:ApplicationView):void {
        tb.selectTab(ad[view]);
    }
    private function onTabClose():void {

        ad[av[tb.removedIndex]]=null;
        av.splice(tb.removedIndex,1);
        for(var i:uint=tb.removedIndex;i<av.length;i++)ad[av[i]]-=1;
        if(tb.removedSelected){
            if(tb.length!=0)folder.application.changeView(av[tb.currentIndex]);
            else folder.application.changeToDefaultView();
        }
    }
    private function onTabSelect():void{
        folder.application.changeView(av[tb.currentIndex]);
    }
    override public function onFolderAdjust(e:Event = null):void {
        btn.x=folder.width-btn.width-outerRadius/2;
        tb.adjust(btn.x-g);
    }
    public function set active(b:Boolean):void{
        if(b)tb.alpha=btn.alpha=1;
        else tb.alpha=btn.alpha=.4;
    }
}
}

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import vfold.controls.button.ButtonSymbol;
import vfold.core.Core;
import vfold.utilities.ColorModifier;
import vfold.utilities.Draw;

class HeaderButtons extends Sprite{
    // Close Button
    private var CL:HeaderButton;
    // Minimize Button
    private var MN:HeaderButton;
    // Maximize Button
    private var MX:HeaderButton;
    // Y offset
    private var yo:Number=0;
    // Button Size
    private const bs:Number=10;
    // Gap
    private const g:int=2;

    public function HeaderButtons(minimize:Function,maximize:Function,close:Function):void{
        mouseEnabled=false;
        var cl:Shape=new Shape, mn:Shape=new Shape, mx:Shape=new Shape;
        Draw.close(cl.graphics,bs);
        Draw.minimize(mn.graphics,bs);
        Draw.maximize(mx.graphics,bs);
        CL=new HeaderButton(cl,close);
        MN=new HeaderButton(mn,minimize);
        MX=new HeaderButton(mx,maximize);
        addChild(CL);
        addChild(MN);
        addChild(MX);
        MX.x=MN.width+g;
        CL.x=MX.x+MX.width+g;
        align();
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    private function onMouseOver(e:MouseEvent):void {ButtonSymbol(e.target.onMouseOver())}
    private function onMouseOut(e:MouseEvent):void {ButtonSymbol(e.target.onMouseOut())}
    private function onMouseDown(e:MouseEvent):void {ButtonSymbol(e.target.onMouseDown())}
    private function align():void{
        var mxh:Number=Math.max(MN.height,MX.height,CL.height);
        var i:int=numChildren;
        var dso:DisplayObject;
        while(i-->0){
            dso=getChildAt(i);
            dso.y=-dso.height/2;
        }
        yo=mxh/2;
    }
    override public function set y(value:Number):void {
        super.y=value+yo;
    }
}
class HeaderButton extends ButtonSymbol{
    public function HeaderButton(symbol:DisplayObject,onDownFunction:Function){
        this.onDownFunction=onDownFunction;
        addChild(symbol);
        color=ColorModifier.brightness(Core.color,.4);
        background.filters=[new BlurFilter(8,8)];
    }
}