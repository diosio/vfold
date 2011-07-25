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
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import vfold.controls.button.ButtonSymbol;

import vfold.core.Core;
import vfold.core.CoreView;

public class Folder extends CoreView{

    public static const FOLDER_SELECT:String="folderSelect";
    // Folder Select Event
    private var fse:Event=new Event(FOLDER_SELECT,true);

    // Folder Layout Dictionary
    private var ld:Dictionary=new Dictionary();
    // Folder Layout Vector;
    private var lv:Vector.<FolderLayout>=new Vector.<FolderLayout>();

    // Current View
    private var CV:FolderView;
    // Default View
    private var DV:FolderView;


    // Border Thickness
    private const bT:int = 7;
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
    // Minimum Width
    private var MW:Number=100;
    // Minimum Height
    private var MH:Number=100;
    // Folder Title
    private var FT:String;

    // Folder Border
    private var br:Border;
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
    // Folder Color
    private var FC:uint=Core.color;
    // x position Offset
    private var xO:Number;
    // y position Offset
    private var yO:Number;
    // Folder Active
    private var fa:Boolean=false;


    public function Folder(defaultView:FolderView,defaultLayout:FolderLayout) {

        FT = defaultView.title;
        DV=CV=defaultView;
        addView(DV,defaultLayout);
        defaultLayout.changeData(DV.data);

        addEventListener(Event.RESIZE,onApplicationResize);

        br=new Border(this);
        bg=new Background(this);
        bd=new FolderBody(this);
        ft=new FolderFooter(this);
        hd=new FolderHeader(this);
        bd.content.addChild(defaultLayout);

        x=y=30;
        addChild(bg);
        addChild(bd);
        addChild(hd);
        addChild(ft);
        addChild(br);

        adjustEnd();
        br.adjust(FW,FH);

        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    private function onMouseDown(e:MouseEvent):void {
        switch(e.target.constructor){
            case HeaderTitle:
                startDrag();
                break;
            case HeaderButton:
                ButtonSymbol(e.target).onMouseDown();
                break;
            case FooterFolderAdjust:
                FooterFolderAdjust(e.target).onMouseDown();
                break;
        }
        if(!fa)dispatchEvent(fse);
    }
    public function addView(view:FolderView,layout:FolderLayout):void{
        if(!ld[layout]){
            layout.y=FolderBody.GAP;
            ld[layout]=lv.length;
            lv.push(layout);
        }
        view.layoutIndex=ld[layout];
    }
    public function useView(view:FolderView):void{
        if(view.layoutIndex){
            CV.y=currentLayout.y;
            CV=view;
            currentLayout.y=CV.y;
            bd.switchLayout(currentLayout);
            currentLayout.changeData(CV.data);
        }
        hd.changeView(view);
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
        adjustSize(stage.stageWidth,stage.stageHeight-Core.panelHandler.height);
        adjustEnd();
        x=y=0;
    }
    public function get maximized():Boolean{

        return fmb;
    }
    public function restoreSize():void{

        fmb=false;
        adjustSize(pfs.width,pfs.height);
        x=pfs.x;
        y=pfs.y;
        adjustEnd();
    }
    public function adjustSize(width:Number,height:Number):void{
        FW=width;
        FH=height;
    }
    public function close():void{
        Core.folderHandler.closeFolder(this);
    }
    public function maximize():void{
        if(maximized)restoreSize();
        else maximizeSize();
    }
    public function minimize():void{
        visible=!visible;
    }

    protected function set color_(value:uint):void{FC = value}
    public function set active(b:Boolean):void{
        fa=b;
        if(b)
            hd.alpha=br.alpha=ft.alpha=1;
        else
            hd.alpha=br.alpha=ft.alpha=.4;
    }
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
    public function get minWidth():Number{return MW}
    public function get minHeight():Number{return MH}
    public function get border():Border{return br}

    override public function get width():Number{return FW}
    override public function get height():Number{return FH}


    private function onMouseMove(e:MouseEvent):void {
        x=stage.mouseX-xO;
        y=stage.mouseY-yO;
        if(y<0)y = 0;
        else if(y>stage.stageHeight-yO)y=stage.stageHeight-yO;
        if(x<-xO)x=-xO;
        else if(x>stage.stageWidth-xO)x=stage.stageWidth-xO;
    }
    private function onMouseUp(e:MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }
    override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
        xO = stage.mouseX-x;
        yO = stage.mouseY-y;
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }
    override public function stopDrag():void {
        adjustEnd();
    }
    private function adjustEnd():void{
        bw=FW-bT*2;
        bh=FH-hh-fh;
        bg.onFolderAdjust(FW,FH);
        ft.onFolderAdjust(FW,FH);
        hd.onFolderAdjust();
        bd.onFolderAdjust(bw,bh);
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
import flash.geom.ColorTransform;
import flash.utils.Dictionary;

import vfold.controls.button.ButtonSymbol;
import vfold.controls.tabs.Tabs;
import vfold.core.Core;
import vfold.core.folder.FolderLayout;
import vfold.core.folder.FolderView;
import vfold.core.folder.Folder;
import vfold.display.content.ContentScroll;
import vfold.display.text.TextSimple;
import vfold.utility.ColorUtility;
import vfold.utility.GraphicUtility;

/*******************************************************
 *
 *  Border
 *
 ********************************************************/

class Border extends Shape{
    private var g:Graphics = graphics;
    private var r:int;
    private var c:int;
    public function Border(f:Folder){
        r=f.outerRadius;
        c=f.color;
    }
    public function adjust(w:Number,h:Number):void{
        g.clear();
        g.lineStyle(2,ColorUtility.brightness(c,.65),1,true);
        g.drawRoundRect(0,0,w,h,r);
    }
}

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
    public function onFolderAdjust(w:Number, h:Number):void {
        var bd:BitmapData = new BitmapData(w+(br*2),h+(br*2),true,0);
        g.beginFill(c,1);
        g.drawRoundRect(0,0,w,h,or);
        g.endFill();
        bd.draw(cn,null,ct);
        bg.filters=[sf];
        bd.draw(cn);
        bg.filters=[];
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

        tb=new Tabs(f.headerHeight-f.borderThickness,f.color,.55,onTabSelect,onTabClose);
        btn=new HeaderButtons(f.minimize,f.maximize,f.close);

        ht.title=f.title;

        addChild(ht);
        addChild(btn);
        addChild(tb);

        btn.y=(f.headerHeight-btn.height)/2;
        tb.y=f.borderThickness;
        ht.x=f.innerRadius;
        ht.y = (f.headerHeight-ht.height)/2;
        tb.x=ht.width+ht.x;

        mouseEnabled=false;
    }
    public function changeView(view:FolderView):void{
        if(!ad[view])f.minWidth=addView(view);
        else selectView(view);
    }
    private function addView(view:FolderView):Number {
        ad[view]=tb.length;
        tb.selectTab(tb.addTab(view.title).index);
        return tb.minimumWidth+btn.width+f.outerRadius+g;
    }
    private function selectView(view:FolderView):void {
        tb.selectTab(ad[view]);
    }
    private function onTabClose():void {
        // TODO: Fix Header Tabs
        /*ad[av[tb.removedIndex]]=null;
         av.splice(tb.removedIndex,1);
         for(var i:uint=tb.removedIndex;i<av.length;i++)ad[av[i]]-=1;
         if(tb.removedSelected){
         if(tb.length!=0)f.useView(av[tb.currentIndex]);
         else f.useView(f.defaultView);
         }       */
    }
    private function onTabSelect():void{
        f.useView(av[tb.currentIndex]);
    }
    public function onFolderAdjust():void {
        btn.x=f.width-btn.width-f.outerRadius/2;
        tb.adjust(btn.x-g);
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
        GraphicUtility.close(cl.graphics,bs);
        GraphicUtility.minimize(mn.graphics,bs);
        GraphicUtility.maximize(mx.graphics,bs);
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
    }
    private function onMouseOver(e:MouseEvent):void {ButtonSymbol(e.target).onMouseOver()}
    private function onMouseOut(e:MouseEvent):void {ButtonSymbol(e.target).onMouseOut()}
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
    private var f:Function;
    public function HeaderButton(symbol:DisplayObject,onDownFunction:Function){
        f=onDownFunction;
        addChild(symbol);
        color=ColorUtility.brightness(Core.color,.4);
        background.filters=[new BlurFilter(8,8)];
    }

    override protected function onDown():void {
        f.call();
    }
}
class HeaderTitle extends Sprite{
    private var tf:TextSimple=new TextSimple(14,ColorUtility.brightness(Core.color,.7),true);
    public function HeaderTitle(){
        addChild(tf);
        mouseChildren=false;
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
    public static const GAP:uint=7;

    private var bg:Bitmap = new Bitmap();
    private var s:Shape = new Shape();
    private var g:Graphics=s.graphics;
    private var f:Folder;
    private var c:uint;
    public function FolderBody(folder:Folder):void {
        f = folder;
        c = ColorUtility.brightness(f.color,.55);
        super(c);
        x=f.borderThickness+GAP;
        bg.x=-GAP;
        y=f.headerHeight;
        addChild(f.currentLayout);
        wheelEnabled=true;
        addChildAt(bg,0);
    }
    public function switchLayout(layout:FolderLayout):void{
        content.removeChild(getChildAt(0));
        content.addChild(layout);
    }
    public function onFolderAdjust(w:Number,h:Number):void {
        var bd:BitmapData=new BitmapData(w,h,true,0);
        g.clear();
        g.beginFill(c);
        g.drawRoundRect(0,0,w,h,f.innerRadius);
        bd.draw(s);
        bg.bitmapData=bd;

        width=w-GAP;height=h;
        FolderLayout(content.getChildAt(0)).onFolderResize(maskWidth-(GAP-barGap),h);
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
        a.y=((fh-bt-a.height)/2);
        a.x=w-a.width-(fh-(a.y+a.height));
    }

    override public function get height():Number {
        return super.height;
    }
}

class FooterFolderAdjust extends ButtonSymbol {

