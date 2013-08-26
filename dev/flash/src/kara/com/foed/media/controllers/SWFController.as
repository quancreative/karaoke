
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
	import flash.utils.ByteArray;
	import flash.net.URLStream;
	import flash.utils.Endian;

	import com.foed.events.MediaEvent;

	public class SWFController extends MediaController {
		public  var UseBackground:Boolean  = true;
			
		private var _SWFLoader_ld:Loader;
		private var _SWFHolder_sp:Sprite;
		private var _frameRade:int = 30;
		private var stream:URLStream;
		private var fun:Sprite;
		private var _hexBackgroundColor:Number;


		private function onLoadInit(pEvent:Event):void {
			fun = new Sprite();
			_SWFHolder_sp.addChild(fun);
			_SWFHolder_sp.addChild(_SWFLoader_ld.content);
			
			mediaDuration = getContent().totalFrames *  _frameRade;
	
			startMedia();
			_SWFHolder_sp.visible = true;
	
			dispatchEvent(new MediaEvent(MediaEvent.METADATA, mediaPosition, mediaDuration, _SWFLoader_ld.contentLoaderInfo.width, _SWFLoader_ld.contentLoaderInfo.height));
			dispatchEvent(pEvent);
		}
		
		private function onLoadComplete(pEvent:Event):void {
			
			dispatchEvent(pEvent);
			if(UseBackground) {
			stream = new URLStream();
			  
			stream.load(new URLRequest(mediaFile));
			stream.addEventListener(Event.COMPLETE, onComplete);
			}
			  
			  
		}
		private function onComplete(e:Event):void {
			  var bytes:ByteArray = new ByteArray();
			  bytes.endian = Endian.LITTLE_ENDIAN;
			  stream.readBytes(bytes, 0, 8);
			  var sig:String = bytes.readUTFBytes(3);
			  trace("SIG = " + sig);
			  trace("ver = " + bytes.readByte());
			  trace("size = " + bytes.readUnsignedInt());
			  var compBytes:ByteArray = new ByteArray();
			  compBytes.endian = Endian.LITTLE_ENDIAN;
			  stream.readBytes(compBytes);
			  if (sig == "CWS") {
				compBytes.uncompress();
			  }
			  var fbyte = compBytes.readUnsignedByte();
			  var rect_bitlength = fbyte >> 3;
			  var total_bits = rect_bitlength * 4;
			  var next_bytes =  Math.ceil((total_bits - 3)/ 8);
			  for(var i=0; i<next_bytes; i++) {
				compBytes.readUnsignedByte();
			  }
			  trace("frameRate = " + compBytes.readUnsignedShort());
			  trace("frameCount = " + compBytes.readUnsignedShort());


		  while (true) {
			  
			var tagcodelen:Number = compBytes.readUnsignedShort();
			var tagcode:Number = tagcodelen >> 6;
			var taglen:Number = tagcodelen & 0x3F;
			trace("tag code = " + tagcode + "\tlen = " + taglen);
			if (taglen >=63) {
			  taglen = compBytes.readUnsignedInt();
			}
			if(tagcode == 9) {
			  trace("found background color");
			  //trace("color is: RED=" + compBytes.readUnsignedByte() +", GREEN = " + compBytes.readUnsignedByte() + ", BLUE = " + compBytes.readUnsignedByte());
			  _hexBackgroundColor = RGBToHex(compBytes.readUnsignedByte(), compBytes.readUnsignedByte(), compBytes.readUnsignedByte());
				fun.graphics.beginFill(_hexBackgroundColor, 1);
				fun.graphics.drawRect(0, 0 , _SWFLoader_ld.contentLoaderInfo.width, _SWFLoader_ld.contentLoaderInfo.height);
			  
			  break;
			}
			compBytes.readBytes(new ByteArray(), 0, taglen);
					
		  }
		}
		
		private function RGBToHex (r, g, b ){
				var hex = r << 16 ^ g << 8 ^ b;
			   return hex;
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
			return _SWFLoader_ld.content as MovieClip;
		}
	
		override protected function applySoundTransform():void {
			_SWFHolder_sp.soundTransform = getSoundTransform();
		}

		override protected function trackProgress(pEvent:Event):void {
			if (mediaPosition == mediaDuration) {
				stopMedia();
				getContent().gotoAndStop(mediaDuration);
				dispatchEvent(new MediaEvent(MediaEvent.COMPLETE, mediaPosition, mediaDuration));
			}
			super.trackProgress(pEvent);
		}
	
		
		override protected function startTrackProgress(pStart:Boolean):void {
			if (pStart) {
				
				dispatchEvent(new MediaEvent(MediaEvent.START, mediaPosition, mediaDuration));
				_SWFHolder_sp.addEventListener(Event.ENTER_FRAME, trackProgress, false, 0, true);
			} else {
				dispatchEvent(new MediaEvent(MediaEvent.STOP, mediaPosition, mediaDuration));
				_SWFHolder_sp.removeEventListener(Event.ENTER_FRAME, trackProgress);
			}
		}
	
		override public function loadMedia(pFileURL:String, localFile:Object = undefined):void {
			if(!localFile) {
				super.loadMedia(pFileURL);
				_SWFHolder_sp = new Sprite();
				_SWFLoader_ld = new Loader();
				var pLoaderInfo:LoaderInfo = _SWFLoader_ld.contentLoaderInfo;
				pLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
				pLoaderInfo.addEventListener(Event.INIT, onLoadInit, false, 0, true);
				pLoaderInfo.addEventListener(Event.OPEN, onLoadStart, false, 0, true);
				pLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
				pLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
			
				
				
				applySoundTransform();
				_SWFHolder_sp.visible = false;
				try {
					_SWFLoader_ld.load(new URLRequest(mediaFile));
					dispatchEvent(new MediaEvent(MediaEvent.LOAD));
				} catch (e:Error) { }
			}
			else {
				trace ("local file")
				}
			
		
		}
	
		override public function startMedia():void {
			
			super.startMedia();
			getContent().play();
		} 
	
		
		override public function seek(pOffset:Number):void {
		
			pOffset = Math.round(pOffset*mediaDuration);
			if (playing) {
				getContent().gotoAndPlay(pOffset-1);
			} else {
				getContent().gotoAndStop(pOffset);
			}
			super.seek(pOffset);
		} 
	
		
		override public function stopMedia():void {

			
			super.stopMedia();
			
		} 
	
		override public function goToBegining(){
			stopMedia();
			getContent().gotoAndStop(1);
			
			super.goToBegining();
			
			}
		
			
		override public function pauseMedia(pPause:Boolean):void {
			super.pauseMedia(pPause);
			if (paused) {
				super.stopMedia();
				getContent().stop();
			} else {
				startMedia();
			}
			startTrackProgress(!paused);
		} 

		
		override public function get mediaPosition():Number {
			return getContent().currentFrame *_frameRade;
		}
	
	 
		override public function get media():Object { return _SWFHolder_sp; }

	}
	
}