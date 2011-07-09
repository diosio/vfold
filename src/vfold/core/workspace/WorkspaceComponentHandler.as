/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.core.workspace {
import vfold.core.*;

import flash.events.Event;
public class WorkspaceComponentHandler extends CoreView {
    public function WorkspaceComponentHandler() {
        Core.dispatcher.addEventListener(Core.WORKSPACE_CHANGE,onWorkspaceChange);
        Core.dispatcher.addEventListener(Core.WORKSPACE_ADD,onWorkspaceAdd)
    }
    protected function onWorkspaceChange(e:Event):void{}
    protected function onWorkspaceAdd(e:Event):void{}
}
}
