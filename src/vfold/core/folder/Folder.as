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
import flash.geom.Rectangle;
import flash.utils.Dictionary;


import vfold.core.Core;
import vfold.core.CoreView;

public class Folder extends CoreView{

    private var ld:Dictionary=new Dictionary();
    // Application Layouts;
    private var lv:Vector.<FolderLayout>=new Vector.<FolderLayout>();

    // Current View
    private var CV:FolderView;
    // Default View
    private var DV:FolderView;

    // Resize Event
    private var re:Event=new Event(Event.RESIZE);
    // Y Offset
    public static const GAP:uint=7;

    // Border Thickness
    private const bT:int = 5;
    // Header Height
    private const hh:int = 25;
    // Footer Height
    private const fh:int = 30;
    // Outer Radius
    private const or:int = 20;
    // Inner Radius
    private const ir:int = 10;

    // Folder Width
    private var FW:Number=670;
    // Folder Height
    private var FH:Number=380;
    // Temporary Width
    private var TW:Number=FW;
    // Temporary Height
    private var TH:Number=FH;
    // Minimum Width
    private var MW:Number=100;
    // Minimum Height
    private var MH:Number=100;
    // Folder Title
    private var FT:String="untitled";


    // Folder Background
    private var bg:Background;
    // Folder Body
    private var bd:FolderBody;
    // Folder Footer
    private var ft:FolderFooter;
    // Folder Header
    private var hd:FolderHeader;

    // Folder Maximized  Boolean
    private var fmb:Boolean=false;
    // Previous Folder Size
    private var pfs:Rectangle=new Rectangle;
    // Body Width
    private var bw:Number;
    // Body Height
    private var bh:Number;
    private var aw:Number;
    // Folder Title
    private var FC:uint;

    public function Folder(defaultView:FolderView,defaultLayout:FolderLayout) {

        addView(defaultView,defaultLayout);
        addEventListener(Event.RESIZE,onApplicationResize);

        x=y=30;

        bg=new Background(this);
        bd=new FolderBody(this);
        ft=new FolderFooter(this);
        hd=new FolderHeader(this);

        addChild(bg);
        addChild(bd);
        addChild(hd);
        addChild(ft);

    }
    public function addView(view:FolderView,layout:FolderLayout):void{
        if(!ld[layout]){
            ld[layout]=lv.length;
            lv.push(layout);
        }
        view.layoutIndex=ld[layout];
    }
    public function changeView(view:FolderView):void{
        if(view.layoutIndex){
            bd.removeChild(currentLayout);
            CV=view;
            bd.addChild(currentLayout);
            currentLayout.changeData(CV.data,CV.color);
        }
        hd.changeView(view)
    }
    private function onApplicationResize(e:Event=null):void{
        currentLayout.adjustSections();
    }
    public function maximizeSize ():void {

        pfs.x=x;
        pfs.y=y;
        pfs.width=FW;
        pfs.height=height;
        fmb=true;
        setWidthHeight(stage.stageWidth,stage.stageHeight-Core.panelHandler.height);
        x=y=0;
    }
    public function get maximized():Boolean{

        return fmb;
    }
    public function restoreSize():void{

        fmb=false;
        setWidthHeight(pfs.width,pfs.height);
        x=pfs.x;
        y=pfs.y;
    }
    public function setWidthHeight(width:Number,height:Number):void{

        FW=TW=width;
        FH=TH=height;
    }
    public function close():void{
        Core.folderHandler.folderClose(this);
    }
    public function maximize():void{
        if(maximized)restoreSize();
        else maximizeSize();
    }
    public function minimize():void{
        visible=!visible;
    }

    public function set active(b:Boolean):void{hd.active=b}
    public function set minWidth(value:Number):void{MW=value}

    public function get title():String{return FT}
    public function get color():uint{return FC}
    public function get bodyHeight():Number{return bh}
    public function get borderThickness():int{return bT}
    public function get headerHeight():int{return hh}
    public function get footerHeight():int{return fh}
    public function get outerRadius():int{return or}
    public function get innerRadius():int{return ir}
    public function get defaultView():FolderView{return DV}
    public function get currentView():FolderView{return CV}
    public function get currentLayout():FolderLayout{return lv[CV.layoutIndex]}
    public function get appWidth():Number{return aw}
    public function get appHeight():Number {return bd.contentHeight}

