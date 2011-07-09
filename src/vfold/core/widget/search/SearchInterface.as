/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget.search {
import flash.display.Bitmap;

public interface SearchInterface {

    function get index ():uint;
    function search(text:String):void;
    function get icon ():Bitmap;
    function set onResult(value:Function):void
    function get title():String;
    function get detail():String;
    function set currentIndex(value:int):void
    function onResultSelect(resultIndex:uint):void
}
}
