/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.mail {
public class MailOptions {
    private var ho:String;
    private var po:String;
    private var un:String;
    private var pw:String;
    private var fr:String;
    public function MailOptions(host:String,port:String,username:String,password:String,from:String):void{
        ho=host;
        po=port;
        un=username;
        pw=password;
        fr=from+" <"+un+">";
    }
    public function get host():String{return ho}
    public function get port():String{return po}
    public function get username():String{return un}
    public function get password():String{return pw}
    public function get from():String{return fr}
}
}