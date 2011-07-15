/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.core.folder {
import flash.display.Sprite;
import flash.events.Event;

public class FolderSectionView extends Sprite {
    protected const gap:uint=5;
    private var t:String="Untiled";
    public var view:FolderSectionView;
    public static const CHANGE_VIEW:String="changeView";
    public function FolderSectionView() {
    }
    public function set title(value:String):void{t=value}
    public function get title():String{return t}
    protected function changeView(sectionView:FolderSectionView):void{
        view=sectionView;
        dispatchEvent(new Event(CHANGE_VIEW,true))
    }
}
}
