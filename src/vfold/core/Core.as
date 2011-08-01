/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core{

import com.jac.mouse.MouseWheelEnabler;

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.net.registerClassAlias;
import flash.utils.Dictionary;

import vfold.core.user.User;

import vfold.core.desktop.DesktopHandler;
import vfold.core.folder.FolderHandler;
import vfold.core.panel.PanelHandler;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import vfold.core.widget.WidgetHandler;
import vfold.core.workspace.Workspace;

public class Core extends Sprite {
    private static const ed:EventDispatcher=new EventDispatcher();

    // Libraries loaded
    private static var lld:Dictionary=new Dictionary();
    // Workspace Current Index
    private static var wci:uint;

    // Desktop
    private static var dt:DesktopHandler;
    // Toolbar
    private static var pn:PanelHandler;
    // Folders
    private static var fd:FolderHandler;
    // Widgets
    private static var wg:WidgetHandler;

    // Workspaces
    private static var ws:Vector.<Workspace>=new Vector.<Workspace>;

    public static const CORE_READY:String="coreReady";
    public static const USER_CHANGE:String="accountChange";
    public static const WORKSPACE_CHANGE:String="workspaceChange";
    public static const WORKSPACE_ADD:String="workspaceAdd";
    public static const VERSION:String="2011.07.28";

    public function Core(options:CoreOptions):void{

        addEventListener(Event.ADDED_TO_STAGE,addedToStage);

        registerClassAlias("VFOLD.Entity.User",UserVO);
        Secure.init(options);
    }
    private function addedToStage(e:Event):void {

        removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
        stage.scaleMode=StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        MouseWheelEnabler.init(stage);

        fd=new FolderHandler;
        pn=new PanelHandler();
        dt=new DesktopHandler();
        wg=new WidgetHandler;

        addChild(dt);
        addChild(wg);
        addChild(fd);
        addChild(pn);

        pn.addTool(new UserTool());

        //Check POST URL Parameters

        var pr:Object=root.loaderInfo.parameters;
        if(pr.confirmation){
            Secure.amfCall("Account.confirm",function(confirmed:Boolean):void{
                if(confirmed){
                    notify("Your account has been confirmed!\nNow you can sign-in");
                }
            },pr.confirmation);
        }

        //TODO: 2D/3D ACCELERATION /////////////////////////////////////////////////////

        stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE,function(e:Event):void{
            notify(stage.stage3Ds[0].context3D.driverInfo);
        });
        stage.stage3Ds[0].requestContext3D();

        //////////////////////////////////////////////////////////////////////////////

        for(var i:uint=0;i<Secure.OPT.workspaces.length;i++){

            addWorkspace(Secure.OPT.workspaces[i]);
        }
        useWorkspace(0);

        notify("Powered by vfold ("+VERSION+")");
        dispatchEvent(new Event(CORE_READY));
    }

    public static function notify(...rest):void{
        var t:String="  ";
        for each(var s:* in rest){
            t+=String(s)+"  ";
        }
        wg.notifier.notify(t);
    }
    public static function addWorkspace(workspace:Workspace):void{
        ws.push(workspace);
        dispatcher.dispatchEvent(new Event(WORKSPACE_ADD));
    }
    public static function useWorkspace(index:uint):void{
        wci=index;
        dispatcher.dispatchEvent(new Event(WORKSPACE_CHANGE));
    }
    public static function get desktopHandler():DesktopHandler{return dt}
    public static function get panelHandler():PanelHandler{return pn}
    public static function get folderHandler():FolderHandler{return fd}
    public static function get widgetHandler():WidgetHandler{return wg}

    public static function get color():uint{return Secure.OPT.color}
    public static function get dispatcher():EventDispatcher{return ed}
    public static function get libraries():Dictionary{return lld}
    public static function get currentWorkspace():Workspace{return ws[wci]}
    public static function get defaultWorkspace():Workspace{return ws[0]}
    public static function get currentWorkspaceIndex():uint{return wci}
    public static function get currentUser():User{return Secure.USR}
    public static function get projectTitle():String{return Secure.OPT.title}

}
}

