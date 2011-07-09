/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.display.preloader {
import com.greensock.TweenLite;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Timer;

public class Preloader extends Sprite {

    private var degreesPerSegment:Number;
    private var center:Point=new Point(0,0);
    //store a reference to the correct graphics object (inside circleHolder sprite)
    private var g:Graphics = graphics;
    private var rotateTimer:Timer=new Timer(40);
    private var t:TextField=new TextField;
    private var f:TextFormat=new TextFormat;

    //move the line to the correct starting point:
    private var startPos:Point = new Point();

    public function Preloader(innerRadius:int,outerRadius:int,nrOfSegments:int,c:uint=0):void{
        alpha=0;
        rotateTimer.addEventListener(TimerEvent.TIMER, rotateCircle);
        startPos.x = center.x + innerRadius * Math.cos( deg2rad(360) );
        startPos.y = center.y + innerRadius * Math.sin( deg2rad(360) );
        g.moveTo(startPos.x, startPos.y);

        //draw the segmented circle inside circleHolder:
        degreesPerSegment = 360 / nrOfSegments;

        f.size=12;
        t.defaultTextFormat=f;
        t.width=0;
        t.height=0;
        t.selectable=false;

        addChild(t);

        for (var deg:Number=360; deg >= 0; deg -= degreesPerSegment){
            var innerPos:Point = new Point();
            innerPos.x = center.x + innerRadius * Math.cos( deg2rad(deg) );
            innerPos.y = center.y + innerRadius * Math.sin( deg2rad(deg) );

            var outerPos:Point = new Point();
            outerPos.x = center.x + outerRadius * Math.cos( deg2rad(deg) );
            outerPos.y = center.y + outerRadius * Math.sin( deg2rad(deg) );

            g.lineStyle(1, c, (deg/360));
            g.moveTo(innerPos.x, innerPos.y);
            g.lineTo(outerPos.x, outerPos.y);

            //timer for rotating the sprite with the segmented circle:

        }
    }
    public function start(e:Event = null):void{
        TweenLite.to(this,.5,{alpha:1});
        rotateTimer.start();
    }
    public function load(p:Number):void{
        t.text = p.toString();
        t.autoSize=TextFieldAutoSize.LEFT;
        t.x=-t.width/2;
        t.y=-t.height/2;
    }
    public function stop(e:Event = null):void{
        TweenLite.to(this,1,{alpha:0,onComplete:onComplete});
    }
    private function onComplete():void{
        rotateTimer.stop();
    }
    //function for converting degrees to radians:
    private function deg2rad(deg:Number):Number{
        return deg * (Math.PI / 180);
    }
    private function rotateCircle(evt:TimerEvent):void{
        rotation += degreesPerSegment;
    }
}
}