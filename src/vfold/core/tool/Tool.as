/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.tool {
import flash.display.Sprite;
import flash.events.Event;
import vfold.core.Core;
import vfold.core.panel.PanelToolBar;

public class Tool extends Sprite {

    // Alignment of tool on toolbar
    public var align:String=ToolAlign.RIGHT;
    // Tool Change
    public static const TOOL_CHANGE:String="toolChange";

    protected function get toolbarWidth():Number{return Core.panelHandler.toolbar.width}
    override public function get height():Number {return Core.panelHandler.toolbar.height}
    protected function change():void{
        dispatchEvent(new Event(TOOL_CHANGE,true));
    }
    protected function get toolbar():PanelToolBar{return Core.panelHandler.toolbar}
}
}
