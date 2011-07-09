/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.application{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import vfold.core.Core;
import vfold.core.folder.Folder;
public class Application extends Sprite{

    // Folder
    private var FL:Folder;
    // Application Width
    private var AW:Number;
    // Application Height
    private var AH:Number;
    // Default View
    private var DV:ApplicationView;
    // Current View
    private var CV:ApplicationView;
    // Round Rectangle Radius
    private const RD:Number=10;
    // Application Layouts;
    private var lv:Vector.<ApplicationLayout>=new Vector.<ApplicationLayout>();
    // Color
    protected var _color:uint=Core.color;
    // Resize Event
    private var re:Event=new Event(Event.RESIZE);
    // Y Offset
    public static const GAP:uint=7;

    public function Application(title:String,layout:ApplicationLayout):void{
        addLayout(layout);
        DV=new ApplicationView(layout);
        DV.title=title;
        CV=DV;
        addChild(layout);
        changeView(DV);
        addEventListener(Event.RESIZE,onApplicationResize);
    }
    public function changeView(view:ApplicationView):void{
        removeChild(currentLayout);
        CV=view;
        addChild(currentLayout);
        currentLayout.changeData(CV.data,CV.color);
    }
    override public function addChild(child:DisplayObject):DisplayObject {

        return super.addChild(child);
    }
    protected function addLayout(layout:ApplicationLayout):void{
        layout.index=lv.length;
        lv.push(layout);
    }
    public function onFolderResize(e:Event=null):void{
        AW=folder.appWidth;
        AH=folder.appHeight;
        currentLayout.onFolderResize(folder.appWidth,folder.appHeight);
        dispatchEvent(re);
    }
    private function onApplicationResize(e:Event=null):void{
        currentLayout.adjustSections();
    }
    public function get currentView():ApplicationView{return CV}
    public function get currentLayout():ApplicationLayout{return lv[CV.layoutIndex]}
    public function get radius():uint{return RD}
    public function get title():String{return DV.title}
    public function get folder():Folder{return FL}
    public function set folder(value:Folder){if(!FL)FL=value}
    public function get color():uint{return _color}

    override public function get width():Number{return AW}
    override public function get height():Number {return super.height+GAP}

    public function changeToDefaultView():void{changeView(DV)}
    private function adjustSections():void{}
}
}
