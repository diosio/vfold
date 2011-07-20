/*********************************************************************
 * Licensed under the Open Software License version 3.0              *
 *                                                                   *
 * This Open Software License (OSL-3.0) applies to any original work *
 * of authorship "vfold" whose owner Raphael Varonos has placed the  *
 * following licensing notice adjacent to the copyright notice for   *
 * the Original Work                                                 *
 *********************************************************************/

package vfold.controls.table {
import flash.display.DisplayObject;
import vfold.display.content.ContentContainer;
import vfold.display.content.ContentScroll;
import vfold.display.text.TextSimple;
import vfold.utilities.ColorUtility;

public class Table extends ContentContainer {
    // Width
    private var w:Number;
    // Header
    private var hd:Header;
    // Content Pane
    private var cp:TableContent;
    // Content Pane Container
    private var pc:ContentScroll;
    // Text Metrics Reference
    private var tm:TextSimple=new TextSimple;
    // Search Engine
    private var se:SearchEngine=new SearchEngine();
    // Maximum Column Width Vector
    private var mwv:Vector.<Number>=new Vector.<Number>();
    // Table Data
    private var td:TableData=new TableData();
    private var nrf:Function;


    public function Table(color:uint=0,data:TableData = null,onSelect:Function=null){
        se.isCaseSensitive=false;
        this.color=color;
        hd=new Header(color);
        cp=new TableContent(ColorUtility.brightness(color,0.56),tm.textFormat,tm.height,onSelect);
        pc=new ContentScroll();
        pc.addChild(cp);
        pc.y=hd.height;
        pc.wheelEnabled=true;
        addChild(hd);
        addChild(pc);
        width=320;
        height=230;
        if(td==data){
            columns=td.columns;
            rows=td.rows;
        }
    }
    public function set onNoResult(value:Function):void{nrf=value}
    public function clear():void{
        cp.clear();
        se.removeAllItems();
    }
    public function find(key:String):void{
        var trd:Vector.<TableRowData>=se.find(key);
        if(key.length>0){
            if(trd){
                rows=trd;
                cp.selectIndexes();
            }
            else{
                cp.clear();
                if(nrf)nrf.call();
            }
        }
        else rows=td.rows;
    }
    public function addRow(row:TableRowData):void{
        appendRow(row);
        cp.update();
        checkWidths();
    }
    public function set rows(value:Vector.<TableRowData>):void{
        cp.clear();
        for each(var row:TableRowData in value)appendRow(row);
        cp.update();
        checkWidths();
    }
    private function appendRow(row:TableRowData):void{
        var i:int;
        cp.addRowData(row);
        se.addItem(row);
        for (i=0;i<mwv.length;i++){
            mwv[i]=Math.max(mwv[i],tm.getNewTextWidth(row.fields[i]));
        }
    }
    public function set columns(value:Vector.<String>):void{
        hd.data=value;
        var i:int;
        if(mwv.length<value.length){
            for(i=mwv.length;i<value.length;i++){
                mwv.push(0);
            }
        }
        else{
            for(i=value.length;i<mwv.length;i++){
                mwv.splice(i,1);
            }
        }
        cp.numColumns=value.length;
    }
    private function checkWidths():void{
        var scw:Number=0;
        var i:uint;
        for each(var n:Number in mwv){scw+=n}
        if(scw>w){

        }
        else{
            i=mwv.length;
            // X Offset
            var xo:Number=0;
            // X Position
            var xp:Number=0;
            // Column Header
            var ch:DisplayObject;
            while(i-->1){
                ch=hd.getColumnHeader(i);
                xp=cp.width-(mwv[i]+xo);
                cp.adjustColumnX(xp,i);
                ch.x=xp+ch.width<w?xp:w-ch.width;
                xo+=mwv[i];
            }
        }
    }
    override public function set width(value:Number):void {
        super.width=value;
        w=value;
        cp.width=w;
    }
    override public function set height(value:Number):void {
        super.height=value;
        cp.viewHeight=pc.height=value-(hd.height);
    }
}
}

import flash.utils.Dictionary;

import vfold.controls.table.TableRowData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.text.TextFormat;
import vfold.controls.button.Button;
import vfold.core.CoreObjectPool;
import vfold.display.text.TextSimple;
import vfold.utilities.ColorUtility;
import flash.display.DisplayObject;
import flash.display.Sprite;

