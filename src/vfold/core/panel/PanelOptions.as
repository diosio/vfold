/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.panel {

import flash.display.Bitmap;
import vfold.controls.button.ButtonOptions;
import vfold.core.tool.ToolComponent;

public class PanelOptions{
    // Menu
    private var m:Vector.<ButtonOptions>=new Vector.<ButtonOptions>();
    // Color
    public var color:uint;
    // Tools
    private var to:Object={};
    // Menu Launcher Logo
    public var logo:Bitmap;

    public function get menu():Vector.<ButtonOptions> {return m}
    public function getToolComponent(classPath:String):ToolComponent{return to[classPath] as ToolComponent}
    public function setToolComponent(toolComponent:ToolComponent):void{to[toolComponent.classPath]=toolComponent}
}
}