    override public function get width():Number{return FW}
    override public function get height():Number{return FH}

    override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
    }
    override public function stopDrag():void {
    }
    public function set widthOffset(value:Number):void{FW=TW+(TW+value>MW?value:MW-TW)}
    public function set heightOffset(value:Number):void{FH=TH+(TH+value>MH?value:MH-TH)}

    public function adjustingStart():void {
    }
    public function adjustingEnd():void{
        bw=FW-bT*2;
        bh=FH-hh-fh;
        aw=bw-bd.thumbnail.width-Folder.GAP;
        bg.onFolderAdjust(FW,FH,bw,bh);
        ft.onFolderAdjust(FW,FH);
        hd.onFolderAdjust();
        bd.height=bh;
        currentLayout.onFolderResize(bw,bh);
        dispatchEvent(re);
    }
}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.utils.Dictionary;

import vfold.controls.button.ButtonSymbol;
import vfold.controls.tabs.Tabs;
import vfold.core.Core;
import vfold.core.folder.FolderView;
import vfold.core.folder.Folder;
import vfold.display.content.ContentScroll;
import vfold.display.text.TextSimple;
import vfold.utilities.ColorFunction;
import vfold.utilities.Draw;

/*******************************************************
 *
 *  The Background
 *
 ********************************************************/

class Background extends Bitmap{

    // Shape for Background Drawings
    // Not used as a Child
    private var bg:Shape=new Shape;
    // Shape Graphics
    private var g:Graphics=bg.graphics;
    // Drawing Commands
    private var cm:Vector.<int>=new <int>[1,2,3,2,3,2,3,2,3];
    // Inner Radius
    private var ir:int;
    // Outer Radius
    private var or:int;
    // Color
    private var c:uint;
    // Border Thickness
    private var bt:int;
    // Header Height
    private var hh:int;
    private var cn:Sprite = new Sprite;
    // Blur Radius
    private const br:int=12;
    // Glow Filter
    private const gf:GlowFilter=new GlowFilter(ColorFunction.brightness(c,.8),1,7,7,2,1,true);
    // Drop Shadow Filter
    private const sf:DropShadowFilter=new DropShadowFilter(5,90,0,1,br,br,1,1,false,true);
    // Bitmap Data Drawing Color Transform
    private const ct:ColorTransform=new ColorTransform(1,1,1,.8);

    public function Background(folder:Folder) {
        cn.addChild(bg);
        bg.x=bg.y=br;
        x = y = -br;
        ir = folder.innerRadius;
        or = folder.outerRadius;
        c = folder.color;
        bt = folder.borderThickness;
        hh = folder.headerHeight;
    }
    public function onFolderAdjust(w:Number, h:Number,bw:Number, bh:Number):void {
        var bd:BitmapData = new BitmapData(w+(br*2),h+(br*2),true,0);
        g.beginFill(c,1);
        g.drawPath(cm,new <Number>[0,or,0,h-or,0,h,or,h,w-or,h,w,h,w,h-or,w,or,w,0,w-or,0,or,0,0,0,0,or]);
        g.endFill();
        bg.filters=[gf];
        bd.draw(cn,null,ct);
        bg.filters=[sf];
        bd.draw(cn);
        bg.filters=[];
        g.clear();
        g.beginFill(ColorFunction.brightness(c,.55));
        g.drawRoundRect(bt,hh,bw,bh,ir);
        g.endFill();
        bd.draw(cn);
        bitmapData=bd;
        g.clear();
    }
}
/*******************************************************
 *
 *  The Header
 *
 ********************************************************/
class FolderHeader extends Sprite{
    private var ht:HeaderTitle=new HeaderTitle;
    private var tb:Tabs;
    private var btn:HeaderButtons;
    private const g:Number=7;

    // Application Data Index Dictionary
    private var ad:Dictionary=new Dictionary();
    // Application Data Vector
    private var av:Vector.<FolderView>=new Vector.<FolderView>();
    private var f:Folder;

