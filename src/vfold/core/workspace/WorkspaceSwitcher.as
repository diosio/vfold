/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.workspace {
import flash.events.Event;
import vfold.core.Core;
import vfold.core.tool.Tool;
import vfold.core.tool.ToolAlign;
import vfold.controls.button.ButtonLabel;

public class WorkspaceSwitcher extends Tool {

    // Tool Button
    private var bt:ButtonLabel=new ButtonLabel;

    public function WorkspaceSwitcher() {

        //bt.setDropBox(lt, this);
        bt.textField.bold=true;

        bt.label="Dashboard";
        addChild(bt);

        align=ToolAlign.LEFT;
        Core.dispatcher.addEventListener(Core.WORKSPACE_CHANGE,onWorkspaceChange);
    }
    public function addSwitch(label:String):void{
        //lt.addEntry(label);
    }
    private function onWorkspaceChange(e:Event):void{useSwitch(Core.currentWorkspaceIndex)}
    private function useSwitch(index:uint):void{/*bt.label=lt.entries[index].text*/}
}
}