    private var lX:Number;
    private var lY:Number;

    private var oW:Number;
    private var oH:Number;
    private var f:Folder;

    // Temporary Width
    private var TW:Number;
    // Temporary Height
    private var TH:Number;


    public function FooterFolderAdjust(folder:Folder) {
        f=folder;
        TW=f.width;
        TH=f.height;
        var s:Shape=new Shape;
        GraphicUtility.resize(s.graphics,12,12/3);
        s.alpha=.7;
        addChild(s);
        background.filters=[new BlurFilter(8,8)];
        color=ColorUtility.brightness(Core.color,.4);
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
    }
    override protected function onDown():void {
        lX=mouseX;
        lY=mouseY;
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
    }
    private function onMouseMove(e:MouseEvent):void {
        oW=mouseX-lX;
        oH=mouseY-lY;
        f.border.adjust(folderWidth,folderHeight);
    }
    private function get folderWidth():Number{return TW+(TW+oW>f.minWidth?oW:f.minWidth-TW)}
    private function get folderHeight():Number{return TH+(TH+oH>f.minHeight?oH:f.minHeight-TH)}
    override public function onMouseUp(e:MouseEvent = null):void {
        f.adjustSize(TW=folderWidth,TH=folderHeight);
        f.stopDrag();
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
    }
}
