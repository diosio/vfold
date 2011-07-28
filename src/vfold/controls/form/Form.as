/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.form {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import vfold.core.Core;
import vfold.display.text.TextSimple;

public class Form extends Sprite{

    // Ok
    public static const OK:String="ok";
    // Warning
    public static const WARNING:String="warning";
    // Error
    public static const ERROR:String="error";
    // Unset
    public static const UNSET:String="unset";

    // Gap
    private var G:uint=8;
    // Title Column Container
    private var tcc:Sprite=new Sprite;
    // Text Input Column Container
    private var icc:Sprite=new Sprite;
    // Text Input Vector
    private var ev:Vector.<FormDynamic>=new Vector.<FormDynamic>;
    // Error Notification Text
    private var et:String;
    // Text Color
    private var tc:uint;
    // Fill Color
    private var fc:uint;
    // Current Active Field
    private var ca:FormDynamic;
    // Height Offset
    private var ho:Number=0;

    public function Form(titleColor:uint=0xFFFFFF,fillColor:uint = 0xFFFFFF):void{
        tc = titleColor;
        fc = fillColor;
        icc.addEventListener(Event.CHANGE,onChange);
        icc.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
        icc.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
        addChild(tcc);
        addChild(icc);
    }
    public function addEntry(entry:FormEntry):void{
        var i:uint=ev.length;
        var t:TextSimple=new TextSimple(13,tc);
        t.text=entry.title+": ";
        switch(entry.type){
            case FormEntry.INPUT:
                ev[i]=new FormInput();
                break;
            case FormEntry.DYNAMIC:
                ev[i]=new FormDynamic();
                break;
            case FormEntry.TABLE:
                ev[i]=new FormTable(entry.tableData);
                break;
            case FormEntry.CALENDAR:
                break;
            case FormEntry.BROWSE:
                ev[i]=new Browse();
                break;
        }
        ev[i].fillColor=fc;
        ev[i].y=t.y=ho;
        ev[i].changeFunction=entry.actionFunction;
        ev[i].maxChars=entry.maxChars;
        ev[i].numLines=entry.numLines;
        ev[i].password=entry.password;
        ev[i].textField.text=entry.defaultText;
        ev[i].textColor=tc;
        tcc.addChild(t);
        icc.addChild(ev[i]);
        icc.x=tcc.width;
        ho+=t.height+G;
    }
    public function enable(index:uint):void{ev[index].enable=true}
    public function getTextField(index:uint):TextSimple{return ev[index].textField}
    public function disable(index:uint):void{ev[index].enable=false}
    public function enabled(index:uint):Boolean{return ev[index].enabled}
    public function setStatus(index:uint,value:String,message:String="undefined"):void{ev[index].setStatus(value,message)}
    public function getText(index:uint):String{return ev[index].textField.text}
    public function getStatus(index:uint):String{return ev[index].status}
    public function checkAll():void{for each(var i:FormInput in ev)i.onChange()}

    private function onChange(e:Event):void{
        if(e.target.parent is FormInput){
            var ti:FormInput=e.target.parent as FormInput;
            ti.onChange();
        }
    }
    private function onFocusIn(e:FocusEvent):void {
        if(ca)ca.active=false;
        if (e.target.parent is FormInput) {
            ca = e.target.parent as FormInput;
            ca.active = true;
        }

    }
    private function onKeyDown(e:KeyboardEvent):void{
        if(e.keyCode==13){
            if(inputValidity){
                onSubmitForm();
                for each(var t:FormInput in ev){
                    t.text="";
                    t.onChange();
                }
            }
            else{
                Core.notify("input error:"+et);
            }
        }
    }
    private function get inputValidity():Boolean{
        et="";
        for each(var t:FormInput in ev){
            if(t.status==ERROR)et+="\n"+t.statusMessage;
        }
        return et.length==0;
    }
    protected function onSubmitForm():void{}
}
}
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextFieldType;

import vfold.controls.button.ButtonDropBox;
import vfold.controls.button.ButtonStyle;
import vfold.controls.form.Form;
import vfold.controls.form.FormDynamic;
import vfold.controls.table.Table;
import vfold.controls.table.TableData;
import vfold.controls.table.TableRowData;
import vfold.core.Core;
import vfold.display.assets.Images;
import vfold.utility.ColorUtility;

class FormInput extends FormDynamic{
    public function FormInput(){
        textField.type=TextFieldType.INPUT;
        textField.selectable=true;
    }
}
class FormTable extends FormInput {

    // Switch List
    private var tb:Table;
    // Drop Box
    private var db:ButtonDropBox;
    // Max length List
    private const ml:int=6;
    // Data
    private var d:*;

    public function FormTable(data:TableData) {
        // Icon Bitmap
        var ic:Bitmap=new Images.ArrowDown as Bitmap;
        textField.width-=ic.width+3;
        ic.x=textField.width;
        ic.y=(textField.height-ic.height)/2;
        addChild(ic);
        tb=new Table(Core.color,data,onSelect);
        db=new ButtonDropBox();
        db.dispatcher=tb;
        db.style=new ButtonStyle(fillColor);
        db.onButtonAdjust(width,height);
        tb.onNoResult=onNoResult;
        tb.height=130;
    }
    private function onSelect(value:TableRowData):void{
        onNoResult();
        changeFunction.call(null,value);
    }
    private function onNoResult():void {
        if(contains(db))removeChild(db);
    }
    override public function onChange():void{
        if(text.length>0){
            if(!contains(db))addChildAt(db,1);
        }
        else if(contains(db))removeChild(db);

        tb.find(text);
        db.onContentResize();
    }
}
class Browse extends FormDynamic {
    // Graphics
    private var g:Graphics;
    // Bright Color
    private var bc:uint;

    public function Browse() {
        var ic:Bitmap=new Images.Browse as Bitmap;
        bc=ColorUtility.brightness(fillColor,.5);
        setStatus(Form.ERROR);
        g=background.graphics;
        addChild(ic);
        textField.width-=ic.width+3;
        ic.x=textField.width;
        ic.y=(textField.height-ic.height)/2;
        addEventListener(MouseEvent.CLICK,onClick);
    }
    private function onClick(e:MouseEvent):void{
        onChange();
    }
}
class Calendar extends FormInput{

}

