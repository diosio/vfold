/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/


package vfold.controls.form {
import vfold.controls.table.TableData;
public class FormEntry {
    public static const INPUT:String="input";
    public static const DYNAMIC:String="dynamic";
    public static const TABLE:String="table";
    public static const CALENDAR:String="calendar";
    public static const BROWSE:String="browse";
    public var defaultText:String="";
    public var actionFunction:Function;
    public var maxChars:uint=0;
    public var password:Boolean=false;
    public var type:String=INPUT;
    public var title:String="untitled";
    public var numLines:uint=1;
    public var tableData:TableData;
    public function FormEntry() {
    }
}
}
