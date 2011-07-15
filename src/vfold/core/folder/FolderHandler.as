/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import vfold.controls.button.Button;
import vfold.core.Core;
import vfold.core.workspace.WorkspaceComponentHandler;
import flash.events.Event;

public class FolderHandler extends WorkspaceComponentHandler {

    public static const FOLDER_ADD:String="FolderAdd";
    public static const FOLDER_CLOSE:String="FolderClose";
    public static const FOLDER_SELECT:String = "FolderSelect";

    // folder Dictionary
    private var fd:Dictionary=new Dictionary;
    // Folder Vector
    private var fV:Vector.<Folder>=new <Folder>[];
    // current Index
    private var cI:uint;
    // previous Index
    private var pI:uint;
    // Folder Boundaries
    private var bnd:Rectangle=new Rectangle();
    // Workspace Container Vector
    private var wcv:Vector.<Sprite>=new <Sprite>[];
    // Dashboard Container
    private var dbc:Sprite=new Sprite;
    // X Offset
    private var xO:Number;
    // Y Offset
    private var yO:Number;

    public function FolderHandler():void{
        addChild(dbc);
        mouseEnabled=false;
        addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }
    private function addedToStage(e:Event):void{

        removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
        y=Core.panelHandler.height;
    }
    public function addFolder(classPath:String):void {
        Core.currentWorkspace.folders.getAppComponent(classPath).instantiate(onAppInstantiated);
    }
    private function onAppInstantiated(instance:*):void {
        fV.push(instance as Folder);
        pI=cI;
        cI=fV.length-1;
        wcv[Core.currentWorkspaceIndex].addChild(fV[cI]);
        dispatchEvent(new Event(FOLDER_ADD));
    }
    private function folderRemove(index:uint):void{

        removeChild(fV[index]);
        fV[index]=fd[fV[index]]=null;
        fV.splice(i,1);
        for (var i:uint=index;i<fV.length;i++){
            fd[fV[i]]=i;
        }
        dispatchEvent(new Event(FOLDER_CLOSE));
    }
    public function getFolderIndex(folder:Folder):uint{
        return fd[folder];
    }
    public function closeFolder(folder:Folder):void{
        if(fd[folder])folderRemove(fd[folder]);
    }
    public function closeFolderByIndex(index:uint):void{
         folderRemove(index);
    }
    public function folderSelect(i:uint):void{

        cI=i;
        if(pI!=cI){
            fV[cI].active=true;
            if(pI<fV.length)fV[pI].active=false;
            pI=cI;
        }
        addChildAt(fV[cI],numChildren-1);
        dispatchEvent(new Event(FOLDER_SELECT));
    }
    override public function onStageResize(e:Event = null):void {
        bnd.width=stage.stageWidth;
        bnd.height=stage.stageHeight;
    }
    override protected function onWorkspaceChange(e:Event):void {
        removeChildAt(0);
        addChild(wcv[Core.currentWorkspaceIndex]);
    }
    override protected function onWorkspaceAdd(e:Event):void {
        wcv.push(new Sprite());
    }
    public function get currentIndex():uint{return cI}
    public function get currentFolder():Folder{return folder[cI]}
    public function get folder():Vector.<Folder>{return fV}

}
}