import com.facebook.graph.Facebook;
import com.lia.crypto.AES;

import flash.events.Event;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.net.Responder;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

import vfold.core.CoreOptions;
import vfold.core.panel.PanelTool;
import vfold.mail.MailOptions;
import vfold.mail.MailVO;
import vfold.controls.button.ButtonDropBox;
import vfold.controls.button.ButtonLabel;
import vfold.controls.button.ButtonStyle;
import vfold.controls.form.FormEntry;
import vfold.core.Core;
import vfold.core.user.User;
import vfold.core.user.UserRole;
import vfold.controls.form.Form;
import vfold.display.assets.Images;
import vfold.display.text.TextSimple;
import vfold.mail.MailComposer;
import vfold.utility.ColorUtility;
import vfold.utility.StringUtility;


class Secure{

    // Net Connection
    private static const NET:NetConnection=new NetConnection();
    // Core Options
    public static var OPT:CoreOptions;
    // Mail Value Object
    private static var MVO:MailVO=new MailVO;
    // Current User Logged In
    public static var USR:UserVO;

    public static function init(options:CoreOptions):void{
        OPT=options;

        NET.objectEncoding=ObjectEncoding.AMF3;
        NET.addHeader("header");

        Facebook.init(OPT.facebookAppID,function(success:Object,failure:Object):void{
            onFacebookLogin(success,failure);
        });
    }
    public static function signInFacebook():void{
        Facebook.login(onFacebookLogin,{perms:
                "user_about_me, user_birthday, email, publish_stream, offline_access"
        });
    }
    public static function onFacebookLogin(success:Object,fail:Object):void{
        trace(success,fail);
        var m:String;
        if(success){
            Facebook.api("/me",
                    function(success:Object,failure:Object):void{
                        amfCall("Account.getAccountByFID",function(acc:UserVO):void{
                            if(acc){
                                USR=acc;
                                Core.dispatcher.dispatchEvent(new Event(Core.USER_CHANGE));
                                m="Welcome back "+USR.first_name+"!";
                            }
                            else{
                                acc = new UserVO();
                                acc.user_name=success.username;
                                acc.first_name=success.first_name;
                                acc.last_name=success.last_name;
                                acc.facebook_id=success.id;
                                acc.email=success.email;
                                acc.gender=success.male;
                                acc.birthday=success.birthday;
                                m="Registering Facebook account...";
                                amfCall("User.add",function():void{

                                },acc)
                            }
                            Core.notify(m);
                        },success.id)
                    });
        }
        else{

        }
    }
    public static function signInAccount(loginName:String,password:String,callback:Function):void{

        var m:String;
        amfCall("Account.getAccount",

                function(acc:UserVO):void{
                    if(acc)
                        if(acc.role==UserRole.NONE){
                            callback(false);
                            m="Account has not yet been confirmed\nCheck your e-mail";
                        }
                        else{
                            if (OPT.aesKey==AES.decrypt(acc.password,password,AES.BIT_KEY_256)){
                                USR=acc;
                                Core.dispatcher.dispatchEvent(new Event(Core.USER_CHANGE));
                                callback(true);
                                m="Welcome back "+USR.first_name+"!";
                            }
                            else{
                                callback(false);
                                m="Wrong password, try again";
                            }
                        }
                    else{
                        callback(false);
                        m="wrong username";
                    }
                    Core.notify(m);
                },
                loginName
        );
    }
    public static function sendMail(composition:MailComposer,options:MailOptions=null,onSuccess:Function=null,onFailure:Function=null):void{

        if(options)
            setOptions(options);
        else setOptions(OPT.mailOptions);

        function setOptions(value:MailOptions):void{
            MVO.from=value.from;
            MVO.host=value.host;
            MVO.port=value.port;
            MVO.password=value.password;
            MVO.username=value.username;
        }
        MVO.subject=composition.subject;
        MVO.message=composition.message;
        MVO.to=composition.to;

        amfCall("Core.sendMail",function(b:Boolean):void{
            if(b && onSuccess){
                onSuccess.call(null);
            }
            else if (onFailure){
                onFailure.call(null);
            }
        },MVO);
    }
    public static function amfCall(command:String,onResultFunction:Function,param:*=null):void{
        if(!NET.connected)NET.connect(OPT.gateway);
        NET.call(command,new NetResponder(onResultFunction),param);
    }
    public static function encrypt(password:String):String{
        return AES.encrypt(OPT.aesKey,password,AES.BIT_KEY_256);
    }
}
class NetResponder extends Responder{
    private var fn:Function;
    public function NetResponder(onResultFunction:Function):void{
        super(onResult,onError);
        fn=onResultFunction;
    }
    private function onResult(e:Object):void{
        if(fn)fn.call(null,e);
    }
    private function onError(e:Object):void{
        Core.notify("Amf Call Error: "+String(e));
    }
}
class UserVO extends User{
    public var password:String;
    public var facebook_token:String;
}
class UserTool extends PanelTool {