class TableColumn extends Sprite{

    public function TableColumn(){
        mouseEnabled=false;
        mouseChildren=false;
    }
    internal function addTopEntry(entry:DisplayObject):void{
        // Top Entry
        if(numChildren>0){
            var te:DisplayObject=getChildAt(0);
            entry.y=te.y-entry.height;
        }
        else entry.y = 0;
        addChildAt(entry,0);
    }
    internal function addBottomEntry(entry:DisplayObject):void{
        // Bottom Entry
        if(numChildren>0){
            var be:DisplayObject=getChildAt(numChildren-1);
            entry.y=be.y+be.height;
        }
        else entry.y = 0;
        addChild(entry);
    }
    internal function removeTopEntry():void{if(numChildren>0)removeChildAt(0)}
    internal function removeBottomEntry():void{if(numChildren>0)removeChildAt(numChildren-1)}
    internal function reset():void{while(numChildren>0){removeChildAt(0)}}
}
class TableRow extends Button{

    // Object Pool
    private var op:CoreObjectPool=new CoreObjectPool(TextSimple);
    // Text Format
    private var tf:TextFormat;
    // Row Height
    private var rh:Number;
    // Background Shape
    private var bg:Shape=new Shape;
    // HighLight Shape
    private var hl:Shape=new Shape;
    // Width
    private var w:Number=40;
    // Height
    private var h:Number=20;
    // is Even
    private var eb:Boolean;
    // Color
    private var cl:uint;
    // Bitmap Icon
    private var bm:Bitmap;
    // Sub Index to determine if it is located under a parent node
    private var si:uint=0;

    public function TableRow(){
        addChild(bg);
        addChild(hl);
        onOut();
    }
    override protected function onOut():void {
        hl.visible=false;
    }
    override protected function onDown():void {
    }
    override protected function onOver():void {
        hl.visible=true;
    }
    internal function setLabels(value:Vector.<String>):void{

        for(var i:uint=0;i<value.length;i++){
            if(i==op.objects.length){
                var ts:TextSimple=op.getObject() as TextSimple;
                if(op.instantiated){
                    ts.textFormat=tf;
                    bg.height=rh;
                }
            }
            op.objects[i].text=value[i];
        }
        var j:uint=op.objects.length;
        while(j-->i){
            op.returnToPool(op.objects[i]);
        }
    }
    private function drawRow(g:Graphics,color:uint,alpha:Number):void{
        g.clear();
        g.beginFill(color,alpha);
        g.drawRect(0,0,w,h);
        g.endFill();
    }
    private function draw():void{
        drawRow(bg.graphics,cl,eb?1:.5);
        drawRow(hl.graphics,ColorUtility.brightness(cl,0.7),1);
    }
    internal function getTextField(index:uint):TextSimple{return op.objects[index] as TextSimple}

    internal function set color(value:uint):void{cl=value}
    internal function set rowHeight(value:Number):void{rh=value}
    internal function set textFormat(value:TextFormat):void{tf=value}
    internal function set icon(value:BitmapData):void{bm.bitmapData=value}
    internal function get subIndex():uint{return si}
    internal function set subIndex(value:uint):void{si=value}

    override public function get width():Number {return w}
    override public function set width(value:Number):void {w=value;draw()}
    override public function set height(value:Number):void {h=value}
    override public function set index(value:uint):void{
        super.index=value;
        eb=value%2==0;
        draw();
    }
    internal function selectText(beginInd:uint, endInd:uint, fieldInd:uint):void {
        var t:TextSimple=TextSimple(op.objects[fieldInd]);
        t.boldSelection(beginInd,endInd);
    }
}
class TableContent extends Sprite{
    // Width
    private var w:Number=0;
    // Virtual Height
    private var vrh:Number=0;
    // View Height
    private var vwh:Number=0;
    // Y Offset
    private var yo:Number=0;
    // Number of Rows Needed
    private var rn:uint=0;
    // Data Vector
    private var dv:Vector.<TableRowData>;
    // List Row Pool
    private var lrp:CoreObjectPool=new CoreObjectPool(TableRow);
    // List Row Map Vector
    private var lrm:Vector.<TableRow>;
    // Column Pool
    private var clp:CoreObjectPool=new CoreObjectPool(TableColumn);
    // Row Container
    private var rcn:Sprite=new Sprite;
    // Color
    private var cl:uint=0;
    // Text Format
    private var tf:TextFormat;
    // Row Height
    private var rh:Number=0;
    // Resize event
    private var re:Event=new Event(Event.RESIZE);
    // onSelect Function
    private var sf:Function;

