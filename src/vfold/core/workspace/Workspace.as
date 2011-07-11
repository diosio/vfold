/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.workspace {
import vfold.controls.button.ButtonOptions;
import vfold.core.folder.FolderOptions;
import vfold.core.panel.PanelOptions;
import vfold.core.widget.WidgetOptions;

public class Workspace extends ButtonOptions{

    // Desktop Component
    private var dcg:WorkspaceComponent=new WorkspaceComponent;
    // Widget Options
    private var wcg:WidgetOptions=new WidgetOptions;
    // Panel Options
    private var pcg:PanelOptions=new PanelOptions;
    // Folder Options
    private var fcg:FolderOptions=new FolderOptions;

    public function Workspace(){
        desktop.classPath="vfold.core.dashboard.Dashboard";
    }
    public function get desktop():WorkspaceComponent{return dcg}
    public function get widgets():WidgetOptions{return wcg}
    public function get panel():PanelOptions{return pcg}
    public function get folders():FolderOptions{return fcg}
}
}
