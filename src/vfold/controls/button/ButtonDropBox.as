/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.button {
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.text.engine.CFFHinting;

public class ButtonDropBox extends Sprite {
    // Adjust Offset
    public static const ADJUST_OFFSET:String="adjust";
    // Content
    private var cn:Sprite=new Sprite();
    // Radius
    private var rd:uint=5;
    // Sty;e
    private var bs:ButtonStyle;

    // Tool Width
    private var tw:Number=100;
    // Tool Height
    private var th:Number=20;
    // Content Gap
    private const cg:uint=7;

    // BOX X Position offset
    private var xo:Number=0;

    // Tag Shape
    private var bg:Shape=new Shape;

    // Width
    private var w:Number;
    // Height
    private var h:Number;
    // X Position
    private var xp:Number;
    // Max Width
    private var mxw:Number;

    // Graphic commands
    private var gc:Vector.<int>=new <int>[1,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2];
    // Left Radius
    private var lr:Number;
    // Right Radius
    private var rr:Number;
    // Dispatcher
    private var d:DisplayObject;
    // Close Function
    private var cf:Function;

    public function ButtonDropBox() {
        super.addChild(bg);
        super.addChild(cn);
        cn.addEventListener(Event.RESIZE,onContentResize);
        addEventListener(Event.ADDED_TO_STAGE,onStageAdded);
    }

    /**
     * Add Children to drop box content container
     * @param child
     * @return
     */
    override public function addChild(child:DisplayObject):DisplayObject {return cn.addChild(child)}
    /**
     * Decoration settings
     * @param value
     */
    public function set style(value:ButtonStyle):void{bs = value}
    /**
     * The Display Object that affects the way the drop boc is drawn
     * @param value
     */
    public function set dispatcher(value:DisplayObject):void{d = value}

    private function onStageAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE,onStageAdded);
        addEventListener(Event.REMOVED_FROM_STAGE,onStageRemoved);
        if(d){
            d.addEventListener(ButtonDropBox.ADJUST_OFFSET,onAdjustOffset);
            onAdjustOffset();
        }
    }
    private function onStageRemoved(e:Event):void {
        if(d)d.removeEventListener(ButtonDropBox.ADJUST_OFFSET,onAdjustOffset);
        removeEventListener(Event.REMOVED_FROM_STAGE,onStageRemoved);
        addEventListener(Event.ADDED_TO_STAGE,onStageAdded);
    }
    private function onAdjustOffset(e:Event=null):void{
        var thisP:Point=localToGlobal(new Point(x,y));
        thisP=d.globalToLocal(thisP);
        xp=thisP.x;
        mxw=d.width;
        onContentResize();
    }
    public function onButtonAdjust(toolWidth:Number,toolHeight:Number):void{
        tw=toolWidth;
        th=toolHeight+3;
        onContentResize();
    }
    public function onContentResize(e:Event=null):void{

        w=cn.width+cg*2;
        h=th+cn.height+cg*2;
        xo=mxw<(xp+w)?xp+w-mxw:0;
        cn.x=-xo+cg;
        cn.y=th+cg;
        drawBackground(bg.graphics);
    }
    private function drawBackground(g:Graphics):void{

        if(xo>0)lr=xo>rd*2?rd:xo/2;else lr=0;
        if(w>tw)rr=w-xo-tw>rd*2?rd:(w-xo-tw)/2;else {if(w<tw)rr=tw-w>rd*2?rd:(tw-w)/2;else rr=0;}

        g.clear();
        g.lineStyle(bs.strokeThickness,bs.strokeColor,1,true);
        g.beginFill(bs.fillColor,1);
        g.drawPath(gc,new <Number>[0,rd,0,0,rd,0,tw-rd,0,tw,0,tw,rd,tw,th-rr,tw,th,tw+(w>tw?rr:-rr),th,w-xo-(w>tw?rr:-rr),th,w-xo,th,w-xo,th+rr,w-xo,h-rd,w-xo,h,w-xo-rd,h,rd-xo,h,-xo,h,-xo,h-rd,-xo,th+lr,-xo,th,lr-xo,th,-lr,th,0,th,0,th-lr,0,rd]);
    }
    public function onOpen():void{}
    public function onClose():void{}
    public function get close():Function{return cf}
    public function set close(value:Function):void{cf=value}

}
}
