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
import vfold.utilities.ColorModifier;

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
        x=borderThickness;
        y=headerHeight;
        sb=new ContentScroll(folder.application);
        sb.x=Application.GAP;
        sW=sb.thumbnail.width;
        addChild(bg);
        addChild(sb);
    }
    override public function onFolderAdjust(e:Event = null):void {
        bW=folder.width-2*borderThickness;
        bH=folder.height-headerHeight-footerHeight;
        drawGraphics(bg.graphics);
        sb.height=bH;
    }
    private function drawGraphics(g:Graphics):void{
        g.clear();
        g.beginFill(ColorModifier.brightness(folder.color,.7));
        g.drawRoundRect(0,0,bW,bH,innerRadius);
        g.endFill();
    }
    public function get appWidth():Number{return bW-sW-Application.GAP}
    public function get appHeight():Number{return bH}
}
}