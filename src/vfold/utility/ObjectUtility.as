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
import flash.utils.describeType;
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
    public static function copyData(source:Object, destination:Object):void {

        //copies data from commonly named properties and getter/setter pairs
        if((source) && (destination)) {

            try {
                var sourceInfo:XML = describeType(source);
                var prop:XML;

                for each(prop in sourceInfo.variable) {

                    if(destination.hasOwnProperty(prop.@name)) {
                        destination[prop.@name] = source[prop.@name];
                    }

                }

                for each(prop in sourceInfo.accessor) {
                    if(prop.@access == "readwrite") {
                        if(destination.hasOwnProperty(prop.@name)) {
                            destination[prop.@name] = source[prop.@name];
                        }

                    }
                }
            }
            catch (err:Object) {
            }
        }
    }
}
}
