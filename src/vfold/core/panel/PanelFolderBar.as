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
    // Folder Handler
    private const fh:FolderHandler=Core.folderHandler;
    public function PanelFolderBar() {

        fh.addEventListener(FolderHandler.FOLDER_CREATE,onFolderCreate);
        fh.addEventListener(FolderHandler.FOLDER_SELECT,onFolderSelect);
        fh.addEventListener(FolderHandler.FOLDER_CLOSE,onFolderClose);


        h=(Core.panelHandler.contentHeight-Core.panelHandler.contentGap)/2;

        tb=new Tabs(Core.panelHandler.contentHeight/2-3,Core.color,.7,onTabSelect,onTabClose);
        tb.y=Core.panelHandler.contentHeight-tb.height;
        addChild(tb);
    }
    /****************************************
     *
     *  EVENT HANDLERS FROM FOLDER HANDLER
     *
     * **************************************
     * */
    private function onFolderCreate(e:Event):void {
        tb.addTab(fh.currentFolder.title,fh.currentFolder);
        tb.selectTab(fh.currentFolder);
    }
    private function onFolderSelect(e:Event=null):void {
        tb.selectTab(fh.currentFolder);
    }
    private function onFolderClose(e:Event):void{
        tb.removeTab(fh.currentFolder);
    }
    /****************************************
     *
     *     FUNCTION CALLERS FROM TABS
     *
     * **************************************
     * */
    private function onTabClose():void {
        //fh.closeFolder(tb.currentData);
    }

    private function onTabSelect():void{
        //fh.folderSelect(tb.currentData);
    }
    /****************************************
     *
     *           NOT IMPORTANT
     *
     * **************************************
     * */
    override public function onStageResize(e:Event = null):void {
        tb.adjust(stage.stageWidth-x);
    }
    override public function get height():Number {return h}
}
}