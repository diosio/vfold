/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.utilities {
public class StringFunction {

    public static function generate(length:int):String
    {
        var p:String="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var ret:String = "";
        var n:int = 0;
        var mn:int = p.length;
        while(ret.length<length)
        {
            n = Math.random()*mn;
            ret += p.charAt(n);
        }
        return ret;
    }
    public static function replaceTokens(text:String,tokens:Object):String{
        // String to return
        var str:String="";
        // start of token Index
        var si:int;
        // end of token Index
        var ei:int;
        // start String
        var ss:String="${";
        // end String
        var es:String="}";

        while((si=text.indexOf(ss,ei))!=-1){
            str+=text.substring(ei?ei+es.length:0,si);
            ei=text.indexOf(es,si);
            str+=tokens[text.substring(si+ss.length,ei)];
        }
        str+=text.substring(ei?ei+es.length:0);
        trace(str);
        return str;
    }
    public static function withinFirst(str:String,A:String,B:String):Vector.<String>{
        var bool:Boolean=true;
        var v:Vector.<String>=new Vector.<String>;
        var a:int;
        var b:int;
        a=str.indexOf(A);
        while(bool){
            b=str.indexOf(B,a+A.length);
            if(a!=-1&&b!=-1){
                v.push(str.substr(a+A.length,b-a-A.length));
            }
            else {
                bool=false;
            }
            a=str.indexOf(A,b+B.length);
        }
        return v;
    }
}
}