/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.button {
import flash.display.Sprite;
import flash.events.MouseEvent;
public class Button extends Sprite{

    // Selected Boolean
    private var slB:Boolean=false;
    // Selectable Boolean
    private var sbB:Boolean=true;
    // Button Index
    private var ind:uint=0;

    public function Button(selected:Boolean=false){
       slB=selected;
    }

    public function onMouseOver(e:MouseEvent=null):void{if(sbB)onOver();if(e)e.stopImmediatePropagation()}
    public function onMouseDown(e:MouseEvent=null):void{if(sbB)onDown();if(e)e.stopImmediatePropagation()}
    public function onMouseUp(e:MouseEvent=null):void{if(sbB)onUp();if(e)e.stopImmediatePropagation()}
    public function onMouseOut(e:MouseEvent=null):void{if(sbB)onOut();if(e)e.stopImmediatePropagation()}

    protected function onOver():void{}
    protected function onDown():void{}
    protected function onUp():void{}
    protected function onOut():void{}

    public function select():void{selectAction();slB=true;}
    public function deselect():void{deselectAction();slB=false;}

    protected function selectAction():void{}
    protected function deselectAction():void{}

    public function get selected():Boolean{return slB}

    public function set index(value:uint):void{ind=value}
    public function get index():uint{return ind}
    public function set selectable(value:Boolean):void{sbB=value}
    public function get selectable():Boolean{return sbB}
}
}