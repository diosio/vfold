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

import vfold.core.user.UserRole;
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

    // Loader Info Parameters
    private static var pr:Object;
    // Current Account Logged in
    private static var ca:UserVO;
    // Guest Account
    private static var ga:UserVO;

    // Workspaces
    private static var ws:Vector.<Workspace>=new Vector.<Workspace>;

    public static const CORE_READY:String="coreReady";
    public static const ACCOUNT_CHANGE:String="accountChange";
    public static const WORKSPACE_CHANGE:String="workspaceChange";
    public static const WORKSPACE_ADD:String="workspaceAdd";
    public static const VERSION:String="2011.07.28";


    public function Core(options:CoreOptions):void{
        ga=new UserVO();
        ga.role=UserRole.NONE;
        ga.user_name="guest";
        addEventListener(Event.ADDED_TO_STAGE,addedToStage);

        registerClassAlias("VFOLD.Entity.User",UserVO);
        Secure.init(options);
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

        //Check POST URL Parameters

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
    public static function get flashVars():Object{return pr}
    public static function get dispatcher():EventDispatcher{return ed}
    public static function get libraries():Dictionary{return lld}
    public static function get currentWorkspace():Workspace{return ws[wci]}
    public static function get defaultWorkspace():Workspace{return ws[0]}
    public static function get currentWorkspaceIndex():uint{return wci}
    public static function get currentUser():UserVO{return ca}
    public static function get projectTitle():String{return Secure.OPT.title}

}
}

import com.facebook.graph.Facebook;
import com.lia.crypto.AES;

import flash.events.Event;

import flash.net.NetConnection;
import flash.net.ObjectEncoding;

import flash.net.Responder;
import vfold.core.Core;
import vfold.core.CoreOptions;
import vfold.core.user.User;
import vfold.core.user.UserRole;
import vfold.mail.MailComposer;
import vfold.mail.MailOptions;
import vfold.mail.MailVO;

class Secure{

    // Net Connection
    private static const NET:NetConnection=new NetConnection();
    // Core Options
    public static var OPT:CoreOptions;
    // Mail Value Object
    private static var MVO:MailVO=new MailVO;
    // Current User Logged In
    private static var USR:UserVO;

    public static function init(options:CoreOptions):void{
        OPT=options;

        NET.objectEncoding=ObjectEncoding.AMF3;

        Facebook.init(OPT.facebookAppID,function(success:Object,failure:Object):void{
            onFacebookLogin(success,failure);
        });
    }

    private static function signInFacebook():void{
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
                                Core.dispatcher.dispatchEvent(new Event(Core.ACCOUNT_CHANGE));
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
                                amfCall("Account.addEditAccount",function():void{

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
                                Core.dispatcher.dispatchEvent(new Event(Core.ACCOUNT_CHANGE));
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
