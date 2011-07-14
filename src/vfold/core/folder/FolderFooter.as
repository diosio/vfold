/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {
import flash.events.Event;

import vfold.core.folder.Folder;
import vfold.core.folder.FolderView;

public class FolderFooter extends FolderView{

    private var a:FooterFolderAdjust;

    public function FolderFooter(folder:Folder):void{
        super(folder);
        a=new FooterFolderAdjust(folder);
        addChild(a);
    }
    override public function onFolderAdjust(e:Event = null):void {
        y=folder.height-folder.footerHeight;
        a.x=folder.width-a.width-folder.borderThickness;
        a.y=folder.footerHeight-a.height-folder.borderThickness;
    }
}
}
import flash.display.Shape;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;

import vfold.controls.button.ButtonSymbol;
import vfold.core.Core;
import vfold.core.folder.Folder;
import vfold.core.folder.FolderView;
import vfold.utilities.ColorFunction;
import vfold.utilities.Draw;

class FooterFolderAdjust extends FolderView {

    private var b:ButtonSymbol=new ButtonSymbol();
    private var s:Shape=new Shape;

    private var lX:Number;
    private var lY:Number;

    private var oW:Number;
    private var oH:Number;

    public function FooterFolderAdjust(folder:Folder) {

        super(folder);

        Draw.resize(s.graphics,12,12/3);
        s.alpha=.7;
        b.addChild(s);
        b.onDownFunction=onMouseDown;
        b.addEventListener(MouseEvent.MOUSE_OVER,b.onMouseOver);
        b.addEventListener(MouseEvent.MOUSE_OUT,b.onMouseOut);
        b.addEventListener(MouseEvent.MOUSE_DOWN,b.onMouseDown);
        b.background.filters=[new BlurFilter(8,8)];
        b.color=ColorFunction.brightness(Core.color,.4);
        addChild(b);
    }

    private function onMouseDown():void{
        lX=mouseX;
        lY=mouseY;
        stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        folder.adjustingStart();
    }
    private function onMouseMove(e:MouseEvent):void {
        folder.adjusting(oW=mouseX-lX,oH=mouseY-lY);
    }
    private function onMouseUp(e:MouseEvent):void {
        folder.adjustingEnd(oW,oH);
        stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
    }
}