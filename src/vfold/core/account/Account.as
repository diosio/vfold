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
        sib.dropBox=sic;
        sic.dispatcher=toolbar;
        sib.label="Join";
        addChild(sib);
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

import com.facebook.graph.Facebook;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.net.registerClassAlias;

import vfold.controls.button.ButtonDropBox;

import vfold.controls.button.ButtonLabel;
import vfold.controls.button.ButtonStyle;

import vfold.controls.form.FormEntry;
import vfold.core.Core;
import vfold.core.account.AccountRole;
import vfold.core.account.AccountVO;
import vfold.controls.form.Form;
import vfold.display.assets.Images;
import vfold.display.text.TextSimple;
import vfold.mail.MailComposition;
import vfold.utility.ColorUtility;
import vfold.utility.StringUtility;

class Join extends ButtonDropBox{
    private const g:int=8;
    private var si:SignIn;

    public function Join(){
        var bc:uint=ColorUtility.brightness(Core.color,.7),
                fc:uint=ColorUtility.brightness(Core.color,.04),
                s1:Separator=new Separator(bc),
                s2:Separator=new Separator(bc),
                t1:TextSimple = new TextSimple(13,bc),
                t2:TextSimple = new TextSimple(13,bc),
                bs:ButtonStyle=new ButtonStyle(fc,1,1,bc,1,bc),
                rb:ButtonLabel=new ButtonLabel(bs),
                fb:ButtonLabel=new ButtonLabel(bs);
        si=new SignIn(bc,fc);
        fb.actionFunction=function():void{trace("action");Facebook.init(
                "137172046368016",
                function facebookInit(success:Object,fail:Object):void{
                    if(success){

                    }
                }
        )};
        rb.label="Register";
        fb.label="Facebook";
        fb.icon=new Images.Facebook;
        t1.text="Not a member?";
        t2.text="Sign in with:";

        addChild(rb);
        addChild(fb);
        addChild(si);
        addChild(s1);
        addChild(s2);
        addChild(t1);
        addChild(t2);

        fb.x = t2.x+t2.width+g;
        s1.width=s2.width=width;
        s1.label="or";
        s1.y = rb.height;
        t2.y =fb.y= s1.y+s1.height;
        t2.y+=(fb.height-t2.height)>>1;

        s2.y = fb.y+fb.height+g;
        si.y = s2.y+s2.height+g;
        rb.x = width-rb.width;
        fb.x = width-fb.width;
    }
    override public function onOpen():void {
        stage.focus=si.getTextField(0);
    }
    override public function onClose():void {
    }
}
class Separator extends Sprite{
    private var g:Graphics;
    private const tf:TextSimple = new TextSimple();
    private var w:Number=100;
    private var c:uint;
    public function Separator(color:uint = 0xFFFFFF){
        tf.color=color;
        c = color;
        var s:Shape = new Shape();
        g=s.graphics;
        addChild(s);
        draw();
    }
    public function set label(value:String):void{
        if(value){
            if(!contains(tf))addChild(tf);
            tf.text =value;
            tf.x=(w-tf.width)/2;
            draw();
        }
        else
        if(contains(tf))removeChild(tf);
    }
    private function draw():void{
        g.clear();
        g.lineStyle(1,c,1);
        if(contains(tf)){
            var y:Number = tf.height/2;
            g.moveTo(0,y);
            g.lineTo(tf.x,y);
            g.moveTo(tf.x+tf.width,y);
            g.lineTo(width,y);
        }
        else{
            g.moveTo(0,0);
            g.lineTo(width,0);
        }
    }
    override public function get width():Number {return w}
    override public function set width(value:Number):void {
        w = value;
        draw();
    }

}

class SignIn extends Form{
    private var ef:Function;
    public function SignIn(titleColor:uint,fillColor:uint,exitFunction:Function=null):void{
        super(titleColor,fillColor);
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
        Core.signInAccount(getText(0),getText(1),
        function():void{

        });
        ef.call(null);
    }
    private function checkLoginName():void{
        var s:String=getText(0).length>0?getText(0).length>5?"Invalid Login Name":"Login Name must be minimum 6 characters":"Enter your Login Name";
        setStatus(0,Form.ERROR,s);
        if(getText(0).length>5){
            Core.amfCall("Account.checkLoginName",onCheckLoginName,getText(0));
        }
    }
    private function onCheckLoginName(b:Boolean):void{
        if(b)setStatus(0,Form.OK);
    }
    private function checkPassword():void{
        var s:String=getText(1).length>0?getText(1).length>7?null:"Password must be 8 characters minimum in length":"Enter your password";
        setStatus(1,s?Form.ERROR:Form.WARNING,s);
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
        disable(4);
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
        acc.firstname=getText(0);
        acc.lastname=getText(1);
        acc.loginname=getText(2);
        acc.password=Core.encryptPassword(getText(4));
        acc.email=getText(5);
        acc.code=mt.code=StringUtility.generate(24);
        mt.firstname=getText(0);
        mc.sendToSingle(getText(0)+" "+getText(1),getText(5));
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
        var s:String=getText(0).length>0?null:"Enter your First Name";
        setStatus(0,s?Form.ERROR:Form.OK,s);
    }
    private function checkLastName():void{
        var s:String=getText(1).length>0?null:"Enter your Last Name";
        setStatus(1,s?Form.ERROR:Form.OK,s);
    }
    private function checkLoginName():void{
        var s:String=getText(2).length>0?getText(2).length>5?null:"Enter a login name with 8 characters minimum in length":"Enter a Desired Login Name";
        setStatus(2,s?Form.ERROR:Form.OK,s);
        if(!s){
            Core.amfCall("Account.checkLoginName",onCheckLoginName,getText(2));
        }
    }
    private function onCheckLoginName(b:Boolean):void{
        setStatus(2,b?Form.ERROR:Form.OK,"Login Name already exists");
    }
    private function checkPassword():void{
        var s:String=getText(3).length>0?getText(3).length>7?null:"Enter a password with 8 characters minimum in length":"Enter a password";
        setStatus(3,s?Form.ERROR:Form.OK,s);
        if(!s&&!enabled(4))enable(4);
        else if(s&&enabled(4))disable(4);
    }
    private function reCheckPassword():void{
        var s:String=getText(4).length>0?getText(3)==getText(4)?null:"Passwords do not match":"Re-Enter the password";
        setStatus(4,s?Form.ERROR:Form.OK,s);
    }
    private function checkEmail():void{
        var s:String;
        if(getText(5).length>0)
            if(StringUtility.isValidEmail(getText(5))){
                setStatus(5,Form.WARNING,"Your e-mail may be correct");
                Core.amfCall("Account.checkEmail",onCheckEmail,getText(5));
                return;
            }
            else s="Not a valid E-Mail";
        else s="Enter your e-mail";
        setStatus(5,Form.ERROR,s);
    }
    private function onCheckEmail(b:Boolean):void{
        if(b)setStatus(5,Form.ERROR,"An account is already using this e-mail");
    }
}
