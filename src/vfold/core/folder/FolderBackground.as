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
import flash.filters.DropShadowFilter;

public class FolderBackground extends FolderView{
    private var bg:Shape=new Shape;
    private var g:Graphics=bg.graphics;

    public function FolderBackground(fl:Folder) {
        super(fl);
        addChild(bg);
        filters=[new DropShadowFilter(3,90,0,1,7,7,1.3)];
        alpha=.8;
    }
    override public function onFolderAdjust(e:Event = null):void {
        drawBackground();
    }
    public function drawBackground():void{
        g.clear();
        g.beginFill(folder.color,1);
        g.moveTo(0,outerRadius);
        g.lineTo(0,folder.height-outerRadius);
        g.curveTo(0,folder.height,outerRadius,folder.height);
        g.lineTo(folder.width-outerRadius,folder.height);
        g.curveTo(folder.width,folder.height,folder.width,folder.height-outerRadius);
        g.lineTo(folder.width,outerRadius);
        g.curveTo(folder.width,0,folder.width-outerRadius,0);
        g.lineTo(outerRadius,0);
        g.curveTo(0,0,0,outerRadius);
    }

}
}