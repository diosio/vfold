/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget {
import vfold.core.workspace.WorkspaceComponent;

public class WidgetOptions {
    // Widget Components
    private var wc:Object={};
    public function getWidgetComponent(classPath:String):WorkspaceComponent{return wc[classPath] as WorkspaceComponent}
    public function setWidgetComponent(widgetComponent:WorkspaceComponent):void{wc[widgetComponent.classPath]=widgetComponent}
}
}
