/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.account {
import flash.events.Event;
import vfold.core.Core;
import vfold.core.panel.PanelTool;
import vfold.controls.button.ButtonLabel;

public class Account extends PanelTool {

    // Account Button
    private var acb:ButtonLabel=new ButtonLabel();
    // Join Button
    private var sib:ButtonLabel=new ButtonLabel();
    // Join Drop Box Content
    private var sic:Join=new Join();

    public function Account() {
        Core.dispatcher.addEventListener(Core.ACCOUNT_CHANGE,onAccountChange);
        sib.setDropBox(sic,toolbar);

        addChild(sib);

        sib.label="join";
    }
    private function onAccountChange(e:Event):void{
        if(Core.currentUser){
            if(!contains(acb)){
                addChild(acb);
                removeChild(sib);
            }
            acb.label=Core.currentUser.firstname+" "+Core.currentUser.lastname;
        }
        else{
            removeChild(acb);
            addChild(sib);
        }
        change();
    }
    private function onJoinExit():void{
        sib.onStageDown();
    }
}
}

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.net.registerClassAlias;

import vfold.controls.button.ButtonLabel;
import vfold.controls.button.ButtonStyle;

import vfold.controls.form.FormEntry;
import vfold.core.Core;
import vfold.core.account.AccountRole;
import vfold.core.account.AccountVO;
import vfold.controls.form.Form;
import vfold.display.text.TextSimple;
import vfold.mail.MailComposition;
import vfold.utility.ColorUtility;
import vfold.utility.StringUtility;

class Join extends Sprite{
    private var cb:ButtonLabel;
    private var si:SignIn=new SignIn();
    public function Join(){
        var bc:uint=ColorUtility.brightness(Core.color,.85);
        cb=new ButtonLabel(new ButtonStyle(ColorUtility.brightness(Core.color,.2),1,1,bc,1,bc));
        cb.label="Create an Account";
        addChild(cb);
        addChild(si);
        si.y = cb.height;
        cb.x = (si.width-cb.width)/2;
    }
}
class Separator extends Sprite{
    private var g:Graphics;
    private const tf:TextSimple = new TextSimple();
    private var w:Number;
    public function Separator(){
        var s:Shape = new Shape();
        g=s.graphics;
        addChild(s);
    }
    public function set label(value:String):void{
        tf.text =value;
    }
    private function draw():void{
        g.clear();
        g.lineStyle(1,1,1);
        g.moveTo(0,0);
        g.lineTo(tf.x,0);
        g.moveTo(tf.x+tf.width,0);
        g.lineTo(width,0);
    }
    override public function get width():Number {return w}
    override public function set width(value:Number):void {w = value}
}

