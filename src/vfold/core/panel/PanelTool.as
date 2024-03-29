/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import vfold.core.Core;

public class PanelTool extends Sprite {

    public static const ALIGN_LEFT:String="left";
    public static const ALIGN_RIGHT:String="right";

    // Alignment of tool on toolbar
    public var align:String=ALIGN_RIGHT;
    // Tool Change
    public static const TOOL_CHANGE:String="toolChange";

    protected function change():void{
        dispatchEvent(new Event(TOOL_CHANGE,true));
    }
    protected function get toolbar():DisplayObject{return Core.panelHandler.toolbar}
        // Tool Alignment
    private var al:String="";
    public function get alignment():String{return al}
    public function set alignment(value:String):void{al=value}
}
}
