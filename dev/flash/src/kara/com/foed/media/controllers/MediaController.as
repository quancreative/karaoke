
package com.foed.media.controllers {

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.media.SoundTransform;

	import com.foed.events.MediaEvent;
	import com.foed.media.IAudible;
	import com.foed.media.IPlayable;
	
	public class MediaController extends EventDispatcher implements IAudible, IPlayable {
	
		private var _mediaFile:String;
		private var _mediaDuration:Number;
		private var _playing:Boolean;
		private var _paused:Boolean;
		private var _volume:Number;
		private var _pan:Number;
		private var _progressTimer:Timer;
		
		public var _stopped:Boolean;

		private var _progressInterval:Number = 40;
		
		
		public function MediaController() {
			init();
		}
	
		
		protected function init():void {
			
			_volume = 1;
			_pan = 0;
			_paused = false;
			_playing = false;
			_progressTimer = new Timer(_progressInterval, 0);
		}
	
	
		protected function startTrackProgress(pStart:Boolean):void {
			if (pStart) {
				dispatchEvent(new MediaEvent(MediaEvent.START, mediaPosition, mediaDuration));
				_progressTimer.addEventListener(TimerEvent.TIMER, trackProgress, false, 0, true);
				_progressTimer.start();
			} else {
				dispatchEvent(new MediaEvent(MediaEvent.STOP, mediaPosition, mediaDuration));
				_progressTimer.removeEventListener(TimerEvent.TIMER, trackProgress);
				_progressTimer.stop();
			}
		}
	
	
		protected function trackProgress(pEvent:Event):void {
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, mediaPosition, mediaDuration));
		}
		
			
		protected function applySoundTransform():void {}
		
		public function loadMedia(pFileURL:String, localFile:Object=undefined):void {
			_mediaFile = pFileURL;
			_playing = false;
			_paused = false;
		}
		
		public function startMedia():void {
			_playing = true;
			setVolume(_volume);
			setPan(_pan);
			startTrackProgress(true);
		} 
	
		
		public function seek(pOffset:Number):void {
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, mediaPosition, mediaDuration));
		}
			
		public function stopMedia():void {
			_playing = false;
			
			startTrackProgress(false);
		} 
		public function goToBegining() {
			_paused = true;
			dispatchEvent(new MediaEvent(MediaEvent.PROGRESS, 0, mediaDuration));
			
			}
	
			
		public function pauseMedia(pPause:Boolean):void {
			_playing = !pPause;
			_paused = pPause;
			startTrackProgress(!pPause);
		} 
		
		public function die():void {
			stopMedia();
		}
	
		
		public function get mediaFile():String { return _mediaFile; }
		
		
		public function get mediaPosition():Number { return 0; }

		
		public function set mediaPosition(pPosition:Number):void {}

		
		public function get mediaDuration():Number { return _mediaDuration; }

		public function set mediaDuration(pDuration:Number):void { _mediaDuration = pDuration; }

		
		public function get paused():Boolean { return _paused; }
	
			
		public function get playing():Boolean { return _playing; }
	
			
		public function getSoundTransform():SoundTransform {
			return new SoundTransform(_volume, _pan);
		} 

			
		public function setSoundTransform(pSoundTransform:SoundTransform):void {
			_volume = pSoundTransform.volume;
			_pan = pSoundTransform.pan;
			applySoundTransform();
		}

			
		public function getVolume():Number { return _volume; } 

			
		public function setVolume(pVolume:Number):void {
			_volume = pVolume;
			applySoundTransform();
		}  

		
		public function get volume():Number { return getVolume(); } 

		
		public function set volume(pVolume:Number):void { setVolume(pVolume); } 
	
		
		public function getPan():Number { return _pan; }

		
		public function setPan(pPan:Number):void {
			_pan = pPan;
			applySoundTransform();
		} 

		
		public function get pan():Number { return getPan(); } 

		public function set pan(pPan:Number):void { setPan(pPan); } 
	
		public function get media():Object { return null; }

	}
	
}