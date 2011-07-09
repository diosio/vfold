/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.application {
import flash.display.Sprite;
import flash.events.Event;

public class ApplicationSectionView extends Sprite {
    protected const gap:uint=5;
    private var t:String="Untiled";
    public var view:ApplicationSectionView;
    public static const CHANGE_VIEW:String="changeView";
    public function ApplicationSectionView() {
    }
    public function set title(value:String):void{t=value}
    public function get title():String{return t}
    protected function changeView(sectionView:ApplicationSectionView):void{
        view=sectionView;
        dispatchEvent(new Event(CHANGE_VIEW,true))
    }
}
}
