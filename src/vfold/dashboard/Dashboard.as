/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.dashboard{

import flash.display.Sprite;
import flash.events.Event;
import vfold.core.Core;
import vfold.core.CoreView;

public class Dashboard extends CoreView {

    // Wallpaper
    private var w:DashboardWallpaper=new DashboardWallpaper();
    // Header
    private var h:DashboardHeader=new DashboardHeader();
    // Body
    private var b:DashboardBody=new DashboardBody();
    // Footer
    private var f:DashboardFooter=new DashboardFooter();

    // Container
    private var c:Sprite=new Sprite();
    // Container Width
    private var cw:Number;
    // Container Height
    private var ch:Number;

    // Gap
    private const gp:uint=10;
    // Header Height (percentage)
    private const hh:Number=.25;

    public function Dashboard() {
        c.x=gp;
        c.y=Core.panelHandler.height+gp;

        addChild(w);
        addChild(c);
        c.addChild(h);
        c.addChild(b);
        c.addChild(f);
    }
    override public function onStageResize(e:Event = null):void {

        cw=stage.stageWidth-gp*2;
        ch=stage.stageHeight-Core.panelHandler.height-gp*2;

        var th:Number=ch-f.height-gp*2;
        h.height=hh*th;
        b.height=th-h.height;

        b.y=h.height+gp;
        f.y=ch-f.height;
    }
    protected function get wallpaper():DashboardWallpaper{return w}
    public function get header():DashboardHeader{return h}
    public function get body():DashboardBody{return b}
    public function get footer():DashboardFooter{return f}

    public function get dashboardWidth():Number{return cw}
    public function get dashboardHeight():Number{return ch}
}
}
