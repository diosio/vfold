/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.folder {

import flash.display.Sprite;
public class FolderLayout extends Sprite {
    private var sv:Vector.<FolderSection>=new <FolderSection>[];
    public var index:uint;
    // Application Width
    private var AW:Number;
    // Application Height
    private var AH:Number;
    public function FolderLayout() {
        y=Folder.GAP;
    }
    public function get sections():Vector.<FolderSection>{return sv}
    public function onFolderResize(appWidth:Number,appHeight:Number):void{
        AW=appWidth;
        AH=appHeight;
        for(var i:uint=0;i<sv.length;i++){
            sv[i].width=AW;
            sv[i].height=sv[i].prefHeight;
            sv[i].onSectionResize();
        }
        adjustSections();
    }
    public function adjustSections():void{

        for(var i:uint=0;i<sv.length;i++){
            if(i!=0)sv[i].y=sv[i-1].y+sv[i-1].height+10;
        }
    }
    public function changeData(data:*):void{
    }
}
}