    // Account Button
    private var acb:ButtonLabel=new ButtonLabel();
    // Join Button
    private var sib:ButtonLabel=new ButtonLabel();
    // Join Drop Box Content
    private var sic:Join=new Join();

    public function UserTool() {
        Core.dispatcher.addEventListener(Core.USER_CHANGE,onAccountChange);
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
            acb.label=Core.currentUser.first_name+" "+Core.currentUser.last_name;
        }
        else{
            removeChild(acb);
            addChild(sib);
        }
        change();
    }
}

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
        si=new SignIn(bc,fc,close);
        fb.actionFunction=function():void{
            close();
            Secure.signInFacebook();
        };
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
    public function SignIn(titleColor:uint,fillColor:uint,exitFunction:Function):void{
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
    }
    override protected function onSubmitForm():void {
        Secure.signInAccount(getText(0),getText(1),
                function(success:Boolean):void{
                    if(success)
                        ef();
                });
    }
    private function checkLoginName():void{
        var s:String=getText(0).length>0?getText(0).length>5?"Invalid Login Name":"Login Name must be minimum 6 characters":"Enter your Login Name";
        setStatus(0,Form.ERROR,s);
        if(getText(0).length>5){
            Secure.amfCall("Account.checkLoginName",onCheckLoginName,getText(0));
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
    private var mc:MailComposer;
    // Mail Tokens
    private var mt:Object={};
    // Exit Join Form Function
    private var ef:Function;
    // Account Value Object
    private var usr:User=new User();
    public function Register(exitFunction:Function):void {
        ef=exitFunction;
        mt.domain=root.loaderInfo.url;
        mt.title=Core.projectTitle;
        Secure.amfCall("HTML.getHTML",function(h:String):void{mc=new MailComposer("Testing",h);},"welcome");
        usr.role=UserRole.NONE;
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
        usr.first_name=getText(0);
        usr.last_name=getText(1);
        usr.user_name=getText(2);
        //  usr.password=Core.encryptPassword(getText(4));
        usr.email=getText(5);
        mt.firstname=usr.first_name;
        mc.sendToSingle(getText(0)+" "+getText(1),getText(5));
        mc.tokens=mt;
        Secure.sendMail(mc,null,function():void{
            Core.notify("A confirmation letter has been sent to your e-mail address");
            Secure.amfCall("User.addEdit",null,usr);
        });
        Core.notify("Sending confirmation letter...");
        ef.call(null);
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
            Secure.amfCall("Account.checkLoginName",onCheckLoginName,getText(2));
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
                Secure.amfCall("Account.checkEmail",onCheckEmail,getText(5));
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
