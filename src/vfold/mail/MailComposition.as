/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.mail {
import vfold.utility.StringUtility;

public class MailComposition {
    // Send To
    private var st:String;
    // Send To Group
    private var sg:MailContactGroup;
    // Send To IS Single
    private var sb:Boolean=true;
    // Subject
    private var sbj:String;
    // Message RAW
    private var mgr:String;
    // Message Final
    private var mgf:String;

    public function MailComposition(subject:String,message:String) {
        sbj=subject;
        mgr=mgf=message;
    }
    public function sendToSingle(fullname:String,email:String):void{
        sb=true;
        st=fullname+" "+"<"+email+">";
    }
    public function sendToGroup(contactGroup:MailContactGroup):void{
        sb=false;
        sg=contactGroup;
    }
    public function get to():String{
        if(sb) return st;
        return sg.group;
    }
    public function set tokens(value:Object):void{mgf=StringUtility.replaceTokens(mgr,value)}
    public function get subject():String{return sbj}
    public function get message():String{return mgf}
}
}
