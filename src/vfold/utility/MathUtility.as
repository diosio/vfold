/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/
package vfold.utility {
public class MathUtility {
    public static function randomNumber(from:Number,to:Number):Number{
        return (Math.random()*(to-from))+from;
    }
    public static function randomInt(from:int,to:int):int{
        return Math.round(Math.random()*(to-from))+from;
    }
}
}
