/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.folder {
import flash.events.Event;

import vfold.core.CoreView;

public class FolderView extends CoreView{

    private var FL:Folder;

    // Border Thickness
    private const bT:int = 5;
    // Header Height
    private const hh:int = 25;
    // Footer Height
    private const fh:int = 30;
    // Outer Radius
    private const or:int = 20;
    // Inner Radius
    private const ir:int = 10;

    public function FolderView(folder:Folder) {

        FL=folder;
        folder.addEventListener(Folder.ADJUSTING_END,onFolderAdjust);
    }
    public function onFolderAdjust(e:Event = null):void {
    }
    protected function get folder():Folder{return FL}
    protected function get borderThickness():int{return bT}
    protected function get headerHeight():int{return hh}
    protected function get footerHeight():int{return fh}
    protected function get outerRadius():int{return or}
    protected function get innerRadius():int{return ir}

}
}