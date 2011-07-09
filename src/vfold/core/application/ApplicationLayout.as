/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.application {
import flash.display.Sprite;
public class ApplicationLayout extends Sprite {
    private var sv:Vector.<ApplicationSection>;
    public var index:uint;
    // Application Width
    private var AW:Number;
    // Application Height
    private var AH:Number;
    public function ApplicationLayout(sections:Vector.<ApplicationSection>) {
        y=Application.GAP;
        sv=sections;
    }
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
    public function changeData(dataVector:Vector.<Object>,color:uint):void{
        for(var i:uint=0;i<sv.length;i++){
            sv[i].changeData(dataVector[i],color);
            addChild(sv[i]);
        }
    }
    public function get sectionsLength():uint{return sv.length}
}
}