    public function TableContent(color:uint,textFormat:TextFormat,rowHeight:Number,onSelect:Function):void{
        sf = onSelect;
        cl=color;
        tf=textFormat;
        rh=rowHeight;
        addChild(rcn);

        addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
        if(sf)addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
        clear();
    }
    private function onMouseOver(e:Event):void {
        if(e.target is TableRow){
            var r:TableRow=TableRow(e.target);
            r.onMouseOver();
        }
    }
    private function onMouseOut(e:Event):void {
        if(e.target is TableRow){
            var r:TableRow=TableRow(e.target);
            r.onMouseOut();
        }
    }
    private function onMouseDown(e:Event):void {
        if(e.target is TableRow){
            sf.call(null,dv[TableRow(e.target).index]);
        }
    }
    internal function clear():void{
        vrh=rn=y=0;
        for each(var tc:TableColumn in clp.objects){
            tc.reset();
        }
        while(rcn.numChildren>0){
            var o:Object=rcn.getChildAt(0);
            rcn.removeChild(DisplayObject(o));
            lrp.returnToPool(o);
        }
        dv=new Vector.<TableRowData>();
        lrm=new Vector.<TableRow>();
    }
    internal function addRowData(row:TableRowData):void{
        dv.push(row);
    }
    internal function set numColumns(value:uint):void{
        var i:uint;
        for(i=0;i<value;i++){
            if(i==clp.objects.length){
                var c:TableColumn=clp.getObject() as TableColumn;
                addChild(c);
            }
            c.reset();
        }
        var j:uint=clp.objects.length;
        while(j-->i){
            removeChild(clp.objects[j] as DisplayObject);
            clp.returnToPool(clp.objects[j]);
        }
    }
    internal function adjustColumnX(value:Number,index:uint):void{
        clp.objects[index].x=value;
    }
    internal function update():void{
        vrh=dv.length*rh;
        updateRows();
        width=w;
    }
    private function updateRows():void{
        var prn:uint=rn,l:uint,i:uint;
        rn=Math.ceil(vwh/rh);
        if(rn<prn){
        }
        else if(rn>prn){
            l=rn-prn<dv.length?rn-prn:dv.length;
            for(i=0;i<l;i++){
                addBottomRow();
            }
        }
    }
    override public function set y(value:Number):void {
        var l:uint;
        var i:uint;
        super.y = value;
        if(y<0){
            if(y-yo<=-rh){
                l=Math.floor((-y+yo)/rh);
                l=l>rn?rn:l;
                yo-=l*rh;
                for(i=0;i<l;i++)removeTopRow();
            }
            else if(y-yo>=0) {
                l=Math.ceil((y-yo)/rh);
                l=l>rn?rn:l;
                yo+=l*rh;
                for(i=0;i<l;i++)addTopRow();
            }
            if(y-yo+super.height<=vwh){
                l=Math.ceil((vwh-(y-yo+super.height))/rh);
                l=l>rn?rn:l;
                for(i=0;i<l;i++)addBottomRow();
            }
            else if(y-yo+super.height>vwh+rh){
                l=Math.floor((y-yo+super.height-vwh)/rh);
                l=l>rn?rn:l;
                for(i=0;i<l;i++)removeBottomRow();
            }
        }
    }
    override public function set width(value:Number):void {
        w = value;
        for each(var r:TableRow in lrm)r.width=w;
        dispatchEvent(re);
    }
    override public function get height():Number {return vrh}
    internal function set viewHeight(value:Number):void{
        vwh=value;
        updateRows();
    }