    public function FolderHeader(folder:Folder):void {
        f=folder;
        ht.title=f.title;
        tb=new Tabs(f.headerHeight-f.borderThickness,f.color,.55,onTabSelect,onTabClose,f.title);
        btn=new HeaderButtons(f.minimize,f.maximize,f.close);

        addChild(ht);
        addChild(btn);
        addChild(tb);

        btn.y=(f.headerHeight-btn.height)/2;
        tb.y=f.borderThickness;
        ht.x=f.innerRadius;
        tb.x=ht.width+ht.x;

        mouseEnabled=false;
    }
    public function changeView(view:FolderView):void{
        if(!ad[view])f.minWidth=addView(view);
        else selectView(view);
    }
    private function addView(view:FolderView):Number {
        ad[view]=tb.length;
        tb.selectTab(tb.addTab(view.title).vectorIndex);
        return tb.minimumWidth+btn.width+f.outerRadius+g;
    }
    private function selectView(view:FolderView):void {
        tb.selectTab(ad[view]);
    }
    private function onTabClose():void {

        ad[av[tb.removedIndex]]=null;
        av.splice(tb.removedIndex,1);
        for(var i:uint=tb.removedIndex;i<av.length;i++)ad[av[i]]-=1;
        if(tb.removedSelected){
            if(tb.length!=0)f.changeView(av[tb.currentIndex]);
            else f.changeView(f.defaultView);
        }
    }
    private function onTabSelect():void{
        f.changeView(av[tb.currentIndex]);
    }
    public function onFolderAdjust():void {
        btn.x=f.width-btn.width-f.outerRadius/2;
        tb.adjust(btn.x-g);
    }
    public function set active(b:Boolean):void{
        if(b)tb.alpha=btn.alpha=1;
        else tb.alpha=btn.alpha=.4;
    }
}


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
        color=ColorFunction.brightness(Core.color,.4);
        background.filters=[new BlurFilter(8,8)];
    }
}
class HeaderTitle extends Sprite{
    private var tf:TextSimple=new TextSimple(14,ColorFunction.brightness(Core.color,.7),true);
    public function HeaderTitle(){
        addChild(tf);
    }
    public function set title(value:String):void{
        tf.text=value;
    }
}
/*******************************************************
 *
 *  The Body
 *
 ********************************************************/

class FolderBody extends ContentScroll{


    public function FolderBody(folder:Folder):void {
        x=folder.borderThickness+Folder.GAP;
        y=folder.headerHeight;
    }
    public function onFolderAdjust(bh:Number):void {

        height=bh;
    }
}
/*******************************************************
 *
 *  The Footer
 *
 ********************************************************/
class FolderFooter extends Sprite{

    private var a:FooterFolderAdjust;
    private var bt:int;
    private var fh:int;

    public function FolderFooter(folder:Folder):void{
        bt = folder.borderThickness;
        fh = folder.footerHeight;
        a=new FooterFolderAdjust(folder);
        addChild(a);
    }
    public function onFolderAdjust(w:Number,h:Number):void {
        y=h-fh;
        a.x=w-a.width-bt;
        a.y=fh-a.height-bt;
    }
}

class FooterFolderAdjust extends ButtonSymbol {

    private var lX:Number;
    private var lY:Number;

    private var oW:Number;
    private var oH:Number;
    private var f:Folder;

    public function FooterFolderAdjust(folder:Folder) {

        f=folder;
        var s:Shape=new Shape;
        Draw.resize(s.graphics,12,12/3);
        s.alpha=.7;
        addChild(s);
        background.filters=[new BlurFilter(8,8)];
        color=ColorFunction.brightness(Core.color,.4);
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    override protected function onDown():void {
        lX=mouseX;
        lY=mouseY;
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        f.adjustingStart();
    }
    private function onMouseMove(e:MouseEvent):void {
        f.widthOffset=oW=mouseX-lX;
        f.heightOffset=oH=mouseY-lY;
    }
    override public function onMouseUp(e:MouseEvent = null):void {
        f.widthOffset=oW;
        f.heightOffset=oH;
        f.adjustingEnd();
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
    }
}