class SignIn extends Form{
    private var ef:Function;
    private var ps:String;
    public function SignIn(exitFunction:Function=null):void{
        ef=exitFunction;
        var d:FormEntry=new FormEntry();
        d.title="Login Name";
        d.actionFunction=checkLoginName;
        d.maxChars=16;
        addEntry(d);
        d.title="Password";
        d.actionFunction=checkPassword;
        d.maxChars=24;
        d.password=true;
        addEntry(d);
        checkAll();
        registerClassAlias("VFOLD.VO.Account",AccountVO);
    }
    override protected function onSubmitForm():void {
        ps=entries[1].text;
        Core.amfCall("Account.getAccount",onGetAccount,entries[0].text);
        ef.call(null);
    }
    private function onGetAccount(a:AccountVO):void{
        if(a.role==AccountRole.NONE){
            Core.notify("Your account has not yet been confirmed\nCheck your e-mail")
        }
        else{
            Core.signInAccount(a,ps);
        }
    }
    private function checkLoginName():void{
        var s:String=entries[0].text.length>0?entries[0].text.length>5?"Invalid Login Name":"Login Name must be minimum 6 characters":"Enter your Login Name";
        entries[0].setStatus(Form.ERROR,s);
        if(entries[0].text.length>5){
            Core.amfCall("Account.checkLoginName",onCheckLoginName,entries[0].text);
        }
    }
    private function onCheckLoginName(b:Boolean):void{
        if(b)entries[0].setStatus(Form.OK);
    }
    private function checkPassword():void{
        var s:String=entries[1].text.length>0?entries[1].text.length>7?null:"Password must be 8 characters minimum in length":"Enter your password";
        entries[1].setStatus(s?Form.ERROR:Form.WARNING,s);
    }
}
class Register extends Form{
    // Mail Composition
    private var mc:MailComposition;
    // Mail Tokens
    private var mt:Object={};
    // Exit Join Form Function
    private var ef:Function;
    // Account Value Object
    private var acc:AccountVO=new AccountVO();
    public function Register(exitFunction:Function):void {
        ef=exitFunction;
        mt.domain=Core.projectDomain;
        mt.title=Core.projectTitle;
        Core.amfCall("HTML.getHTML",function(h:String):void{mc=new MailComposition("Testing",h);},"welcome");
        acc.role=AccountRole.NONE;
        addEntries();
        entries[4].enable=false;
    }
    private function addEntries():void{
        var d:FormEntry=new FormEntry();
        d.title="First Name";
        d.actionFunction=checkFirstName;
        d.maxChars=16;
        addEntry(d);
        d.title="Last Name";
        d.actionFunction=checkLastName;
        addEntry(d);
        d.title="Login Name";
        d.actionFunction=checkLoginName;
        addEntry(d);
        d.title="Choose a Password";
        d.actionFunction=checkPassword;
        d.maxChars=24;
        d.password=true;
        addEntry(d);
        d.title="Re-Enter Password";
        d.actionFunction=reCheckPassword;
        addEntry(d);
        d.title="E-Mail";
        d.actionFunction=checkEmail;
        d.maxChars=50;
        d.password=false;
        addEntry(d);
        checkAll();
    }
    override protected function onSubmitForm():void{
        acc.firstname=entries[0].text;
        acc.lastname=entries[1].text;
        acc.loginname=entries[2].text;
        acc.password=Core.encryptPassword(entries[4].text);
        acc.email=entries[5].text;
        acc.code=mt.code=StringUtility.generate(24);
        mt.firstname=entries[0].text;
        mc.sendToSingle(entries[0].text+" "+entries[1].text,entries[5].text);
        mc.tokens=mt;
        Core.sendMail(mc,null,onEmailSuccess);
        Core.notify("Sending confirmation letter...");
        ef.call(null);
    }
    private function onEmailSuccess():void{
        Core.notify("A confirmation letter has been sent to your e-mail address");
        Core.amfCall("Account.addAccount",null,acc);
    }
    private function checkFirstName():void{
        var s:String=entries[0].text.length>0?null:"Enter your First Name";
        entries[0].setStatus(s?Form.ERROR:Form.OK,s);
    }
    private function checkLastName():void{
        var s:String=entries[1].text.length>0?null:"Enter your Last Name";
        entries[1].setStatus(s?Form.ERROR:Form.OK,s);
    }
    private function checkLoginName():void{
        var s:String=entries[2].text.length>0?entries[2].text.length>5?null:"Enter a login name with 8 characters minimum in length":"Enter a Desired Login Name";
        entries[2].setStatus(s?Form.ERROR:Form.OK,s);
        if(!s){
            Core.amfCall("Account.checkLoginName",onCheckLoginName,entries[2].text);
        }
    }
    private function onCheckLoginName(b:Boolean):void{
        entries[2].setStatus(b?Form.ERROR:Form.OK,"Login Name already exists");
    }
    private function checkPassword():void{
        var s:String=entries[3].text.length>0?entries[3].text.length>7?null:"Enter a password with 8 characters minimum in length":"Enter a password";
        entries[3].setStatus(s?Form.ERROR:Form.OK,s);
        if(!s&&!entries[4].enabled)entries[4].enable=true;
        else if(s&&entries[4].enabled)entries[4].enable=false;
    }
    private function reCheckPassword():void{
        var s:String=entries[4].text.length>0?entries[3].text==entries[4].text?null:"Passwords do not match":"Re-Enter the password";
        entries[4].setStatus(s?Form.ERROR:Form.OK,s);
    }
    private function checkEmail():void{
        var s:String;
        if(entries[5].text.length>0)
            if(StringUtility.isValidEmail(entries[5].text)){
                entries[5].setStatus(Form.WARNING,"Your e-mail may be correct");
                Core.amfCall("Account.checkEmail",onCheckEmail,entries[5].text);
                return;
            }
            else s="Not a valid E-Mail";
        else s="Enter your e-mail";
        entries[5].setStatus(Form.ERROR,s);
    }
    private function onCheckEmail(b:Boolean):void{
        if(b)entries[5].setStatus(Form.ERROR,"An account is already using this e-mail");
    }
}
