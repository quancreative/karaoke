/**
* @description  Class to handle display of loaded FLVs.
*/
package com.foed.media.displays {

	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetStream;

	import com.foed.events.MediaEvent;
	import com.foed.media.controllers.MediaController;
	
	public class FLVDisplay extends MediaDisplay {
	

		private function attachNetStream(pEvent:MediaEvent):void {
			createMediaClip();
			Video(_mediaClip).attachNetStream(NetStream(getController().media));
			Video(_mediaClip).smoothing = true;
			addEventListener(Event.ENTER_FRAME, checkVideoSize, false, 0, true);
		}

	
		private function checkVideoSize(pEvent:Event):void {
			if (_mediaClip.width > 0) {
				removeEventListener(Event.ENTER_FRAME, checkVideoSize);
				_mediaWidth = _mediaClip.width;
				_mediaHeight = _mediaClip.height;
				sizeMedia();
			}
		}


		override protected function createMediaClip():void {
			super.createMediaClip();
			_mediaClip = addChild(new Video());
		}

		
		override public function setController(pController:MediaController):void {
			super.setController(pController);
			getController().addEventListener(MediaEvent.LOAD, attachNetStream, false, 0, true);
			getController().addEventListener(MediaEvent.METADATA, setMetadata, false, 0, true);
		}

	}
	
}