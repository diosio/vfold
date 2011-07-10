/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {

import flash.display.Sprite;
import flash.events.Event;

import vfold.controls.button.ButtonDropBox;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.core.tool.Tool;
import vfold.core.account.Account;
import vfold.core.workspace.WorkspaceSwitcher;

public class PanelToolBar extends CoreView {

    // Left Container
    private var lc:Sprite=new Sprite;
    // Right Container
    private var rc:Sprite=new Sprite;
    // Width
    private var w:Number;
    // Height
    private var h:Number;
    // Tool Gap
    private const g:uint=3;

    /******************************************
     * GLOBAL TOOLS                           *
     ******************************************/

    // Account Tool
    private var ac:Account;
    // Workspace Switcher Tool
    private var ws:WorkspaceSwitcher;

    public function PanelToolBar() {

        y=Core.panelHandler.contentGap;
        h=(Core.panelHandler.contentHeight-Core.panelHandler.contentGap)/2-Core.panelHandler.contentGap;
        addEventListener(Tool.TOOL_CHANGE,onToolChange);
    }
    override protected function onStageAdded():void {

        ac=new Account();
        ws=new WorkspaceSwitcher();
        addTool(ac);
        addTool(ws);
        addChild(lc);
        addChild(rc);
    }
    private function onToolChange(e:Event):void{
        var t:Tool=Tool(e.target);
        var i:uint;
        switch(t.align){
            case Tool.ALIGN_LEFT:
                for(i=0;i<lc.numChildren;i++){
                    if(i!=0)lc.getChildAt(i).x=lc.getChildAt(i-1).x+lc.getChildAt(i-1).width+g;
                    else lc.getChildAt(i).x=g;
                }
                break;
            case Tool.ALIGN_RIGHT:
                for(i=0;i<rc.numChildren;i++){
                    if(i!=0)rc.getChildAt(i).x=-rc.getChildAt(i-1).x-rc.getChildAt(i-1).width-g;
                    else rc.getChildAt(i).x=-rc.getChildAt(i).width;
                }
                break;
        }
    }
    private function addTool(tool:Tool):void{
        var i:uint;
        switch(tool.align){

            case Tool.ALIGN_LEFT:
                i=lc.numChildren;
                lc.addChild(tool);
                if(i!=0)tool.x=lc.getChildAt(i-1).x+lc.getChildAt(i-1).width+g;
                else tool.x=g;
                break;
            case Tool.ALIGN_RIGHT:
                i=rc.numChildren;
                rc.addChild(tool);
                if(i!=0)tool.x=-rc.getChildAt(i-1).x-tool.width-g;
                else tool.x=-tool.width;
                break;
        }
    }
    override public function onStageResize(e:Event = null):void {
        w=stage.stageWidth-x-Core.panelHandler.contentGap;
        rc.x=w;
        dispatchEvent(new Event(ButtonDropBox.ADJUST_OFFSET));
    }
    override public function get width():Number {return w}
    override public function get height():Number {return h}

    public function get workspaceSwitcher():WorkspaceSwitcher{return ws}
}
}


