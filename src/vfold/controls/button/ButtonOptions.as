/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.button {
import flash.display.BitmapData;

public class ButtonOptions {
    // Title
    private var tt:String;
    // Icon
    private var ic:BitmapData;
    // Description
    private var ds:String;
    // Button Vector
    private var bv:Vector.<ButtonOptions>=new Vector.<ButtonOptions>;

    public function ButtonOptions(title:String="untitled",icon:BitmapData=null,description:String=null) {
        tt=title;ic=icon;ds=description;
    }
    public function get title():String {return tt}
    public function set title(value:String):void {tt=value}
    public function get icon():BitmapData {return ic}
    public function set icon(value:BitmapData):void {ic=value}
    public function get description():String {return ds}
    public function set description(value:String):void {ds=value}
    public function get buttonVector():Vector.<ButtonOptions>{return bv}
}
}