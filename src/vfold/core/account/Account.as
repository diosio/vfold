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
import vfold.core.tool.Tool;
import vfold.controls.button.ButtonLabel;

public class Account extends Tool {

    // Account Button
    private var acb:ButtonLabel=new ButtonLabel();
    // Sign in Button
    private var sib:ButtonLabel=new ButtonLabel();
    // Join Button
    private var jnb:ButtonLabel=new ButtonLabel();
    // Sign in Drop Box Content
    private var sic:SignIn=new SignIn(onSignExit);
    // Join Drop Box Content
    private var jnc:Join=new Join(onJoinExit);

    public function Account() {
        Core.dispatcher.addEventListener(Core.ACCOUNT_CHANGE,onAccountChange);
        sib.setDropBox(sic, toolbar);
        jnb.setDropBox(jnc, toolbar);

        addChild(sib);
        addChild(jnb);

        sib.label="sign in";
        jnb.label="join";

        jnb.x=sib.width+3;
    }
    private function onAccountChange(e:Event):void{
        if(Core.currentUser){
            if(!contains(acb)){
                addChild(acb);
                removeChild(sib);
                removeChild(jnb);
            }
            acb.label=Core.currentUser.firstname+" "+Core.currentUser.lastname;
        }
        else{
            removeChild(acb);
            addChild(sib);
            addChild(jnb);
        }
        change();
    }
    private function onJoinExit():void{
        jnb.onStageDown();
    }
    private function onSignExit():void {
        sib.onStageDown();
    }
}
}

import flash.net.registerClassAlias;

import vfold.controls.form.FormEntry;
import vfold.core.Core;
import vfold.core.account.AccountRole;
import vfold.core.account.AccountVO;
import vfold.controls.form.Form;
import vfold.mail.MailComposition;
import vfold.utilities.StringModifier;
import vfold.utilities.EmailValidator;

class SignIn extends Form{
    private var ef:Function;
    private var ps:String;
    public function SignIn(exitFunction:Function):void{
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
class Join extends Form{
    // Mail Composition
    private var mc:MailComposition;
    // Mail Tokens
    private var mt:Object={};
    // Exit Join Form Function
    private var ef:Function;
    // Account Value Object
    private var acc:AccountVO=new AccountVO();
    public function Join(exitFunction:Function):void {
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
        acc.code=mt.code=StringModifier.generate(24);
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
            if(EmailValidator.isValidEmail(entries[5].text)){
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
