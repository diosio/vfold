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
import vfold.core.Core;
import vfold.core.workspace.WorkspaceComponentHandler;
import flash.events.Event;
import vfold.core.application.Application;

public class FolderHandler extends WorkspaceComponentHandler {

    public static const FOLDER_ADD:String="FolderAdd";
    public static const FOLDER_CLOSE:String="FolderClose";
    public static const FOLDER_SELECT:String = "FolderSelect";

    // folder Vector
    public var fV:Vector.<Folder>=new Vector.<Folder>;
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
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
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
        fV.push(new Folder(instance as Application,fV.length));
        pI=cI;
        cI=fV.length-1;
        wcv[Core.currentWorkspaceIndex].addChild(fV[cI]);
        dispatchEvent(new Event(FOLDER_ADD));
    }
    public function folderRemove(vI:uint):void{

        removeChild(fV[vI]);
        fV[vI]=null;
        fV.splice(vI,1);
        for (var i:uint=vI;i<fV.length;i++){

            fV[i].folderIndex=i;
        }
    }
    public function folderClose(vI:uint):void{

        cI=vI;
        folderRemove(cI);
        dispatchEvent(new Event(FOLDER_CLOSE));
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
    private function onMouseDown(e:MouseEvent):void {
        if(e.target is FolderBackground){
            var f:Folder=e.target.parent as Folder;
            folderSelect(f.folderIndex);
            xO = mouseX - currentFolder.x;
            yO = mouseY - currentFolder.y;
            currentFolder.startDrag();
            stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        }
    }
    private function onMouseMove(e:MouseEvent):void {
        var f:Folder=currentFolder;
        f.x=mouseX-xO;
        f.y=mouseY-yO;
        if(f.y<0)f.y = 0;
        else if(f.y>stage.stageHeight-yO)f.y=stage.stageHeight-yO;
        if(f.x<-xO)f.x=-xO;
        else if(f.x>stage.stageWidth-xO)f.x=stage.stageWidth-xO;
    }
    private function onMouseUp(e:MouseEvent):void {
        currentFolder.stopDrag();
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
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