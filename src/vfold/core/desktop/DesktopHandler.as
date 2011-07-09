/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.desktop {

import flash.events.Event;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.core.workspace.WorkspaceComponentHandler;

public class DesktopHandler extends WorkspaceComponentHandler {

    // Current Desktop
    private var cd:CoreView;
    // Instance Vector
    private var io:Object={};
    // Class Path Vector
    private var cv:Vector.<String>=new Vector.<String>;
    public function DesktopHandler():void{
    }
    override protected function onWorkspaceChange(e:Event):void {
        var i:uint=Core.currentWorkspaceIndex;
        if(i<cv.length)addDesktop(io[cv[i]]);
        else Core.currentWorkspace.desktop.instantiate(function(instance:*):void{
            cv.push(Core.currentWorkspace.desktop.classPath);
            io[cv[cv.length-1]]=instance;
            addDesktop(instance)
        });
    }
    private function addDesktop(instance:*):void{
        if(numChildren>0)removeChildAt(0);
        cd=instance as CoreView;
        addChild(cd);
    }
}
}