/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;
import vfold.controls.menu.Menu;
import vfold.core.Core;
import vfold.core.workspace.WorkspaceComponentHandler;

public class PanelHandler extends WorkspaceComponentHandler {

    // Background
    private var bg:PanelBackground;
    // Menu Launcher
    private var amn:PanelMenuLauncher;
    // Menu
    private var mn:Menu;
    // Menu Gap
    private var mg:uint=7;
    // Tool Bar
    private var tb:PanelToolBar;
    // Folder Bar
    private var fb:DisplayObject;

    // Content Height
    private const ch:uint=50;
    // Content Gap
    private const cg:uint=3;
    // Loading Bar Height
    private const lbh:uint=3;
    // Toolbar Height
    private const th:uint=ch+lbh;

    override protected function onStageAdded():void {
        mn=new Menu(Core.color,mg);
        bg=new PanelBackground;
        amn=new PanelMenuLauncher;
        tb=new PanelToolBar;
        fb =Core.folderHandler.folderBar;

        mn.x=mg;
        mn.y=th+mg;
        addChild(bg);
        addChild(amn);
        addChild(fb);
        addChild(tb);
        addChild(mn);
        mouseEnabled=false;
    }
    public function addTool(tool:PanelTool):void{tb.addTool(tool)}
    override protected function onWorkspaceChange(e:Event):void {
        // Default Logo
        var d:Bitmap=Core.defaultWorkspace.panel.logo;
        // Current Logo
        var c:Bitmap=Core.currentWorkspace.panel.logo;

        mn.addButtons(Core.currentWorkspace.panel.menu);
        amn.changeLogo(c?c:d);
        tb.x=fb.x=amn.width;
        tb.onStageResize();
    }
    override public function onStageResize(e:Event = null):void {

        bg.draw();
    }
    public function get heightLine():uint{return lbh}
    public function get menu():Menu{return mn}
    public function get contentGap():uint{return cg}
    public function get contentHeight():uint{return ch}
    public function get toolbar():DisplayObject{return tb}
    override public function get height():Number {return th}

}
}

import com.greensock.TweenMax;

import flash.display.Bitmap;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import vfold.controls.button.ButtonDropBox;
import vfold.core.Core;
import vfold.core.CoreView;
import vfold.core.panel.PanelTool;
import vfold.core.workspace.WorkspaceSwitcher;
import vfold.display.assets.Images;
import vfold.utility.ColorUtility;

class PanelBackground extends CoreView{
    // Background
    private var bg:Shape=new Shape;
    // Loader Line TODO: Make a Sync/ASync PreLoader
    private var ln:Shape=new Shape;
    // Shadow
    private var sh:Shape=new Shape;

    private const gt:String=GradientType.LINEAR;
    private var m:Matrix=new Matrix;

    public function PanelBackground():void{
        bg.alpha=.8;
        addChild(bg);
        addChild(ln);
        addChild(sh);
        mouseEnabled=mouseChildren=false;
        ln.y=Core.panelHandler.contentHeight;
        sh.y=Core.panelHandler.height;
    }
    public function draw():void{
        drawBackground(bg.graphics);
        drawLine(ln.graphics);
        drawShadow(sh.graphics);
    }
    private function drawBackground(g:Graphics):void{
        g.clear();
        m.createGradientBox(stage.stageWidth,Core.panelHandler.contentHeight,Math.PI/2);
        g.beginGradientFill(gt,[ColorUtility.brightness(Core.color,.3),Core.color],[1,1],[0,255],m);
        g.drawRect(0,0,stage.stageWidth,Core.panelHandler.contentHeight);
        g.endFill();
    }
    private function drawLine(g:Graphics):void{
        g.clear();
        g.beginFill(ColorUtility.brightness(Core.color,.7),1);
        g.drawRect(0,0,stage.stageWidth,Core.panelHandler.heightLine);
        g.endFill();
    }
    private function drawShadow(g:Graphics):void{
        g.clear();
        m.createGradientBox(stage.stageWidth,20,Math.PI/2); g.beginGradientFill(gt,[0,0],[.7,0],[0,255],m);
        g.drawRect(0,0,stage.stageWidth,20);
        g.endFill();
    }
}
class PanelMenuLauncher extends CoreView {

