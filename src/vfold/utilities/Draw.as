/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.utilities {
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;

import vfold.controls.button.ButtonStyle;

public class Draw {

    public static function arrowLeft(g:Graphics,w:Number,h:Number,c:uint=0xFFFFFF):void {

        g.clear();
        g.beginFill(c,.9);
        g.moveTo(w,0);
        g.lineTo(0,h/2);
        g.lineTo(w,h);
        g.endFill();
    }
    public static function arrowRight(x:Number,y:Number,width:Number,height:Number):GraphicsPath{var w:Number=x+width,h:Number=y+height;return new GraphicsPath(new <int>[1,2,2],new <Number>[x,y,w,h/2,x,h])}
    public static function roundRect(x:Number,y:Number,width:Number,height:Number,radius:Number,g:Graphics,style:ButtonStyle):void{
        var w:Number=x+width,h:Number=y+height;
        g.beginFill(style.fillColor,style.fillAlpha);
        g.drawRoundRect(x,y,w,h,radius);
        g.endFill();
        if(style.strokeThickness!=0){
        g.lineStyle(style.strokeThickness,style.strokeColor,style.strokeAlpha);
        g.drawRoundRect(x+style.strokeThickness/2,y+style.strokeThickness/2,w-style.strokeThickness,h-style.strokeThickness,radius);
        }
    }
    public static function close(g:Graphics,s:Number,c:uint=0xFFFFFF):void{

        g.lineStyle(1.8,c,.8,true,"normal",CapsStyle.NONE);
        g.moveTo(0,0);
        g.lineTo(s,s);
        g.moveTo(s,0);
        g.lineTo(0,s);
    }
    public static function minimize(g:Graphics,s:Number):void{

        g.lineStyle(2,0xFFFFFF,.8,true,"normal",CapsStyle.NONE);
        g.moveTo(0,1);
        g.lineTo(s,1);
    }
    public static function maximize(g:Graphics, s:Number):void {

        g.lineStyle(1.8,0xFFFFFF,.8,true,"normal",CapsStyle.NONE);
        g.drawRoundRect(0,0,s,s,6);
    }
    public static function circle(g:Graphics, s:Number,c:uint,a:Number):void {

        g.beginFill(c,a);
        g.drawCircle(s/2,s/2,s/2);
        g.endFill();
    }
    public static function resize(g:Graphics,s:Number,gp:Number,c:uint=0xFFFFFF):void {

        g.beginFill(c,1);
        g.moveTo(0,0);
        g.lineTo(s-gp,0);
        g.lineTo(0,s-gp);
        g.endFill();

        g.beginFill(c,1);
        g.moveTo(gp,s);
        g.lineTo(s,gp);
        g.lineTo(s,s);
        g.endFill();
    }
    public static function arrowUp(g:Graphics,w:Number,h:Number,c:uint=0xFFFFFF):void {

        g.clear();
        g.beginFill(c,.9);
        g.moveTo(w/2,0);
        g.lineTo(w,h);
        g.lineTo(0,h);
        g.endFill();
    }
    public static function arrowDown(g:Graphics,w:Number,h:Number,c:uint=0xFFFFFF):void {

        g.clear();
        g.beginFill(c,.9);
        g.moveTo(0,0);
        g.lineTo(w,0);
        g.lineTo(w/2,h);
        g.endFill();
    }
    public static function plus(g:Graphics,s:Number):void{

        g.lineStyle(1.8,0xFFFFFF,.8,true,"normal",CapsStyle.NONE);
        g.moveTo(0,s/2);
        g.lineTo(s,s/2);
        g.moveTo(s/2,s);
        g.lineTo(s/2,0);
    }
}
}