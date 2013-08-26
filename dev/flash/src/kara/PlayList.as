package {

	import fl.controls.ScrollBar;
	import fl.events.ScrollEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;

	public class PlayList extends Sprite  {

		var draggables				:	Array = [];
		var coords					:	Array = [];
		var selectedDraggable		:	MovieClip;
		var tryNr					:	int = 0;
		var items 					:    Array  = [];
		private var listItems;
		private var interval;
		private var mouseMoved		:	Boolean = false;
		private var scrollBar       :	ScrollBar;
		public var contaner         : 	Sprite;
		public var masker       	: 	Sprite;

		public var plBkg   			: 	MovieClip;

		public var lastClickedItem = null;
		private var _mHeight;
		private var _cellHeight;
		private var dragCorrn;
		public var plHeader;
		private var plFooter;
		private var addBtn;
		public var SearchBox;
		var f:FileReferenceList = new FileReferenceList();
		private var dragListItems:Array = new Array();
		private var searchResult:Sprite;
		private var searchArray:Array = new Array();;

		public function PlayList (i:Array, intervalBetweenItems:Number = 2 , listHeight:Number = 600, cellHeight:Number = 20, listWidth:Number = 300) {
			contaner = new Sprite();
			searchResult = new Sprite();

			masker = new Sprite();

			masker.graphics.beginFill(0x0000FF);
			masker.graphics.drawRect(0,0,100,100);
			masker.graphics.endFill();
			var bg = new backGround();

			bg.name = "bck";

			plBkg = bg
			addChild(bg);
			addChild(contaner);
			contaner.addChild(searchResult);
			addChild(masker);
			_mHeight = listHeight;
			_cellHeight = cellHeight;
			listItems = i;
			interval = intervalBetweenItems;
			buildUpCoords();
			initDraggables();
			scrollBar = new ScrollBar();

			addChild(scrollBar);
			masker.width = listWidth;
			masker.height =_mHeight;
			contaner.mask = masker;
			scrollBar.height = masker.height
			scrollBar.x = contaner.x + masker.width;
			scrollBar.y = 0
			scrollBar.setScrollProperties(masker.height, 0, (contaner.height-masker.height))
			scrollBar.addEventListener(ScrollEvent.SCROLL, scrollMC);

			bg.x = -5;
			bg.y = -5;
			bg.width = masker.width + scrollBar.width + 10;
			bg.height = masker.height + 37;

			dragCorrn = new DragCorrner();
			dragCorrn.addEventListener(MouseEvent.MOUSE_DOWN, startListResize);
			dragCorrn.y = bg.height;
			dragCorrn.x = bg.width;
			addChild(dragCorrn);

			plHeader= new PlaylistHeader();
			plHeader.y -= plHeader.height
			plHeader.x = bg.x
			plHeader.width = bg.width;
			plHeader.name = "bck"
			addChild(plHeader);

			addBtn= new AddBtn();
			addBtn.x =  bg.x + addBtn.width/2;
			addBtn.y =  bg.height - addBtn.height/2 - 10;
			addChild(addBtn);
			addBtn.addEventListener(MouseEvent.CLICK , browse);
			//plFooter = new PlaylistFooter();
			//plFooter.x = bg.x;
			//plFooter.y = bg.height;
			//plFooter.width = bg.width;
			//plFooter.name = "bck";
			//addChild(plFooter);

			SearchBox = new SearchB();
			SearchBox.x = bg.x + bg.width - SearchBox.width - 10;
			SearchBox.y = plHeader.y;
			addChild(SearchBox);
			SearchBox.closeBtn.addEventListener(MouseEvent.CLICK , closePlayList);
			SearchBox.toSearch_txt.addEventListener(Event.CHANGE  , textIntoTextBox);

		}

		private function closePlayList(e:MouseEvent):void
		{
			this.visible  = false;
		}

		private function textIntoTextBox(e:Event):void
		{

			if (SearchBox.toSearch_txt.text.length > 3) {
				removeSearhResults()

				var toSearch:String = SearchBox.toSearch_txt.text;
				toSearch = toSearch.substring(0, toSearch.length - 1).toLocaleLowerCase();
				var found = 0;
				for (var i = 0 ; i < dragListItems.length ; i++) {
					dragListItems[i].visible = false;
					if (dragListItems[i].name_txt.text.toLocaleLowerCase().indexOf(toSearch) > -1) {
						found++
						contaner.y = 0;
						scrollBar.setScrollPosition(0, true);
						searchArray.visible = true;
						var temp = new dragBox();
						temp.box.height = _cellHeight;
						temp.name_txt.text = dragListItems[i].name_txt.text;
						temp.name_txt.textColor = 0xFF6600;
						temp.idx =  dragListItems[i].idx;
						temp.y = ((temp.height + interval) * found) -  temp.height;

						temp.cdgRef = dragListItems[i].cdgRef
						temp.mp3Ref = dragListItems[i].mp3Ref
						temp.name_txt.mouseEnabled = false;

						searchResult.visible = true;
						searchResult.addChild(temp);

						temp.addEventListener(MouseEvent.CLICK, listItemClicked);
						temp.buttonMode = true;
						searchArray.push(temp);

						contaner.setChildIndex(searchResult, contaner.numChildren - 1);
					}

				}

			}
			else if (SearchBox.toSearch_txt.text.length <= 1) {
				removeSearhResults()
				for each (var value:* in dragListItems){
					value.visible = true;
				}
			}
		}

		private function removeSearhResults():void
		{

			for  (var k = 0 ; k < searchArray.length ; k++ ) {
				searchResult.removeChild( searchArray[k]);
				searchArray[k].removeEventListener(MouseEvent.CLICK, listItemClicked);
				searchArray[k] = null
			}
			searchArray = [];
			searchResult.visible = false;

		}

		function browse(e:Event){
			f.browse([new FileFilter("mp3 & cdg files","*.mp3;*.cdg")]);
			f.addEventListener(Event.SELECT , select);
		}
		function select(e:Event) {

			addSongs(f)

		}

		private function startListResize(e:MouseEvent):void
		{
			dragCorrn.removeEventListener(MouseEvent.MOUSE_DOWN, startListResize);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopListResize);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, resizeList);

		}

		private function resizeList(e:MouseEvent):void
		{
			if ( this.mouseX > 300 && this.mouseX < 1000) {

				dragCorrn.y = this.mouseY;
				masker.height = dragCorrn.y -37
				plBkg.height =  dragCorrn.y ;
				addBtn.y = plBkg.height - addBtn.height/2 - 10
				scrollBar.height = masker.height
				scrollBar.setScrollProperties(masker.height, 0, (contaner.height - masker.height))

				dragCorrn.x = this.mouseX;
				masker.width = dragCorrn.x -dragCorrn.width;
				plBkg.width =  dragCorrn.x ;
				plHeader.width = plBkg.width
				scrollBar.x = contaner.x + masker.width;
				scrollBar.setScrollProperties(masker.height, 0, (contaner.height - masker.height))

			}
			SearchBox.x = plBkg.x + plBkg.width - SearchBox.width - 10;

		}

		private function stopListResize(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizeList);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopListResize);
			dragCorrn.addEventListener(MouseEvent.MOUSE_DOWN, startListResize);
		}

		private function scrollMC(e:ScrollEvent):void
		{

			contaner.y = -e.position + masker.y;
		}

		function buildUpCoords():void {

			for (var i:int = 1; i <= listItems.length; i++) {
				var temp = new dragBox();
				temp.box.height = _cellHeight;
				temp.idx =  i - 1;
				items.push(temp);
				dragListItems.push(temp);
				temp.y = ((temp.height + interval) * i) -  temp.height;
				contaner.addChild(temp);
				coords.push({loc:new Point(items[i-1].x, items[i-1].y), owner:items[i-1], linkage:i});
			}

		}

		function initDraggables():void {

			for (var i:int =1; i <= listItems.length; i++) {

				items[i - 1].name_txt.text = listItems[i - 1];
				items[i - 1].cdgRef = "Piese/"+listItems[i - 1] + ".zip";
				items[i - 1].mp3Ref = "Piese/" + listItems[i - 1] + ".mp3";
				items[i - 1].name_txt.mouseEnabled = false;
				items[i-1].coordsLoc = coords[i-1];
				items[i-1].setIndex(items[i-1].coordsLoc.linkage);
				items[i-1].setCorrect(false);
				addListeners(items[i - 1].box);

			}

		}

		function addListeners(target:MovieClip):void {

			target.addEventListener(MouseEvent.MOUSE_DOWN, pressedF);

			target.addEventListener(MouseEvent.CLICK, listItemClicked);
			target.buttonMode = true;

		}
		public function addSongs(f:FileReferenceList) {

			for (var i = 0 ; i < f.fileList.length - 1; i++ ) {

				var s = f.fileList[i].name;
				s = s.slice(s.length -3, s.length);

				var s2 = f.fileList[i+1].name;
				s2 = s2.slice(s2.length -3, s2.length);
				if (s == "cdg" && s2 == "mp3" &&
				f.fileList[i].name.slice(0, f.fileList[i].name.length - 4) == f.fileList[i+1].name.slice(0, f.fileList[i+1].name.length - 4)
				)
				{
					var toIn = Number(items.length) ;
					var temp = new dragBox();
					temp.box.height = _cellHeight;
					temp.idx =  toIn ;

					temp.cdgRef = FileReference(f.fileList[i]);
					temp.mp3Ref = FileReference(f.fileList[i+1]);

					items.push(temp);

					temp.y = ((temp.height + interval) * (toIn) + interval) ;
					dragListItems.push(temp);
					contaner.addChild(temp);
					coords.push( { loc:new Point(temp.x, temp.y), owner:temp, linkage:toIn +1} );
					temp.name_txt.text = f.fileList[i].name;
					temp.name_txt.mouseEnabled = false;
					temp.coordsLoc = coords[toIn];
					temp.setIndex(items[toIn].coordsLoc.linkage);
					temp.setCorrect(false);
					addListeners(temp.box);
				}

			}

			scrollBar.setScrollProperties(masker.height, 0, (contaner.height-masker.height))
		}
		public function getNextSong() {
			if(lastClickedItem && coords.length > lastClickedItem.parent.coordsLoc.linkage ) {
				lastClickedItem.gotoAndStop(1);
				lastClickedItem = coords[lastClickedItem.parent.coordsLoc.linkage].owner.box ;
				lastClickedItem.gotoAndStop(2);
				dispatchEvent(new Event("SongClicked"));
			}
		}
		public function getPrevSong() {
			if(lastClickedItem &&  lastClickedItem.parent.coordsLoc.linkage-2 > 0) {
				lastClickedItem.gotoAndStop(1);
				lastClickedItem = coords[lastClickedItem.parent.coordsLoc.linkage-2].owner.box ;
				lastClickedItem.gotoAndStop(2);
				dispatchEvent(new Event("SongClicked"));
			}
		}

		public function playFirstSong()	{
			lastClickedItem = coords[0].owner.box ;
			lastClickedItem.gotoAndStop(2);
			dispatchEvent(new Event("SongClicked"));
		}

		private function remClick(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_MOVE, remClick);
			mouseMoved = true;

		}

		private function listItemClicked(e:MouseEvent):void
		{

			e.target.removeEventListener(MouseEvent.MOUSE_MOVE, remClick);
			if (!mouseMoved) {
				if(lastClickedItem) {
					lastClickedItem.gotoAndStop(1);
				}

				e.target.gotoAndStop(2);

				lastClickedItem  = e.target;

				dispatchEvent(new Event("SongClicked"));
			}
			mouseMoved = false
		}

		function removeListeners(target:MovieClip):void {

			target.removeEventListener(MouseEvent.MOUSE_DOWN, pressedF);
			target.buttonMode = false;

		}

		function pressedF(evt:MouseEvent):void {

			evt.target.addEventListener(MouseEvent.MOUSE_MOVE, remClick);
			selectedDraggable = evt.target.parent as MovieClip;

			if (Boolean(selectedDraggable.tweenX)) selectedDraggable.tweenX.stop();
			if (Boolean(selectedDraggable.tweenY)) selectedDraggable.tweenY.stop();

			selectedDraggable.parent.setChildIndex(selectedDraggable, selectedDraggable.parent.numChildren-1);

			selectedDraggable.startDrag(false);

			selectedDraggable.addEventListener(Event.ENTER_FRAME, dragDraggable);
			selectedDraggable.stage.addEventListener(MouseEvent.MOUSE_UP, releasedF);

		}

		function releasedF(evt:MouseEvent):void {

			selectedDraggable.removeEventListener(Event.ENTER_FRAME, dragDraggable);
			selectedDraggable.stage.removeEventListener(MouseEvent.MOUSE_UP, releasedF);

			selectedDraggable.stopDrag();

			checkIndexing();

			sendItem(selectedDraggable, coords[selectedDraggable.getIndex()-1].loc);

		}

		function dragDraggable(evt:Event):void {

			checkIndexing();

		}

		function checkIndexing():void {

			if (selectedDraggable.getIndex() > 1) {

				var checkable1:int = selectedDraggable.getIndex()-1;

				for (var i:int = selectedDraggable.coordsLoc.linkage - 2; i >= 0; i--) {

					if (!coords[i].owner.getCorrect()) {

						checkable1 = i;

						break;

					}

				}

				if (coords[checkable1].owner.y > selectedDraggable.y) {

					switchThem(checkable1 - selectedDraggable.coordsLoc.linkage + 1);

				}

			}

			if (selectedDraggable.getIndex() < items.length) {

				var checkable2:int = selectedDraggable.getIndex()-1;

				for (var j:int = selectedDraggable.coordsLoc.linkage; j < items.length; j++) {

					if (!coords[j].owner.getCorrect()) {

						checkable2 = j;;

						break;

					}

				}

				if (coords[checkable2].owner.y < selectedDraggable.y) {

					switchThem(checkable2 - selectedDraggable.coordsLoc.linkage + 1);

				}

			}

		}

		function switchThem(dir:int):void {

			var selectedLoc:Object = coords[selectedDraggable.coordsLoc.linkage-1];
			var targetLoc:Object = coords[selectedDraggable.coordsLoc.linkage-1 + dir];

			targetLoc.owner.coordsLoc = selectedLoc;
			selectedLoc.owner.coordsLoc = targetLoc;

			selectedLoc.owner = targetLoc.owner;
			targetLoc.owner = selectedDraggable;

			selectedLoc.owner.setIndex(selectedLoc.owner.coordsLoc.linkage);
			selectedDraggable.setIndex(selectedDraggable.coordsLoc.linkage);

			sendItem(selectedLoc.owner, selectedLoc.loc);

		}

		function sendItem(target:MovieClip, dest:Point, speed:Number = .3):void {

			if (Boolean(target.tweenX)) target.tweenX.stop();
			if (Boolean(target.tweenY)) target.tweenY.stop();

			target.tweenX = new Tween(target, "x", Strong.easeOut, target.x, dest.x, speed, true);
			target.tweenY = new Tween(target, "y", Strong.easeOut, target.y, dest.y, speed, true);

		}

		function checkPlaces(evt:Event):void {

			tryNr++;

			var correct:Boolean = true;

			for (var k:uint = 1; k <= listItems.length; k++) {

				this["feedback_" + k].y = this["dragBox_" + k].y - this["feedback_" + k].height/2 - 5;

				removeListeners(this["dragBox_" + k].box);

				if (this["dragBox_" + k].getIndex() == this["dragBox_" + k].currentFrame) {

					this["dragBox_" + k].setCorrect(true);

					this["feedback_" + k].setCorrect();

				} else {

					this["feedback_" + k].setIncorrect();

					correct = false;

				}

			}

		}

		function tryAgain(evt:Event):void {

			for (var i:int = 1; i <= listItems.length; i++) {

				if (!items[i-1].getCorrect()) {

					addListeners(items[i-1].box);
					this["feedback_" + i].reset();

				}

			}

		}

		function showCorrect(evt:Event):void {

			for (var i:int = 1; i <= listItems.length; i++) {

				removeListeners(items[i-1].box);

				for (var j:int = 1; j <= listItems.length; j++) {

					if (this["dragBox_" + j].currentFrame == i) {

						sendItem(this["dragBox_" + j], coords[i-1].loc, 1);

					}

				}

				this["feedback_" + i].reset();

			}

		}

	}
}