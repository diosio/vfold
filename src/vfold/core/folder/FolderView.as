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
    public function FolderView(folder:Folder) {
        FL=folder;
        folder.addEventListener(Folder.ADJUSTING_END,onFolderAdjust);
    }
    public function onFolderAdjust(e:Event = null):void {
    }
    protected function get folder():Folder{return FL}

}
}