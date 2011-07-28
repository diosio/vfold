/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core {
import com.facebook.graph.FacebookOptions;

import vfold.core.workspace.Workspace;
import vfold.mail.MailOptions;
import vfold.display.assets.Images;

public class CoreOptions {

    // WebSite's Default Color
    public var color:uint=0x062f45;
    // Gateway
    private var gw:String;
    // AES Security Key
    private var ak:String='w.w&eBx5bnkIm9u2dIQu1[Rr2D[m|Y>yExs"qLfNIog"c-6r2?|5Mj<]~S!&1P+';
    // Core Workspace Vector
    private var ws:Vector.<Workspace>=new Vector.<Workspace>;
    // Mail Options
    private var mo:MailOptions;
    // Project Title
    private var t:String="a VFOLD project";
    // Project Domain
    private var d:String;
    // Facebook Options
    private var fo:FacebookOptions;

    public function CoreOptions(domain:String,gateway:String,mailOptions:MailOptions,facebookOptions:FacebookOptions){
        fo=facebookOptions;
        d=domain;
        mo=mailOptions;
        gw=gateway;

        var w:Workspace=new Workspace();
        w.panel.logo=new Images.VFoldMenu;
        w.desktop.classPath="vfold.dashboard.Dashboard";
        w.desktop.library.url="libraries/dashboard.swf";
        w.title="vfold.dashboard.Dashboard";
        ws[0]=w;
    }
    public function get facebookOptions():FacebookOptions{return fo}
    public function get projectDomain():String{return d}
    public function get projectTitle():String{return t}
    public function set projectTitle(value:String):void{t=value}
    public function get securityKey():String{return ak}
    public function set securityKey(value:String):void{ak=value}
    public function set defaultWorkspace(value:Workspace){ws[0]=value}
    public function get mailOptions():MailOptions{return mo}
    public function get workspaces():Vector.<Workspace>{return ws}
    public function get gateway():String{return gw}
}
}
