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
    public function FolderLayout() {
    }
    public function addSection(value:FolderSection):void{
        sv.push(value);
        addChild(value);
    }
    public function onFolderResize(w:Number,h:Number):void{
        for(var i:uint=0;i<sv.length;i++){
            sv[i].width=w;
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