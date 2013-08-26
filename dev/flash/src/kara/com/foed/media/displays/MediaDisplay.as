
package com.foed.media.displays {

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import com.foed.events.MediaEvent;
	import com.foed.media.controllers.MediaController;

	public class MediaDisplay extends Sprite {
		
		
		
		private var _mediaController:MediaController;
		private var _scaleMode:String = ScaleModes.SHOW_ALL;
		private var _displayWidth:Number;
		private var _displayHeight:Number;
		protected var _mediaClip:DisplayObject;
		protected var _mediaWidth:Number;
		protected var _mediaHeight:Number;
		
		private var t:TextField = new TextField();
	
	
		public function MediaDisplay() {
			
			init();
		}
	
	
		private function init():void {
			createMediaClip();
		}

	
		public function scaleMedia():void {
			var pRatio:Number;
			if (_displayWidth > _displayHeight) {
				pRatio = _displayHeight/_mediaHeight;
				if (_mediaHeight < _mediaWidth && _mediaWidth*pRatio > _displayWidth) {
					pRatio = _displayWidth/_mediaWidth;
				}
			} else {
				pRatio = _displayWidth/_mediaWidth;
				if (_mediaWidth < _mediaHeight && _mediaHeight*pRatio > _displayHeight) {
					pRatio = _displayHeight/_mediaHeight;
				}
			}
			_mediaClip.width = _mediaWidth*pRatio;
			_mediaClip.height = _mediaHeight * pRatio;
			
			positionMedia();
			dispatchEvent(new MediaEvent(MediaEvent.RESIZE , 0 , 0, _displayWidth, _displayHeight));
		}

	
		private function positionMedia():void {
			_mediaClip.x = (_displayWidth - _mediaClip.width)/2;
			_mediaClip.y = (_displayHeight - _mediaClip.height)/2;
		}

	
		public function sizeMedia():void {
			
			_mediaClip.scrollRect = _mediaClip.getRect(_mediaClip);
			switch (_scaleMode) {
				case ScaleModes.EXACT_FIT:
					_mediaClip.width = _displayWidth;
					_mediaClip.height = _displayHeight;
					break;
				case ScaleModes.NO_SCALE:
					positionMedia();
					if (_mediaWidth > _displayWidth || _mediaHeight > _displayHeight) {
						_mediaClip.scrollRect = new Rectangle(0, 0, _displayWidth, _displayHeight);
					}
					break;
				case ScaleModes.SCALE_DOWN:
					if (_mediaWidth > _displayWidth || _mediaHeight > _displayHeight) {
						scaleMedia();
					} else {
						positionMedia();
					}
					break;
				case ScaleModes.SHOW_ALL:
					scaleMedia();
					break;
			}
		}

	
		protected function createMediaClip():void {
			if (_mediaClip != null) removeChildAt(0);
		}
	
	
		protected function setMetadata(pEvent:MediaEvent):void {
			if (pEvent.width > 0 && pEvent.height > 0) {
				_mediaWidth = pEvent.width;
				_mediaHeight = pEvent.height;
				sizeMedia();
			}
		}


		public function getController():MediaController { return _mediaController; }	


		public function setController(pController:MediaController):void { _mediaController = pController; }
	
		
		public function die():void {
			
			removeChildAt(0);
			_mediaClip = null;
			
		}

		public function get scaleMode():String { return _scaleMode; }	
	
		public function set scaleMode(pMode:String):void {
			_scaleMode = pMode;
			sizeMedia();
		}

	
		public function get mediaWidth():Number { return _mediaWidth; }


		public function get mediaHeight():Number { return _mediaHeight; }

	
		public function get displayWidth():Number { return _displayWidth; }

	
		public function set displayWidth(pWidth:Number):void { _displayWidth = pWidth; }

		
		public function get displayHeight():Number { return _displayHeight; }

	
		public function set displayHeight(pHeight:Number):void { _displayHeight = pHeight; }

	}
	
}