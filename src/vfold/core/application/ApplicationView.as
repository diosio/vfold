/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.application {
import vfold.core.Core;

public class ApplicationView {
    public var title:String="untitled";
    public var color:uint=Core.color;
    public var data:Vector.<Object>;
    public var layoutIndex:uint;
    public function ApplicationView(layout:ApplicationLayout){
        layoutIndex=layout.index;
        data=new Vector.<Object>(layout.sectionsLength,true);
    }
}
}
