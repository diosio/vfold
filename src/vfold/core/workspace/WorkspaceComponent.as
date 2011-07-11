/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.workspace {
import vfold.core.*;

import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.getDefinitionByName;

public class WorkspaceComponent{
    // Class Path
    public var classPath:String;
    // Component Type
    public var type:String;
    // Parameters
    public var parameters:Object;
    // Library
    private var l:WorkspaceLibrary=new WorkspaceLibrary();
    // On Instantiated Function
    private var iF:Function;
    // Dependency Loaded Count
    private var dlc:uint=0;
    public function instantiate(onInstantiated:Function):void{
        iF=onInstantiated;
        if ( ApplicationDomain.currentDomain.hasDefinition(classPath)){
            var compClass:Class = getDefinitionByName(classPath) as Class;
            iF.call(null,new compClass);
        }else if(l){
            if(l.dependencies.length>0){
            for each (var dependency:WorkspaceLibrary in l.dependencies){
                if (Core.libraries[dependency])onDependencyLoaded();
                else loadLibrary(dependency,onDependencyLoaded);
            }
            }
            else loadLibrary(l,onComponentLoaded);
        }
        else{trace("A problem with your component has occurred")}
    }
    private function loadLibrary(library:WorkspaceLibrary,onLibraryLoaded:Function):void{
        Core.libraries[library]=true;
        var rsl:Loader = new Loader();
        var request:URLRequest = new URLRequest(library.url);
        var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
        rsl.contentLoaderInfo.addEventListener(Event.COMPLETE,onLibraryLoaded);
        rsl.load(request, loaderContext);
    }
    private function onDependencyLoaded(e:Event=null):void{
        dlc++;
        if(dlc==l.dependencies.length){
            dlc=0;
            loadLibrary(l,onComponentLoaded);
        }
    }
    private function onComponentLoaded(e:Event=null):void{instantiate(iF)}
    public function get library():WorkspaceLibrary{return l}
    public function set library(value:WorkspaceLibrary):void{l=value}
}
}