    private function removeTopRow():void{
        var r:TableRow=TableRow(lrm[0]);
        lrm.shift();
        for(var i:uint;i<clp.objects.length;i++){
            TableColumn(clp.objects[i]).removeTopEntry();
        }
        rcn.removeChild(r);
        lrp.returnToPool(r);
    }
    private function removeBottomRow():void{
        var r:TableRow=TableRow(lrm[lrm.length-1]);
        lrm.pop();
        for(var i:uint;i<clp.objects.length;i++){
            TableColumn(clp.objects[i]).removeBottomEntry();
        }
        rcn.removeChild(r);
        lrp.returnToPool(r);
    }
    private function addTopRow():void{
        var r:TableRow=addRow();
        lrm.unshift(r);
        r.index=prevTopDataIndex-1;
        r.setLabels(dv[r.index].fields);
        for(var i:uint;i<clp.objects.length;i++){
            TableColumn(clp.objects[i]).addTopEntry(r.getTextField(i));
        }
        addRowBackground(r);
    }
    private function addBottomRow():void{
        var r:TableRow=addRow();
        lrm.push(r);
        r.index=prevBottomDataIndex+1;
        r.setLabels(dv[r.index].fields);
        for(var i:uint;i<clp.objects.length;i++){
            TableColumn(clp.objects[i]).addBottomEntry(r.getTextField(i));
        }
        addRowBackground(r);
    }
    private function addRow():TableRow{
        var r:TableRow=lrp.getObject() as TableRow;
        if(lrp.instantiated){
            r.color=cl;
            r.textFormat=tf;
            r.rowHeight=rh;
            r.width=w;
        }
        return r;
    }
    private function addRowBackground(r:TableRow):void{
        r.y=r.index*rh;
        rcn.addChild(r);
    }
    internal function get prevTopDataIndex():int{
        if(lrm.length==1)return 1;
        return  lrm[1].index;
    }
    internal function get prevBottomDataIndex():int{
        if(lrm.length==1)return -1;
        return  lrm[lrm.length-2].index;
    }
    internal function selectIndexes():void {
        for each(var r:TableRow in lrm){
            var data:TableRowData=dv[r.index];
            r.selectText(data.beginInd,data.endInd,data.fieldInd);
        }
    }
}
class Header extends Sprite{
    // Text Field Object pool
    private var op:CoreObjectPool=new CoreObjectPool(TextSimple);
    // Color
    private var cl:uint;
    // Text Metrics Reference
    private var tmr:TextSimple=new TextSimple;
    public function Header(color:uint){
        cl=color;
        tmr.size=14;
        tmr.color=ColorUtility.brightness(cl,.74);
    }
    internal function set data(value:Vector.<String>):void{
        for(var i:uint=0;i<value.length;i++){
            if(i==op.objects.length){
                var ts:TextSimple=op.getObject() as TextSimple;
                if(op.instantiated){
                    ts.textFormat=tmr.textFormat;
                }
                addChild(ts);
            }
            op.objects[i].text=value[i];
        }
        var j:uint=op.objects.length;
        while(j-->i){
            removeChild(op.objects[j] as TextSimple);
            op.returnToPool(op.objects[i]);
        }
    }
    internal function getColumnHeader(index:uint):DisplayObject{return op.objects[index] as DisplayObject}
    override public function get height():Number {
        return tmr.height;
    }
    internal function get columns():Vector.<String>{return Vector.<String>(op.objects)}
}
/**
 * @author sajeevkumar
 */
