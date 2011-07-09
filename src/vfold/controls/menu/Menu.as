/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.menu {
import flash.events.MouseEvent;
import vfold.controls.button.Button;
public class Menu extends MenuButtons{

    // Target Event Button
    private var ebt:Button;
    // Target Event ParentContainer
    private var epc:MenuButtons;

    public function Menu(color:uint,gap:uint) {

        super(color,gap);
        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
    }
    private function onMouseOver(e:MouseEvent=null):void{

        if(e.target is Button){

            if(epc)if(epc!=e.target.parent.parent)epc.fadeOut();

            ebt=e.target as Button;
            epc=e.target.parent.buttonContainer as MenuButtons;

            ebt.onMouseOver();
            epc.fadeIn();
            epc.previousIndex=ebt.index;
        }
    }
    private function onMouseOut(e:MouseEvent):void {
        if(e.target is Button)ebt.onMouseOut();
    }
    private function onMouseDown(e:MouseEvent):void {
        if(e.target is Button)ebt.onMouseDown();
    }
}
}
