/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.button {

public class ButtonStyle {

    private var fc:uint;
    private var fa:Number;
    private var lt:uint;
    private var lc:uint;
    private var la:Number;
    private var tc:uint;
    private var tb:Boolean=false;

    public function ButtonStyle(fillColor:uint=0,fillAlpha:Number=1,strokeThickness:uint=1,strokeColor:uint=0xFFFFFF,strokeAlpha:Number=1,textColor:uint=0xFFFFFF):void {
        fc=fillColor;
        fa=fillAlpha;
        lt=strokeThickness;
        lc=strokeColor;
        la=strokeAlpha;
        tc=textColor
    }
    public function get strokeThickness():uint {return lt;}
    public function set strokeThickness(value:uint):void {lt=value;}
    public function get fillAlpha():Number {return fa;}
    public function set fillAlpha(value:Number):void {fa=value;}
    public function get strokeColor():uint {return lc;}
    public function set strokeColor(value:uint):void {lc=value;}
    public function get fillColor():uint {return fc;}
    public function set fillColor(value:uint):void {fc=value;}
    public function get strokeAlpha():Number {return la;}
    public function set strokeAlpha(value:Number):void {la=value;}
    public function get textColor():uint {return tc;}
    public function set textColor(value:uint):void {tc=value;}
    public function get textBold():Boolean {return tb;}
    public function set textBold(value:Boolean):void {tb=value;}

}
}
