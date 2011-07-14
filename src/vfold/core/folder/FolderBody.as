/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.folder {
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import vfold.core.application.Application;
import vfold.display.content.ContentScroll;
import vfold.utilities.ColorFunction;

public class FolderBody extends FolderView{
    // Body Width
    private var bW:Number;
    // Body Height
    private var bH:Number;

    //Scroll bar Width
    private var sW:Number;

    private var sb:ContentScroll;
    private var bg:Shape=new Shape;

    public function FolderBody(folder:Folder):void {
        super(folder);
        x=folder.borderThickness;
        y=folder.headerHeight;
        sb=new ContentScroll(folder.application);
        sb.x=Application.GAP;
        sW=sb.thumbnail.width;
        addChild(bg);
        addChild(sb);
    }
    override public function onFolderAdjust(e:Event = null):void {
        bW=folder.width-2*folder.borderThickness;
        bH=folder.height-folder.headerHeight-folder.footerHeight;
        drawGraphics(bg.graphics);
        sb.height=bH;
    }
    private function drawGraphics(g:Graphics):void{
        g.clear();
        g.beginFill(ColorFunction.brightness(folder.color,.55));
        g.drawRoundRect(0,0,bW,bH,folder.innerRadius);
        g.endFill();
    }
    public function get appWidth():Number{return bW-sW-Application.GAP}
    public function get appHeight():Number{return bH}
}
}