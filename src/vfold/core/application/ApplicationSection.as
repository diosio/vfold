/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.application {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
public class ApplicationSection extends ApplicationSectionView{

    // Header
    private var hd:SectionHeader;
    // Background
    private var bg:SectionBackground;
    // Body
    private var bd:Sprite=new Sprite;
    // Radius
    private const rd:uint=10;
    // Actual Width
    private var AW:Number=0;
    // Actual Height
    private var AH:Number=0;
    // Preferred Width
    private var PW:Number=100;
    // Preferred Height
    private var PH:Number=100;
    // Minimum Width
    private var MW:Number=100;
    // Minimum Height
    private var MH:Number=100;
    // Current Color
    private var ccl:uint;
    // Current View
    private var cv:DisplayObject;
    // Default Application Section View
    private var dv:Sprite=new Sprite;

    public function ApplicationSection() {
        cv=dv;
        bd.addChild(dv);
        hd=new SectionHeader(onTabSelect,rd,dv);
        bg=new SectionBackground(rd);
        super.addChild(bg);
        super.addChild(bd);
        super.addChild(hd);
        bd.x=5;
        bd.y=bd.x+hd.height;
        bd.addEventListener(Event.RESIZE,drawSection);
        addEventListener(ApplicationSectionView.CHANGE_VIEW,onChangeView);
    }
    private function drawSection(e:Event=null):void
    {
        bg.drawBackground(AW,hd.height+AH,ccl);
        hd.draw(AW,ccl)
    }
    private function onChangeView(e:Event):void{
        if(e.target is ApplicationSectionView){
            var view:ApplicationSectionView=ApplicationSectionView(e.target).view;
            onTabSelect(view);
            hd.changeView(view,view.title);
        }
    }
    private function onTabSelect(view:DisplayObject):void{
        if(cv!=view){
            bd.removeChild(cv);
            cv=view;
            bd.addChild(cv);
        }
    }
    override public function addChild(child:DisplayObject):DisplayObject {return dv.addChild(child)}
    override public function removeChild(child:DisplayObject):DisplayObject {return dv.removeChild(child)}
    override public function set title(value:String):void{super.title=value;hd.tabs.changeLabelAt(value,0)}

    public function changeData(data:Object,color:uint):void{ccl=color}
    public function onSectionResize():void{drawSection()}

    protected function set menuDropContent(value:DisplayObject):void{hd.dropContent=value}

    override public function get width():Number {return AW}
    override public function set width(value:Number):void{AW=value}
    override public function get height():Number {return AH}
    override public function set height(value:Number):void{AH=value}

    public function get prefWidth():Number{return PW}
    public function get prefHeight():Number{return PH}
    public function get minWidth():Number{return MW}
    public function get minHeight():Number{return MH}
}
}
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.utils.Dictionary;
import vfold.controls.button.ButtonStyle;
import vfold.controls.tabs.Tabs;
import vfold.core.Core;
import vfold.core.application.ApplicationSectionView;
import vfold.utilities.ColorModifier;

class SectionHeader extends Sprite{
    // Header Tabs
    private var tb:Tabs;
    // Background
    private var bg:Shape=new Shape;
    private const h:uint=23;
    private const bd:uint=3;
    private var rd:Number;
    // On Tab Select
    private var sf:Function;
    // Section View Dictionary
    private var ad:Dictionary=new Dictionary();
    // Section Vector
    private var av:Vector.<DisplayObject>=new Vector.<DisplayObject>();
    public function SectionHeader(onTabSelect:Function,radius:Number,mainView:DisplayObject):void {
        sf=onTabSelect;
        var bs:ButtonStyle=new ButtonStyle(ColorModifier.brightness(Core.color,.12),0,0,ColorModifier.brightness(Core.color,.7),0);
        bs.textBold=true;
        rd=radius;
        av.push(mainView);
        tb=new Tabs(h-bd,Core.color,.77,this.onTabSelect,onTabClose,"untitled");
        tb.y=bd;
        tb.x=20;

        addChild(bg);
        addChild(tb);
    }
    private function onTabSelect():void{
        sf.call(null,av[tb.currentIndex]);
    }
    private function onTabClose():void{
        ad[av[tb.removedIndex]]=null;
        av.splice(tb.removedIndex,1);
        for(var i:uint=tb.removedIndex;i<av.length;i++)ad[av[i]]-=1;
        if(tb.removedSelected)onTabSelect();
    }
    public function draw(w:Number,color:uint):void {
        tb.adjust(w-tb.x);
        var g:Graphics=bg.graphics;
        g.clear();
        g.beginFill(ColorModifier.brightness(color,.07));
        g.moveTo(0,rd);
        g.curveTo(0,0,rd,0);
        g.lineTo(w-rd,0);
        g.curveTo(w,0,w,rd);
        g.lineTo(w,h);
        g.lineTo(0,h);
        g.lineTo(0,rd);
        g.endFill();
    }
    public function changeView(child:DisplayObject,title:String):void{
        if(!ad[child])addView(child,title);
        else selectView(child);
    }
    private function addView(child:DisplayObject,title:String):void {
        ad[child]=tb.length;
        av.push(child);
        tb.selectTab(tb.addTab(title).vectorIndex);
    }
    private function selectView(view:DisplayObject):void {
        tb.selectTab(ad[view]);
    }
    public function set dropContent(value:DisplayObject):void{
        /*TODO: Fix this*/
    }
    public function get tabs():Tabs{return tb}
    override public function get height():Number{return h}
}

class SectionBackground extends Shape{
    // Width
    private var w:Number;
    // Height
    private var h:Number;
    // Radius
    private var rd:Number;
    public function SectionBackground(radius:Number) {
        rd=radius;
        filters=[new DropShadowFilter(2,90,0,1,4,4,1)];
    }
    public function drawBackground(width:Number,height:Number,color:uint):void{
        w=width;
        h=height;
        drawShadow(graphics,color);
    }
    private function drawShadow(g:Graphics,color:uint):void{
        g.clear();
        g.beginFill(ColorModifier.brightness(color,.77));
        g.drawRoundRect(0,0,w,h,rd*2);
        g.endFill();
    }
}