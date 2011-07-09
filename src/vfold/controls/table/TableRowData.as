/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.table {

public class TableRowData {

    // Static ID
    private static var sId:uint = 0;
    // ID
    public var _id:uint=sId++;
    // Data
    public var data:*;
    // Begin Select Index
    public var beginInd:uint;
    // End Select Index
    public var endInd:uint;
    // Field Index
    public var fieldInd:uint;

    // Sub-Rows
    private var sr:Vector.<TableRowData>=new Vector.<TableRowData>();
    // Field Vector
    private var fv:Vector.<String>;
    // Icon Bitmap Data Index
    private var ic:int;
    // Is Row Expanded
    private var ex:Boolean=false;

    public function TableRowData(fields:Vector.<String>=null,bitmapDataIndex:int=-1):void{
        ic=bitmapDataIndex;
        if(fields)fv=fields;
        else fv=new Vector.<String>();
    }

    public function get id():uint{return _id}
    public function get subRows():Vector.<TableRowData>{return sr}
    public function get fields():Vector.<String>{return fv}

    public function get bitmapDataIndex():uint{return ic}
    public function set bitmapDataIndex(value:uint):void{ic=value}

    public function get expanded():Boolean {return ex}
    public function set expanded(value:Boolean):void {ex=value}
}
}
