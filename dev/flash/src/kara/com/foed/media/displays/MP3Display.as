package com.foed.media.displays {

	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.foed.events.MediaEvent;
	import com.foed.media.controllers.MediaController;
	import com.foed.media.controllers.MP3Controller;
	import com.anttikupila.revolt.Revolt;
	
	public class MP3Display extends MediaDisplay {
		
		private var revolt;		

		private function visualizeSound(e:MediaEvent):void {
		
		
		}
		private function initVizualizer(e:MediaEvent) {
			
			
			if ( revolt == null) {
				createMediaClip();
				
						
				revolt = new Revolt(displayWidth/2, displayHeight/2);
				revolt.width = displayWidth;
				revolt.height = displayHeight;
				addEventListener("resizeDisplay", resizeVisualizer);
				Sprite(_mediaClip).addChild(revolt);
			}
		

			}
			
		private function resizeVisualizer(e:Event):void 
			{
			
			_mediaClip.x = 0;
			_mediaClip.y = 0;
			revolt.width = e.width;
			revolt.height = e.height;
			}
	
		override protected function createMediaClip():void {

			super.createMediaClip();

			_mediaClip = addChild(new Sprite());
		}
	
		
		override public function setController(pController:MediaController):void {
			super.setController(pController);
			getController().addEventListener(MediaEvent.PROGRESS, visualizeSound, false, 0, true);
			getController().addEventListener(MediaEvent.START, initVizualizer, false, 0, true);
		}
		
		
		override public function die ():void {
		      revolt.die();
			 
		      Sprite(_mediaClip).removeChild(revolt);
			  super.die();
			
			  revolt = null;
	  
			}

	}
	
}