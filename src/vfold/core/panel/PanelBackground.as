/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.panel {
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.geom.Matrix;

import vfold.core.Core;
import vfold.core.CoreView;
import vfold.utilities.ColorModifier;

public class PanelBackground extends CoreView{
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
        g.beginGradientFill(gt,[ColorModifier.brightness(Core.color,.3),Core.color],[1,1],[0,255],m);
        g.drawRect(0,0,stage.stageWidth,Core.panelHandler.contentHeight);
        g.endFill();
    }
    private function drawLine(g:Graphics):void{
        g.clear();
        g.beginFill(ColorModifier.brightness(Core.color,.7),1);
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
}