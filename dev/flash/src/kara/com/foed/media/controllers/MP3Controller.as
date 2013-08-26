
package com.foed.media.controllers {

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.media.ID3Info;
	
	import com.foed.events.MediaEvent;
	import com.foed.sound.Sound;
	import com.foed.sound.Sound;
	
	public class MP3Controller extends MediaController {
	
		private var _savedTime:Number;
		private static var _sound:Sound;
		private var _soundEnded:Boolean;
	
		private static var _soundChannel:SoundChannel;
		private var _spectrumData:ByteArray;		

		override protected function init():void {
			super.init();
			_spectrumData = new ByteArray();
			
		}

	
		private function onSoundComplete(pEvent:Event):void {
			stopMediaPause();
			pauseMedia(true);
			_soundEnded = true;
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, mediaDuration, mediaDuration));
			dispatchEvent(new MediaEvent(MediaEvent.COMPLETE, mediaPosition, mediaDuration));
		}
	
		private function onSoundLoaded(pEvent:Event):void {
			mediaDuration = _sound.length;
			dispatchEvent(pEvent);
		}
		
		private function onLoadError(pEvent:Event):void {
			dispatchEvent(pEvent);
		}
		
	
		private function onLoadProgress(pEvent:Event):void {
			
			if (_sound && _sound.length > 0)
				{
					mediaDuration = (_sound.bytesTotal / (_sound.bytesLoaded / _sound.length)) ;
				}
			dispatchEvent(pEvent);
		}
		
	
		private function playSound(pStartTime:Number):void {

			_soundChannel = _sound.play(pStartTime, 0, getSoundTransform());
			_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
		}
		
		
		override protected function applySoundTransform():void {
			_soundChannel.soundTransform = getSoundTransform();
		}
		
	
		override public function loadMedia(pFileURL:String, localFile:Object = undefined):void {
			if(!localFile) {
				if (_sound) {
					die();
					
					}
				super.loadMedia(pFileURL);
				_sound = new Sound();
				_sound.addEventListener(Event.COMPLETE, onSoundLoaded, false, 0, true);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
				_sound.addEventListener(ProgressEvent.PROGRESS, onLoadProgress, false, 0, true);
			    _sound.addEventListener(Event.ID3, traceID3);
				try {
					_sound.load(new URLRequest(mediaFile));
					startMedia();
				} catch (e:Error) { }
			
			}
			
			else {
					
					if (_sound) {
							die();
							}
				    super.loadMedia(pFileURL);
					
					_sound = localFile;
					startMedia();
					
					mediaDuration = _sound.length;
					
					
					 dispatchEvent (new Event ("complete"))
			
				 
					
			}
			
		}
		public function traceID3(e:Event = null) {
			
		
			}
	
		override public function startMedia():void {
			playSound(0);
			super.startMedia();
		} 
	
	
		override public function seek(pOffset:Number):void {
			
		    if (pOffset == 1) {
				
				onSoundComplete(null);	
			}
			stopMediaPause();
			if (paused) {
				_savedTime = pOffset*mediaDuration;
			} else {
			
				super.startMedia();
				playSound(pOffset*mediaDuration);
			}
			super.seek(pOffset * mediaDuration);
			
		} 
	
		override public function stopMedia():void {
			
			pauseMedia(true);
			_soundChannel.stop();
			_savedTime = 0;
			seek(0)
			
			super.stopMedia();
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, 0, mediaDuration));
			trace("STOP SOUND")
			
		} 
	
		public function stopMediaPause():void {
			super.stopMedia();
			_soundChannel.stop();
			
		} 
		
		override public function goToBegining(){
			stopMedia();
			
			super.goToBegining();
			
			}
		
		override public function pauseMedia(pPause:Boolean):void {
			super.pauseMedia(pPause);
			if (paused) {
				
				_savedTime = _soundChannel.position;
				
				stopMediaPause();
			} else {
				
				super.startMedia();
				
				playSound(_savedTime);
			}
		} 
	
		override public function die():void {
			super.die();
			if (_sound != null) {
				try {
					_sound.close();
				} catch (e:Error) {}
			}
		}
		
		
		override public function get mediaPosition():Number {
			if (paused) {
				return _savedTime;
			} else {
				return _soundChannel.position;
			}
		}

	
		public function _pause(e:Event=null) {
			trace(_sound.paused)
			
			}
		public function getSoundSpectrum(pFFTMode:Boolean = true, pStretchFactor:int = 0):ByteArray {
			
			SoundMixer.computeSpectrum(_spectrumData, pFFTMode, pStretchFactor);;
			return _spectrumData;
		}
		
	
		override public function get media():Object { return _sound; }

	}
	
}