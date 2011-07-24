/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.utilities {
public class ObjectUtility {
    // Available Objects
    private var aov:Vector.<Object>=new Vector.<Object>();
    // Contemporary Objects
    private var cov:Vector.<Object>=new Vector.<Object>();
    // Object Class
    private var OC:Class;
    // If getObject function instantiated the Class
    private var ib:Boolean=true;

    public function ObjectUtility(ObjectClass:Class) {
        OC=ObjectClass;
    }
    public function getObject():Object{
        var o:Object;
        if(aov.length > 0){
            o=aov.pop();
            ib=false;
        }
        else{
            o=new OC;
            ib=true;
        }
        cov.push(o);
        return o;
    }
    public function returnToPool(object:Object):void{
        cov.splice(cov.indexOf(object),1);
        aov.push(object);
    }
    public function returnAll():void{
        while(cov.length>0){
            var o:Object=cov[0];
            cov.splice(0,1);
            aov.push(o);
        }
    }
    public function get objects():Vector.<Object>{return cov}
    public function get instantiated():Boolean{return ib}
    public function get availableObjects():uint{return aov.length}
}
}