class SearchEngine
{
    private var engin:IndexingEngin;
    private var allSearchData:Dictionary = new Dictionary();
    private var _isCaseSensitive:Boolean = true;
    private var _isMixed:Boolean = true;
    // TODO: private var searchRank:Object;
    public function SearchEngine()
    {
        init();
    }
    /**
     * mixed type will search any combination in given keys
     */
    internal function get isMixed():Boolean{return _isMixed}
    internal function set isMixed(value:Boolean):void
    {
        _isMixed = value;
        recreate();
    }
    /**
     * case sensitive search
     */
    internal function get isCaseSensitive():Boolean{return _isCaseSensitive}
    internal function set isCaseSensitive(value:Boolean):void
    {
        _isCaseSensitive = value;
        recreate();
    }
    /**
     * add new search data
     */
    internal function addItem(data:TableRowData):void
    {
        allSearchData[data.id] = data;
        createIndexMechanism(data);
    }
    /**
     * add list of search data
     */
    internal function addItems(allData:Vector.<TableRowData>):void
    {
        for each (var data:TableRowData in allData)
            addItem(data);
    }
    /**
     * remove all the search data provided
     */
    internal function removeAllItems():void
    {
        init();
    }
    /**
     * remove single search data
     */
    internal function removeItem(data:TableRowData):void
    {
        if (null == allSearchData[data.id])
            return;
        //engin.removeSearchData(data);
        delete allSearchData[data.id];
        recreate();
    }
    /**
     * remove search data with given id
     */
    internal function removeItemWithId(id:uint):void
    {
        var data:TableRowData = allSearchData[id];
        if (data)
            removeItem(data);
    }
    /**
     *  remove list of search data
     */
    internal function removeItems(allData:Vector.<TableRowData>):void
    {
        for each (var data:TableRowData in allData)
            removeItem(data);
    }
    /**
     * perform search with given key and return result as list
     */
    internal function find(key:String):Vector.<TableRowData>
    {
        if (!isCaseSensitive)
            key = key.toUpperCase();
        var keyDetail:KeyDetail = engin.findItem(key);
        if (keyDetail)
            return keyDetail.result;
        else
            return null;
    }
    //
    //
    private function init():void
    {
        engin = new IndexingEngin();
        allSearchData = new Dictionary();
    }
    //reset and recreate search data
    private function recreate():void
    {
        engin = new IndexingEngin();
        for each (var data:TableRowData in allSearchData)
            createIndexMechanism(data);
    }
    private function createIndexMechanism(data:TableRowData):void
    {
        var i:uint = 0;
        var key:String;
        for (var a:uint=0;a<data.fields.length;a++){
            key=data.fields[a];
            if (_isMixed)
                for (i=1; i <= key.length; i++)
                    for (var j:uint = 0; j <= (key.length - i); j++){
                        placeSearchKeys(key.substr(j, i), data,j,i+j,a);
                    }
            else
                for (i=1; i <= key.length; i++){
                    placeSearchKeys(key.substr(0, i), data,0,i,a);
                }
        }
    }
    private function placeSearchKeys(unitKey:String, data:TableRowData,beginIndex:uint,endIndex:uint,fieldIndex:uint):void
    {
        var enginValue:KeyDetail = engin.getItem(_isCaseSensitive ? unitKey : unitKey.toUpperCase());
        enginValue.addData(data,beginIndex,endIndex,fieldIndex);
    }
}
/**
 * @author sajeevkumar
 */
class KeyDetail
{
    private var dataDic:Dictionary = new Dictionary();
    private var rowData:Vector.<TableRowData>=new <TableRowData>[];
    private var beginIndexes:Vector.<uint>=new <uint>[];
    private var endIndexes:Vector.<uint>=new <uint>[];
    private var fieldIndexes:Vector.<uint>=new <uint>[];

    internal function addData(data:TableRowData,beginIndex:uint,endIndex:uint,fieldIndex:uint):void
    {
        if (null == dataDic[data.id])
        {
            dataDic[data.id] = data;
            rowData.push(data);
            beginIndexes.push(beginIndex);
            endIndexes.push(endIndex);
            fieldIndexes.push(fieldIndex);
        }
    }
    internal function get result():Vector.<TableRowData>{
        for (var i:int = 0;i<rowData.length;i++){
           rowData[i].beginInd=beginIndexes[i];
           rowData[i].endInd=endIndexes[i];
           rowData[i].fieldInd=fieldIndexes[i];
        }
        return rowData;
    }
    internal function removeData(data:TableRowData):uint
    {
        for (var i:uint = 0; i <= rowData.length; i++)
            if (data.id == rowData[i].id)
            {
                rowData.splice(i,1);
                beginIndexes.splice(i,1);
                endIndexes.splice(i,1);
                fieldIndexes.splice(i,1);
                break;
            }
        delete dataDic[data.id];
        return rowData.length;
    }
}
//
/**
 * @author sajeevkumar
 */
class IndexingEngin
{
    private var dataDic:Dictionary = new Dictionary();
    internal function findItem(key:String):KeyDetail
    {
        return dataDic[key];
    }
    internal function getItem(key:String):KeyDetail
    {
        var keyDeta:KeyDetail = dataDic[key];
        if (null == keyDeta)
            keyDeta = dataDic[key] = new KeyDetail();
        return keyDeta;
    }
    internal function removeSearchData(data:TableRowData):void
    {
        var remaining:uint;
        for (var key:String in dataDic)
        {
            remaining = dataDic[key].removeData(data);
            if (0 == remaining)
                delete dataDic[key];
        }
    }
}
class SearchResult{

}