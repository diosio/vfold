/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;


import vfold.core.Core;
import vfold.core.CoreView;
import vfold.core.application.Application;
import vfold.core.application.ApplicationView;

public class Folder extends CoreView{

    public static const ADJUSTING_END:String="fldAdjust";

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

    // Folder Index
    private var FI:uint;
    // Folder Application
    private var FA:Application;
    // Folder Title
    private var FT:String;
    // Folder Color
    private var FC:uint;

    // Folder Background
    private var bg:Background;
    // Folder Body
    private var bd:FolderBody;
    // Folder Footer
    private var ft:FolderFooter;
    // Folder Header
    private var hd:FolderHeader;

    // Folder Body/Footer/Header Container
    private var cn:Sprite=new Sprite;

    // Folder Maximized  Boolean
    private var fmb:Boolean=false;
    // Previous Folder Size
    private var pfs:Rectangle=new Rectangle;
    // Body Width
    private var bw:Number;
    // Body Height
    private var bh:Number;
    // Application Width
    private var aw:Number;

    public function Folder(application:Application,index:uint) {

        x=y=30;

        FI=index;
        FA=application;
        FA.folder=this;
        FT=FA.title;
        FC=FA.color;

        bg=new Background(this);
        bd=new FolderBody(this);
        ft=new FolderFooter(this);
        hd=new FolderHeader(this);

        addChild(bg);
        addChild(cn);
        cn.addChild(bd);
        cn.addChild(hd);
        cn.addChild(ft);
        cn.mouseEnabled=false;

        adjustingEnd();
    }
    public function adjustingStart():void{
        cn.visible=false;
    }
    public function adjusting(widthOffset:Number,heightOffset:Number):void{
        FW=TW+(TW+widthOffset>MW?widthOffset:MW-TW);
        FH=TH+(TH+heightOffset>MH?heightOffset:MH-TH);
        //bg.drawBackground();
    }
    public function adjustingEnd(widthOffset:Number=0,heightOffset:Number=0):void{

        TW+=TW+widthOffset>MW?widthOffset:MW-TW;
        TH+=TH+heightOffset>MH?heightOffset:MH-TH;
        FW=TW;
        FH=TH;

        bw=FW-bT*2;
        bh=FH-hh-fh;
        aw=bw-bd.thumbnail.width-Application.GAP;
        bg.onFolderAdjust(FW,FH,bw,bh);
        bd.height=bh;
        dispatchEvent(new Event(ADJUSTING_END));
        FA.onFolderResize();
        cn.visible=true;
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

        dispatchEvent(new Event(ADJUSTING_END));
    }
    public function close():void{
        Core.folderHandler.folderClose(folderIndex);
    }
    public function maximize():void{
        if(maximized)restoreSize();
        else maximizeSize();
    }
    public function minimize():void{
        visible=!visible;
    }
    public function changeView(view:ApplicationView):void{hd.changeView(view)}
    public function set active(b:Boolean):void{hd.active=b}
    public function set folderIndex(value:uint):void{FI=value}
    public function get folderIndex():uint{return FI}
    public function get application():Application{return FA}
    public function get title():String{return FT}
    public function get color():uint{return FC}
    public function get appWidth():Number{return aw}
    public function get appHeight():Number{return bh}
    public function set minWidth(value:Number):void{MW=value}
    public function get borderThickness():int{return bT}
    public function get headerHeight():int{return hh}
    public function get footerHeight():int{return fh}
    public function get outerRadius():int{return or}
    public function get innerRadius():int{return ir}

    override public function get width():Number{return FW}
    override public function get height():Number{return FH}

    override public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void {
        removeChild(cn);
    }
    override public function stopDrag():void {
        addChild(cn);
    }
}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;

import vfold.core.application.Application;
import vfold.core.folder.Folder;
import vfold.display.content.ContentScroll;
import vfold.utilities.ColorFunction;

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
    // Container Helper
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
class FolderBody extends ContentScroll{


    public function FolderBody(folder:Folder):void {
        super(folder.application);
        x=folder.borderThickness+Application.GAP;
        y=folder.headerHeight;
    }
    public function onFolderAdjust(bh:Number):void {

        height=bh;
    }
}
