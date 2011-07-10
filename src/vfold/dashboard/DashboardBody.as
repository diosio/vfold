/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.dashboard{
import flash.events.Event;

import vfold.core.CoreView;

public class DashboardBody extends CoreView {

    // Height
    private var h:Number;

    public function DashboardBody() {
    }
    override public function set width(value:Number):void {
    }

    override public function set height(value:Number):void {

        h=value;
        var i:uint=numChildren;
        while(i-->0)getChildAt(i).height=h;
    }
    override public function get height():Number{return h}
    override public function onStageResize(e:Event = null):void {
    }
}
}
