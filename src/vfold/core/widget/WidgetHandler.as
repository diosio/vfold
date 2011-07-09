/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget {
import flash.events.Event;

import vfold.core.Core;
import vfold.core.workspace.WorkspaceComponentHandler;
import vfold.controls.menu.MenuButtons;
import vfold.core.widget.Notifier;
import vfold.core.widget.search.Search;
import vfold.core.widget.search.SearchInterface;

public class WidgetHandler extends WorkspaceComponentHandler{

    private var n:Notifier;
    private var a:Search;

    override protected function onStageAdded():void {
        n=new Notifier();
        a=new Search(Core.color);
        addChild(n);
        y=Core.panelHandler.height;
    }
    override public function onStageResize(e:Event = null):void {

        n.x = stage.stageWidth-8;
        n.y = stage.stageHeight-y-8;
    }
    public function patchSearchEngine(patch:SearchInterface):void{

        a.addSearchEngine(patch);
        a.selectEngine(0);
        a.search(Core.flashVars.address);
    }
    public function get notifier():Notifier{return n}
}
}