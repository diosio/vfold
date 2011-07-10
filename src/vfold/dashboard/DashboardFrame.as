/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.dashboard{

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import vfold.core.Core;
import vfold.core.CoreView;
import vfold.utilities.ColorModifier;

public class DashboardFrame extends CoreView {

    // Content
    private var cnt:Sprite=new Sprite;
    // Color
    private var clr:uint;
    // Border
    private var brd:uint;
    // Frame Shape
    private var frm:Shape=new Shape;

    // Width
    private var w:Number=0;
    // Height
    private var h:Number=0;
    // ContentWidth
    private var cw:Number;
    // ContentHeight
    private var ch:Number;

    public function DashboardFrame(content:Sprite,border:uint=8):void {

        cnt=content;
        clr=Core.color;
        brd=border;
        cnt.x=cnt.y=brd;
        addChild(cnt);
        addChild(frm);
    }
    private function drawFrame(g:Graphics):void{

        g.clear();
        g.lineStyle(2,ColorModifier.brightness(clr,.7));
        g.drawRoundRect(0,0,w,h,brd);
    }
    override public function set width(value:Number):void {w=value;cw=w-brd*2;drawFrame(frm.graphics)}
    override public function set height(value:Number):void {h=value;ch=h-brd*2;drawFrame(frm.graphics)}

    public function set contentWidth(value:Number):void{cw=value;w=cw+brd*2;drawFrame(frm.graphics)}
    public function set contentHeight(value:Number):void{ch=value;h=ch+brd*2;drawFrame(frm.graphics)}
}
}
