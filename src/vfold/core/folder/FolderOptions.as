/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.folder {
import vfold.core.application.ApplicationComponent;
public class FolderOptions {
    // Application Components
    private var ac:Object={};
    public function getAppComponent(classPath:String):ApplicationComponent{return ac[classPath] as ApplicationComponent}
    public function setAppComponent(appComponent:ApplicationComponent):void{ac[appComponent.classPath]=appComponent}
    public function get appComponents():Object{return ac}
}
}