    // Clicked Boolean
    private var cB:Boolean = false;
    // Tween Max
    private var TM:TweenMax;
    // Logo Bitmap
    private var bL:Bitmap=new Images.VFoldMenu;
    // Height
    private var h:Number;

    public function PanelMenuLauncher():void {
        var c:Object=ColorUtility.hexToRGB(Core.color);
        TweenMax.to(bL,0,{colorTransform:{redOffset:c.red,greenOffset:c.green,blueOffset:c.blue}});
        addChild(bL);
        h=Core.panelHandler.contentHeight;
        x=5;
        alpha=.8;

        addEventListener(MouseEvent.MOUSE_OVER,onBtnOver);
        addEventListener(MouseEvent.MOUSE_OUT,onBtnOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);

        TweenMax.to(this,0,{glowFilter:{color:0xFFFFFF, blurX:30, blurY:7,alpha:1,strength:1.3}});
        TM=TweenMax.to(this,.15,{paused:true,glowFilter:{blurX:7, blurY:7,alpha:1}});
    }
    public function changeLogo(logo:Bitmap):void{
        if(logo)bL.bitmapData=logo.bitmapData;
        y=(height-bL.height)/2;
    }
    private function onMouseDown(e:MouseEvent = null):void {
        if(cB){
            cB=false;
            Core.panelHandler.menu.fadeOut();
            onBtnOut();
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
        }
        else {
            onBtnOver();
            Core.panelHandler.menu.fadeIn();
            cB=true;
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageDown);
            removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
        }
    }
    private function onStageDown(e:Event):void{if(e.target!=this){onMouseDown()}}
    private function onBtnOver(e:MouseEvent=null):void{if(!cB)TM.play()}
    private function onBtnOut(e:MouseEvent=null):void{if(!cB)TM.reverse()}

    override public function get width():Number {return x*2+super.width}
    override public function get height():Number {return h}

}
class PanelToolBar extends CoreView {

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

    // Workspace Switcher Tool
    private var ws:WorkspaceSwitcher;

    public function PanelToolBar() {

        y=Core.panelHandler.contentGap;
        h=(Core.panelHandler.contentHeight-Core.panelHandler.contentGap)/2-Core.panelHandler.contentGap;
        addEventListener(PanelTool.TOOL_CHANGE,onToolChange);
    }
    override protected function onStageAdded():void {

        ws=new WorkspaceSwitcher();
        addTool(ws);
        addChild(lc);
        addChild(rc);
    }
    private function onToolChange(e:Event):void{
        var t:PanelTool=PanelTool(e.target);
        var i:uint;
        switch(t.align){
            case PanelTool.ALIGN_LEFT:
                for(i=0;i<lc.numChildren;i++){
                    if(i!=0)lc.getChildAt(i).x=lc.getChildAt(i-1).x+lc.getChildAt(i-1).width+g;
                    else lc.getChildAt(i).x=g;
                }
                break;
            case PanelTool.ALIGN_RIGHT:
                for(i=0;i<rc.numChildren;i++){
                    if(i!=0)rc.getChildAt(i).x=-rc.getChildAt(i-1).x-rc.getChildAt(i-1).width-g;
                    else rc.getChildAt(i).x=-rc.getChildAt(i).width;
                }
                break;
        }
    }
    public function addTool(tool:PanelTool):void{
        var i:uint;
        switch(tool.align){

            case PanelTool.ALIGN_LEFT:
                i=lc.numChildren;
                lc.addChild(tool);
                if(i!=0)tool.x=lc.getChildAt(i-1).x+lc.getChildAt(i-1).width+g;
                else tool.x=g;
                break;
            case PanelTool.ALIGN_RIGHT:
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
}