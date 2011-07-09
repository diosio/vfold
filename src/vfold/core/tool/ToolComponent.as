/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.tool {
import vfold.core.workspace.WorkspaceComponent;
public class ToolComponent extends WorkspaceComponent {
    // Tool Alignment
    private var al:String="";
    public function get alignment():String{return al}
    public function set alignment(value:String):void{al=value}
}
}
