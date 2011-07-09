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
    // Folder Bar
    private var fb:PanelFolderBar;
    // Tool Bar
    private var tb:PanelToolBar;

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
        fb=new PanelFolderBar;
        tb=new PanelToolBar;

        mn.x=mg;
        mn.y=th+mg;
        addChild(bg);
        addChild(amn);
        addChild(fb);
        addChild(tb);
        addChild(mn);
        mouseEnabled=false;
    }
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

    public function get toolbar():PanelToolBar{return tb}
    public function get folderBar():PanelFolderBar{return fb}
    public function get menuLauncher():PanelMenuLauncher{return amn}
    public function get heightLine():uint{return lbh}
    public function get menu():Menu{return mn}
    public function get contentGap():uint{return cg}
    public function get contentHeight():uint{return ch}
    override public function get height():Number {return th}

}
}