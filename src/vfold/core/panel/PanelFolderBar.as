/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {
import flash.events.Event;
import vfold.controls.tabs.Tabs;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.core.folder.FolderHandler;

public class PanelFolderBar extends CoreView{
    // Tabs
    private var tb:Tabs;
    // Height
    private var h:Number;
    public function PanelFolderBar() {

        h=(Core.panelHandler.contentHeight-Core.panelHandler.contentGap)/2;
        Core.folderHandler.addEventListener(FolderHandler.FOLDER_ADD,tabAdd);
        Core.folderHandler.addEventListener(FolderHandler.FOLDER_SELECT,tabSelect);
        Core.folderHandler.addEventListener(FolderHandler.FOLDER_CLOSE,tabClose);
        tb=new Tabs(Core.panelHandler.contentHeight/2-3,Core.color,.7,onTabSelect,onTabClose);
        tb.y=Core.panelHandler.contentHeight-tb.height;
        addChild(tb);
    }
    private function tabClose(e:Event):void{
        tb.removeTab(Core.folderHandler.currentIndex);
    }
    private function onTabClose():void {
        Core.folderHandler.closeFolderByIndex(tb.removedIndex);
    }
    private function tabAdd(e:Event):void {
        tb.selectTab(tb.addTab(Core.folderHandler.currentFolder.title).vectorIndex);
    }
    private function onTabSelect():void{
        Core.folderHandler.folderSelect(tb.currentIndex);
    }
    private function tabSelect(e:Event=null):void {
        tb.selectTab(Core.folderHandler.currentIndex);
    }
    override public function onStageResize(e:Event = null):void {
        tb.adjust(stage.stageWidth-x);
    }
    override public function get height():Number {return h}
}
}