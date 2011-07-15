/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.folder {

public class FolderView {
    public var title:String="untitled";
    public var data:*;
    public var layoutIndex:uint;
    public function FolderView(){
    }
    public function set layout(value:FolderLayout):void{
        layoutIndex=value.index;
    }
}
}
