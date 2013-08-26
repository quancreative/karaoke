package com.foed.media.displays {

	import flash.display.Sprite;

	import com.foed.media.controllers.MediaController;
	import com.foed.events.MediaEvent;

	public class JPGDisplay extends MediaDisplay {
		

		private function attachSWFLoader(pEvent:MediaEvent):void {
			createMediaClip();
			Sprite(_mediaClip).addChild(Sprite(getController().media));
		}

		
		override protected function createMediaClip():void {
			super.createMediaClip();
			_mediaClip = addChild(new Sprite());
		
			
		}
	
		
		override public function setController(pController:MediaController):void {
			super.setController(pController);
			getController().addEventListener(MediaEvent.LOAD, attachSWFLoader, false, 0, true);
			getController().addEventListener(MediaEvent.METADATA, setMetadata, false, 0, true);
		}

	}
	
}