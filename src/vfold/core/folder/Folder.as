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
    private var bg:FolderBackground;
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

    public function Folder(application:Application,index:uint) {

        x=y=30;

        FI=index;
        FA=application;
        FA.folder=this;
        FT=FA.title;
        FC=FA.color;

        bg=new FolderBackground(this);
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
        bg.drawBackground();
    }
    public function adjustingEnd(widthOffset:Number=0,heightOffset:Number=0):void{
        TW+=TW+widthOffset>MW?widthOffset:MW-TW;
        TH+=TH+heightOffset>MH?heightOffset:MH-TH;
        FW=TW;
        FH=TH;
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
    public function get appWidth():Number{return bd.appWidth}
    public function get appHeight():Number{return bd.appHeight}
    public function set minWidth(value:Number):void{MW=value}

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