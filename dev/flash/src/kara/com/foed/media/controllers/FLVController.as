/**
* @description  Class handles loading and playback of progressive FLV files.
*/
package com.foed.media.controllers {

	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import com.foed.events.MediaEvent;
	
	public class FLVController extends MediaController {
	
		private var _stream_ns:NetStream;
		private var _connection_nc:NetConnection;
		
		private var _pauseTimer:Timer;
		private var _loadTimer:Timer;
		private var _savedTime:Number;
		
		
		private function onNetStatus(pEvent:NetStatusEvent):void {
			
			switch (pEvent.info.level) {
				case "error":
				    trace("yep it`s an error");

					break;
				case "status":
					switch (pEvent.info.code) {
						case "NetStream.Play.Start":
							dispatchEvent(new Event(Event.INIT));
							break;
						case "NetStream.Play.Stop":
						    trace("NetStream.Play.Stop");
							dispatchEvent(new MediaEvent(MediaEvent.COMPLETE, mediaPosition, mediaDuration));
							_videoEnded = true;
							break;
						case  "":
						  	trace("net streem error");
							break;
					}
					break;
			}
		}


		private function assessLoad(pEvent:TimerEvent):void {
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _stream_ns.bytesLoaded, _stream_ns.bytesTotal));
			if (_stream_ns.bytesLoaded == _stream_ns.bytesTotal) {
				dispatchEvent(new Event(Event.COMPLETE));
				_loadTimer.removeEventListener(TimerEvent.TIMER, assessLoad);
				_loadTimer.stop();
				
			}
		}

		
		override protected function trackProgress(pEvent:Event):void {
			if (mediaPosition == mediaDuration) {
				_videoEnded = true;		
				dispatchEvent(new MediaEvent(MediaEvent.COMPLETE, mediaPosition, mediaDuration));
				startTrackProgress(false);
			}
			super.trackProgress(pEvent);
		}

		
		override protected function applySoundTransform():void {
				_stream_ns.soundTransform = getSoundTransform();
		}

		
		override public function loadMedia(pFileURL:String, localFile:Object=undefined):void {
			super.loadMedia(pFileURL);
			_connection_nc = new NetConnection();
			try {
				_connection_nc.connect(null);
				_stream_ns = new NetStream(_connection_nc);
				_stream_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
				
				_stream_ns.client = this;
				applySoundTransform();
				dispatchEvent(new MediaEvent(MediaEvent.LOAD));
				startMedia();
			} catch (e:Error) {}
		}
	
	
		override public function startMedia():void {
			_videoEnded = false;
			if (paused) {
				_stream_ns.resume();
			} else {
				try {
					_stream_ns.play(mediaFile);
					if (_stream_ns.bytesLoaded != _stream_ns.bytesTotal && _stream_ns.bytesTotal > 0) {
						_loadTimer = new Timer(50, 0);
						_loadTimer.addEventListener(TimerEvent.TIMER, assessLoad, false, 0, true);
						_loadTimer.start();
					} 
				} catch (e:Error) {}
			}
			super.startMedia();
		} 
	

		override public function seek(pOffset:Number):void {
		if (_videoEnded) {
			startMedia();
			_stream_ns.pause();
			pauseMedia(true);
			}

			
			var pTime:int = pOffset * mediaDuration/1000;
		
			_stream_ns.seek(Math.floor(pTime));
			
			
			
			
				
			
			_savedTime = pTime;
			
			super.seek(pTime);
		}
	
	
		override public function stopMedia():void {
		
			_stream_ns.seek(0);
			_stream_ns.pause();
			pauseMedia(true);
			super.stopMedia();
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, 0, mediaDuration));
		} 
	
		
		override public function goToBegining(){
			stopMedia();
			
			super.goToBegining();
			
			}
		
		override public function pauseMedia(pPause:Boolean):void {
			if (pPause) {
				_stream_ns.pause();
			} else {
				if (!playing) _stream_ns.resume();
			}
			super.pauseMedia(pPause);
		}
	
	
		override public function die():void {
			super.die();
			_stream_ns.close();
			_connection_nc.close();
			if (_loadTimer.running) _loadTimer.stop();
		}


		public function onCuePoint(pData:Object):void {}
		public function onLastSecond(pData:Object):void { trace("last sec") }
		public function onXMPData(pData:Object){ trace("XMPData") }
		public function onMetaData(pData:Object):void {
			
			if (pData.duration > 0) {
				mediaDuration = pData.duration * 1000;
				}
			dispatchEvent(new MediaEvent(MediaEvent.METADATA, mediaPosition, mediaDuration, pData.width, pData.height));
		}
		
		
		override public function get mediaPosition():Number {
			//if (paused) return _savedTime * 1000;
			return _stream_ns.time  * 1000; 
			}
	   
		
		override public function get media():Object { return _stream_ns; }

	}
	
}