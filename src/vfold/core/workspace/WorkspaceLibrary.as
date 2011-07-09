/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.workspace {
public class WorkspaceLibrary {

    // Runtime Shared Library (SWF) URL
    private var ur:String;
    // Library Title
    private var tl:String="untitled";
    // Description
    private var ds:String="untitled";
    // Library Dependencies
    private var dv:Vector.<WorkspaceLibrary>=new Vector.<WorkspaceLibrary>;

    public function WorkspaceLibrary() {}

    public function get url():String{return ur}
    public function set url(value:String):void {ur=value}

    public function get title():String{return tl}
    public function set title(value:String):void{tl=value}

    public function get description():String{return ds}
    public function set description(value:String):void{ds=value}

    public function get dependencies():Vector.<WorkspaceLibrary>{return dv}
}
}
