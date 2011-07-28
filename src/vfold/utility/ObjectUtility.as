/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.utility {
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ObjectUtility {
    public function ObjectUtility() {
    }
     public static function newSibling(sourceObj:Object):* {
         if(sourceObj) {

             var objSibling:*;
             try {
                 var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(sourceObj)) as Class;
                 objSibling = new classOfSourceObj();
             }

             catch(e:Object) {}

             return objSibling;
         }
         return null;
     }
    public static function clone(source:Object):* {
        var copier:ByteArray = new ByteArray();
        copier.writeObject(source);
        copier.position = 0;
        return copier.readObject() as source.constructor;
    }
}
}
