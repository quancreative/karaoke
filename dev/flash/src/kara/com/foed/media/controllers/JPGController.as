
package com.foed.media.controllers {

	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.errors.IOError;
	import flash.display.Bitmap;

	import com.foed.events.MediaEvent;

	public class JPGController extends MediaController {
		
		
		
		private var _IMGLoader_ld:Loader;
		private var _IMGHolder_sp:Sprite;
		public var UseDynamicLoad:Boolean = true;
		private var proLo:LoadProgressive = new LoadProgressive();
	
		private function onLoadInit(pEvent:Event):void {
			
			mediaDuration = 0;
			startMedia();
		 
			_IMGHolder_sp.visible = true;
			dispatchEvent(new MediaEvent(MediaEvent.METADATA, mediaPosition, mediaDuration, _IMGHolder_sp.width, _IMGHolder_sp.height));
			dispatchEvent(pEvent);
			
		}
		
		
	
	
		private function onLoadComplete(pEvent:Event):void {
			//_IMGHolder_sp.getChildAt(0).content.smoothing =true
			dispatchEvent(pEvent);
		}
	
	
		private function onLoadError(pEvent:Event):void {
			dispatchEvent(pEvent);
		}
	
		
		private function onLoadStart(pEvent:Event):void {
			dispatchEvent(pEvent);
		}
	
	
		private function onLoadProgress(pEvent:Event):void {
			dispatchEvent(pEvent);
		}
		
	
		private function getContent():MovieClip {
			return _IMGLoader_ld.content as MovieClip;
		}
	
				
		override protected function applySoundTransform():void {
		
		}
	
		override protected function trackProgress(pEvent:Event):void {
			
		}
	
		
		override protected function startTrackProgress(pStart:Boolean):void {
			
		}
	
			
		override public function loadMedia(pFileURL:String, localFile:Object = undefined):void {
			
			
			if (!localFile) {
				
				  if (UseDynamicLoad) {
    
							super.loadMedia(pFileURL);
							_IMGHolder_sp = new Sprite();				
							_IMGLoader_ld = proLo.loader;		
							proLo.addEventListener("image_load_completed", onLoadComplete, false, 0, true);
							proLo.addEventListener("image_load_init", onLoadInit, false, 0, true);
							proLo.imageStream.addEventListener(Event.OPEN, onLoadStart, false, 0, true);
							proLo.imageStream.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
							proLo.imageStream.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
							_IMGHolder_sp.addChild(_IMGLoader_ld);	   
							_IMGHolder_sp.visible = false;
							proLo.loadImage(pFileURL);
							dispatchEvent(new MediaEvent(MediaEvent.LOAD));
				  }
				  
				  else {
					    
					    super.loadMedia(pFileURL);
						_IMGHolder_sp = new Sprite();
						_IMGLoader_ld = new Loader();
						var pLoaderInfo:LoaderInfo = _IMGLoader_ld.contentLoaderInfo;
						pLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
						pLoaderInfo.addEventListener(Event.INIT, onLoadInit, false, 0, true);
						pLoaderInfo.addEventListener(Event.OPEN, onLoadStart, false, 0, true);
						pLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
						pLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
						_IMGHolder_sp.addChild(_IMGLoader_ld);
					   
						_IMGHolder_sp.visible = false;
						try {
							_IMGLoader_ld.load(new URLRequest(mediaFile));
							dispatchEvent(new MediaEvent(MediaEvent.LOAD));
						} catch (e:Error) { }
 
					  
					  }
			
			
				
			}
			else {
				
				_IMGHolder_sp = new Sprite();
				_IMGLoader_ld2 = new Sprite();
				_IMGLoader_ld2.addChild(localFile);
				_IMGHolder_sp.addChild(_IMGLoader_ld2);
				dispatchEvent(new MediaEvent(MediaEvent.LOAD));
				dispatchEvent(new MediaEvent(MediaEvent.METADATA, mediaPosition, mediaDuration, _IMGHolder_sp.width, _IMGHolder_sp.height));	
			
				}
				
				
			
				
		}
	
		
		override public function startMedia():void {
			super.startMedia();
			
		} 
	
	
		override public function seek(pOffset:Number):void {
		} 
	
		
		override public function stopMedia():void {
			
			super.stopMedia();
		} 
	
		
		override public function pauseMedia(pPause:Boolean):void {
			super.pauseMedia(pPause);
			if (paused) {
				super.stopMedia();
				
			} else {
				startMedia();
			}
			startTrackProgress(!paused);
		} 

			
		override public function get mediaPosition():Number {
			
		}
			
		override public function get media():Object { return _IMGHolder_sp; }

	}
	
}