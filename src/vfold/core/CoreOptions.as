/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core {
import vfold.core.workspace.Workspace;
import vfold.mail.MailOptions;
import vfold.display.assets.Images;

public class CoreOptions{

    // WebSite's Default Color
    public var color:uint=0x062f45;

    // Core Workspace Vector
    private var ws:Vector.<Workspace>=new Vector.<Workspace>;
    // Project Title
    public var title:String="VFOLD project";
    // Gateway
    public var gateway:String;
    // AES Security Key
    public var aesKey:String;
    // Facebook Application ID
    public var facebookAppID:String;
    // Mail Options
    public var mailOptions:MailOptions;

    public function CoreOptions(gateway:String,aesKey:String,facebookAppID:String,mailOptions:MailOptions){
        this.gateway=gateway;
        this.aesKey=aesKey;
        this.facebookAppID=facebookAppID;
        this.mailOptions=mailOptions;

        var w:Workspace=new Workspace();
        w.panel.logo=new Images.VFoldMenu;
        w.desktop.classPath="vfold.dashboard.Dashboard";
        w.desktop.library.url="libraries/dashboard.swf";
        w.title="vfold.dashboard.Dashboard";
        ws[0]=w;
    }
    public function set defaultWorkspace(value:Workspace){ws[0]=value}
    public function get workspaces():Vector.<Workspace>{return ws}
}
}
