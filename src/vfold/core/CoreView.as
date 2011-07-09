/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core{
import flash.display.Sprite;
import flash.events.Event;
public class CoreView extends Sprite{

    public function CoreView():void{
        addEventListener(Event.ADDED_TO_STAGE,addedToStage);
    }
    private function addedToStage(e:Event):void {
        onStageAdded();
        onStageResize();
        removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
        stage.addEventListener(Event.RESIZE,onStageResize);
        addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
    }
    private function removedFromStage(e:Event):void {
        onStageRemoved();
        removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
        stage.removeEventListener(Event.RESIZE,onStageResize);
        addEventListener(Event.ADDED_TO_STAGE,addedToStage);
    }
    protected function onStageAdded():void{}
    protected function onStageRemoved():void{}
    public function onStageResize(e:Event = null):void {}
}
}