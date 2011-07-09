/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.mail {
public class MailContactGroup{
    private var cv:Vector.<String>=new <String>[];
    public function MailContactGroup() {
    }
    public function addContact(fullname:String,email:String):void{
        cv.push(fullname+" "+"<"+email+">,");
    }
    public function get contactVector():Vector.<String>{return cv}
    public function get group():String{
        var t:String="";
        for each(var s:String in cv){
            t+=s;
        }
        return t;
    }
}
}
