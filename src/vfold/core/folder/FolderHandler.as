/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {

import flash.display.DisplayObject;
import flash.display.Sprite;

import vfold.controls.tabs.Tabs;

import vfold.core.Core;
import vfold.core.workspace.WorkspaceComponentHandler;
import flash.events.Event;

public final class FolderHandler extends WorkspaceComponentHandler {

    public static const FOLDER_CREATE:String="FolderAdd";
    public static const FOLDER_CLOSING:String="FolderClose";
    public static const FOLDER_SELECT:String = "FolderSelect";

    // Workspace Container Vector
    private var wcv:Vector.<Sprite>=new <Sprite>[];
    // Active Folder
    private var af:Folder;
    // Tabs
    private var tb:Tabs;


    public function FolderHandler():void{

        // This is a dummy dashboard workspace
        addChild(new Sprite);
        mouseEnabled=false;
        addEventListener(Folder.FOLDER_SELECT,onFolderSelect);
    }
    private function onFolderSelect(e:Event):void {
        selectFolder(Folder(e.target));
    }
    override protected function onStageAdded():void {
        tb=new Tabs(Core.panelHandler.contentHeight/2-3,Core.color,.7,onTabSelect,onTabClose);
        tb.y=Core.panelHandler.contentHeight-tb.height;
        addChild(tb);
        removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
        y=Core.panelHandler.height;
    }
    private function onTabClose():void {removeFolder(tb.currentData);}
    private function onTabSelect():void{selectFolder(tb.currentData);}
    private function addedToStage(e:Event):void{

    }
    public function addFolder(classPath:String):void {
        Core.currentWorkspace.folders.getAppComponent(classPath).instantiate(function(instance:*):void{
            var f:Folder = Folder(instance);
            tb.addTab(f.title,f);
            dispatchEvent(new Event(FOLDER_CREATE));
            selectFolder(f);
        });
    }
    private function removeFolder(folder:Folder):void{
        af=folder;
        currentWorkspace.removeChild(folder);
        dispatchEvent(new Event(FOLDER_CLOSING));
    }
    public function closeFolder(folder:Folder):void{
        tb.removeTabByData(folder);
        removeFolder(folder);
    }
    public function selectFolder(folder:Folder):void{
        if(currentWorkspace.numChildren>0)Folder(currentWorkspace.getChildAt(currentWorkspace.numChildren-1)).active=false;
        folder.active=true;
        tb.selectTab(folder);
        af=folder;
        currentWorkspace.addChildAt(folder,currentWorkspace.numChildren);
        dispatchEvent(new Event(FOLDER_SELECT));
    }
    override protected function onWorkspaceChange(e:Event):void {
        removeChildAt(0);
        addChild(wcv[Core.currentWorkspaceIndex]);
    }
    override protected function onWorkspaceAdd(e:Event):void {
        wcv.push(new Sprite());
    }
    override public function onStageResize(e:Event = null):void {
        tb.adjust(stage.stageWidth-x);
    }

    private function get currentWorkspace():Sprite{return  wcv[Core.currentWorkspaceIndex]}
    public function get folderBar():DisplayObject{return tb}
    public function get activeFolder():Folder{return af}

}
}