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
import com.lia.crypto.AES;

import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.utils.Dictionary;

import vfold.core.account.AccountRole;
import vfold.core.desktop.DesktopHandler;
import vfold.core.folder.FolderHandler;
import vfold.core.panel.PanelHandler;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import vfold.core.widget.WidgetHandler;
import vfold.core.account.AccountVO;
import vfold.core.workspace.Workspace;
import vfold.mail.MailComposition;
import vfold.mail.MailOptions;
import vfold.mail.MailVO;

public class Core extends Sprite {

    // Event Dispatcher
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

    // Loader Info Parameters
    private static var pr:Object;
    // Current Account Logged in
    private static var ca:AccountVO;
    // Guest Account
    private static var ga:AccountVO=new AccountVO;

    // Workspaces
    private static var ws:Vector.<Workspace>=new Vector.<Workspace>;

    public static const CORE_READY:String="coreReady";
    public static const ACCOUNT_CHANGE:String="accountChange";
    public static const WORKSPACE_CHANGE:String="workspaceChange";
    public static const WORKSPACE_ADD:String="workspaceAdd";
    public static const VERSION:String="2011.04.13";

    // Net Connection
    private static const nc:NetConnection=new NetConnection();

    // Core Options
    private static var op:CoreOptions;
    // Mail Value Object
    private static var mvo:MailVO=new MailVO;

    public function Core(options:CoreOptions):void{
        nc.objectEncoding=ObjectEncoding.AMF3;
        ga.role=AccountRole.NONE;
        ga.loginname="guest";
        op=options;
        addEventListener(Event.ADDED_TO_STAGE,addedToStage);
    }
    private function addedToStage(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
        stage.scaleMode=StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        MouseWheelEnabler.init(stage);
        pr=root.loaderInfo.parameters;
        fd=new FolderHandler;
        pn=new PanelHandler();
        dt=new DesktopHandler();
        wg=new WidgetHandler;
        addChild(dt);
        addChild(wg);
        addChild(fd);
        addChild(pn);
        for(var i:uint=0;i<op.workspaces.length;i++){
            addWorkspace(op.workspaces[i]);
        }
        useWorkspace(0);

        checkParameters();
        dispatchEvent(new Event(CORE_READY));
        notify("Powered by vfold ("+VERSION+")");
    }
    private function checkParameters():void{
        if(pr.confirmation){
            Core.amfCall("Account.confirm",function(confirmed:Boolean):void{
                if(confirmed){
                    notify("Your account has been confirmed!\nNow you can sign-in");
                }
            },pr.confirmation);
        }
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
        pn.toolbar.workspaceSwitcher.addSwitch(workspace.title);
        ed.dispatchEvent(new Event(WORKSPACE_ADD));
    }
    public static function useWorkspace(index:uint):void{
        wci=index;
        ed.dispatchEvent(new Event(WORKSPACE_CHANGE));
    }
    public static function get desktopHandler():DesktopHandler{return dt}
    public static function get panelHandler():PanelHandler{return pn}
    public static function get folderHandler():FolderHandler{return fd}
    public static function get widgetHandler():WidgetHandler{return wg}

    public static function get color():uint{return op.color}
    public static function get flashVars():Object{return pr}
    public static function get dispatcher():EventDispatcher{return ed}
    public static function get libraries():Dictionary{return lld}
    public static function get currentWorkspace():Workspace{return ws[wci]}
    public static function get defaultWorkspace():Workspace{return ws[0]}
    public static function get currentWorkspaceIndex():uint{return wci}
    public static function get currentUser():AccountVO{return ca}
    public static function get projectTitle():String{return op.projectTitle}
    public static function get projectDomain():String{return op.projectDomain}

    public static function amfCall(command:String,onResultFunction:Function,param:*=null):void{
        if(!nc.connected)nc.connect(op.gateway);
        nc.call(command,new NetResponder(onResultFunction),param);
    }
    public static function encryptPassword(password:String):String{
        return AES.encrypt(op.securityKey,password,AES.BIT_KEY_256);
    }
    public static function signInAccount(account:AccountVO,password:String):Boolean{
        if(!ca){
            if (op.securityKey==AES.decrypt(account.password,password,AES.BIT_KEY_256)){
                ca=account;
                notify("Welcome back "+ca.firstname+"!");
                ed.dispatchEvent(new Event(ACCOUNT_CHANGE));
                return true;
            }
            notify("Wrong password, try again");
        }
        return false;
    }
    public static function sendMail(composition:MailComposition,options:MailOptions=null,onSuccess:Function=null,onFailure:Function=null):void{
        mailComposition=composition;
        if(options)mailOptions=options;
        else mailOptions=op.mailOptions;

        amfCall("Core.sendMail",function(b:Boolean):void{
            if(b && onSuccess){
                onSuccess.call(null);
            }
            else if (onFailure){
                onFailure.call(null);
            }
        },mvo);
    }
    private static function set mailOptions(value:MailOptions):void{
        mvo.host=value.host;
        mvo.port=value.port;
        mvo.username=value.username;
        mvo.password=value.password;
        mvo.from=value.from;
    }
    private static function set mailComposition(value:MailComposition):void{
        mvo.subject=value.subject;
        mvo.message=value.message;
        mvo.to=value.to;
    }
}
}
import flash.net.Responder;
import flash.net.getClassByAlias;
import flash.net.registerClassAlias;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import vfold.core.Core;
import vfold.core.account.AccountVO;

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
