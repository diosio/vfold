/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget.search {
import flash.display.Sprite;
import vfold.display.content.ContentScroll;

public class SearchContent extends Sprite {

    // Button Scroll List
    private var bL:ContentScroll;
    // Search Bar
    private var sB:SearchBar;
    // Width
    private var w:Number;
    // Height
    private var h:Number;

    public function SearchContent(buttonScrollList:ContentScroll,searchBar:SearchBar) {

        sB=searchBar;
        bL=buttonScrollList;

        bL.y=sB.height;
        addChild(bL);
        addChild(sB);
    }


    override public function get height():Number {
        return h;
    }
    override public function get width():Number {

        return w;
    }
    override public function set width(value:Number):void {

        w=value;
        bL.width=sB.width=w;
    }
    override public function set height(value:Number):void {

        h=value;
        bL.height=h-sB.height;
    }
}
}
