/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.core.widget.search {
import vfold.controls.button.ButtonOptions;
import vfold.controls.button.ButtonList;
import vfold.controls.button.ButtonStyle;
import vfold.display.content.ContentScroll;
import vfold.display.window.WindowSimple;

public class Search extends WindowSimple {

    // Content Container
    private var cC:SearchContent;
    // Button List
    private var bL:ButtonList;
    // Scroll Container
    private var sC:ContentScroll;
    // Search Bar
    private var sB:SearchBar;
    // Current Result index
    private var cI:uint;
    // Search Engine Vector
    private var seV:Vector.<SearchInterface>=new Vector.<SearchInterface>;
    // Error Result
    private var seR:Vector.<ButtonOptions>=new Vector.<ButtonOptions>(1,true);


    public function Search(color:uint):void{

        seR[0]=new ButtonOptions;
        seR[0].title="Δε βρέθηκε αποτέλεσμα";
        seR[0].description="Δοκιμάστε ξανά";
        bL=new ButtonList(onButtonDown,new ButtonStyle(0xFFFFFF,.8));
        sC=new ContentScroll(bL,color);
        sB=new SearchBar(search,onCategory,color);
        cC=new SearchContent(sC,sB);

        sC.thumbnail.width=8;

        super(cC);

        borderAlpha=.8;
        borderColor=color;
        borderThickness=10;

        width=300;
        height=400;

        draw();
    }
    public function search(text:String):void{

        seV[cI].search(text);
        sB.text = text;
    }
    public function addSearchEngine(engine:SearchInterface):void{

        engine.onResult=onResult;
        seV.push(engine);
    }
    public function selectEngine(engineIndex:uint):void{

        titleText=seV[engineIndex].title;
        cI=engineIndex;
    }
    private function onCategory():void {

    }
    private function onResult(result:SearchResult):void{

        seV[cI].currentIndex=-1;

        if(result.results.length>0){

            titleText=seV[cI].title+" | "+String(result.results.length)+(result.results.length>1?" αποτελέσματα":" αποτέλεσμα");
            bL.addButtons(result.results);
            if(!bL.getSelectableButton(0))bL.setSelectableButton(0,true);
            onButtonDown(0);
        }
        else{

            titleText=seV[cI].title;
            bL.addButtons(seR);
            bL.setSelectableButton(0,false);
        }
    }
    private function onButtonDown(buttonIndex:uint):void{

        bL.selectButton(buttonIndex);
        seV[cI].onResultSelect(buttonIndex);
    }
}
}
