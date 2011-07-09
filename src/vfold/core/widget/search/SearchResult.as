/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget.search {
import vfold.controls.button.ButtonOptions;

public class SearchResult {

    private var t:String;
    private var r:Vector.<ButtonOptions>;

    public function SearchResult(title:String=null,results:Vector.<ButtonOptions>=null):void {
        t=title;
        r=results;
    }
    public function get status():String{return t}
    public function set status(value:String):void{t=value}
    public function get results():Vector.<ButtonOptions>{return r}
    public function set results(value:Vector.<ButtonOptions>):void{r=value}
}
}
