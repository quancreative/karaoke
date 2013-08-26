package com.noteflight.standingwave2.output
{
    import com.noteflight.standingwave2.elements.IAudioSource;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.utils.ByteArray;
    
    /** Dispatched when the currently playing sound has completed. */
    [Event(type="flash.events.Event",name="complete")]
    
    /**
     * An AudioPlayer streams samples from an IAudioSource to a Sound object using a
     * SampleDataEvent listener.  It does so using a preset number of frames per callback,
     * and continues streaming the output until it is stopped, or until there is no more
     * audio output obtainable from the IAudioSource.
     */
    public class AudioPlayer extends EventDispatcher
    {

        // The sound being output
        private var _sound:Sound;
        
        // The SoundChannel that the output is playing through
        private var _channel:SoundChannel;
 
        // The delegate that handles the actual provision of the samples
        private var _sampleHandler:AudioSampleHandler;
		
		public var tb:Array = new Array();
		public var recordedBytes:ByteArray = new ByteArray();
		public var id = 1;
		public var id2 = 0;
		public var e:ByteArray = new ByteArray();
		public var timer:Timer = new Timer(1, 0);
		
        /**
         * Construct a new AudioPlayer instance. 
         * @param framesPerCallback the number of frames that this AudioPlayer will
         * obtain for playback on each SampleDataEvent emitted by the playback Sound object.
         */
        public function AudioPlayer(framesPerCallback:Number = 4096)
        {
            _sampleHandler = new AudioSampleHandler(framesPerCallback); 
            _sampleHandler.addEventListener(Event.COMPLETE, handleComplete);
			timer.addEventListener(TimerEvent.TIMER , parseSound);
        }
        
        /**
         * Play an audio source through this output.  Only one source may be played at a time.
         * @param source an IAudioSource instance
         */
		 public function playByteArray() {
			 
			  if (_sound != null || recordedBytes.length == 0)
				{
					return;
				}
			recordedBytes.position = 0;
            _sound = new Sound();
			 _sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
			 
            _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playFromByte);
            _channel = _sound.play();
            _sampleHandler.channel = _channel;
			
			trace("PLAY BYTE ARRAY")
			
			 }
			 
		 private function playFromByte(e:SampleDataEvent):void 
			 {

				 for (var j:int = 0; j < 32768; ++j) {
					e.data.writeByte(recordedBytes.readByte()) 
				
				}
			 }
        public function play(source:IAudioSource):void
        {
            stop();
            _sampleHandler.source = source;
            _sampleHandler.sourceStarted = false;
            startSound();
        }
		 public function save(source:IAudioSource):void
        {
            stop();
            _sampleHandler.source = source;
            _sampleHandler.sourceStarted = false;
			 if (_sound != null)
            {
                return;
            }
            handleSave();
        }
        
        /**
         * Stop a given source (if supplied), or stop any source that is playing (if no source
         * parameter is supplied). 
         * 
         * @param source an optional IAudioSource instance
         */
        public function stop(source:IAudioSource = null):void
        {
            if (source == null || source == _sampleHandler.source)
            {
                _sampleHandler.source = null;
                _sampleHandler.channel = null;
                if (_channel)
                {
                    _channel.stop();
                    _channel = null;
                }
                _sound = null;
            }
        }
        
        /**
         * The source currently being played by this object, or null if there is none.
         */
        public function get source():IAudioSource
        {
            return _sampleHandler.source;
        }
        
        /**
         * The SoundChannel currently employed for playback, or null if there is none.
         */
        public function get channel():SoundChannel
        {
            return _channel;
        }

        /**
         * Begin continuous sample block generation. 
         */
        private function startSound():void
        {
            if (_sound != null)
            {
                return;
            }
            _sound = new Sound();
            _sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData);
            _channel = _sound.play();
            _sampleHandler.channel = _channel;
		  
        }
        
        /**
         * Handle a SampleDataEvent by passing it to the AudioSampleHandler delegate.
         */
		
	
		
		private function parseSound(evt:Event):void
		{

				
				e = new ByteArray();
				_sampleHandler.createMixSound(e);
				dispatchEvent(new Event("positionChange"));
				
				var copier:ByteArray = new ByteArray();
				copier.writeObject(e);
				copier.position = 0;
				var bt2:ByteArray = copier.readObject();
				recordedBytes.writeBytes(bt2);

			
		}
		private function handleSampleData(e:SampleDataEvent):void {
			  
			  
			   _sampleHandler.handleSampleData(e);
		        dispatchEvent(new Event("positionChange"));
			
		  }
		 
        private function handleSave():void
        {
			   timer.start();

           
        }
        
        /**
         * Handle completion of our sample handler by forwarding the event to anyone listening to us.
         */
        private function handleComplete(e:Event):void
        {
			timer.stop();
			recordedBytes.position = 0;
			dispatchEvent(new Event("compleateSound"));
            dispatchEvent(e);
        }
 
        /**
         * The actual playback position in seconds, relative to the start of the current source. 
         */
        [Bindable("positionChange")]
        public function get position():Number
        {
            return _sampleHandler.position;
        }

        /**
         * The estimated percentage of CPU resources being consumed by sound synthesis. 
         */
        [Bindable("positionChange")]
        public function get cpuPercentage():Number
        {
            return _sampleHandler.cpuPercentage;
        }

        /**
         * The estimated time between a SampleDataEvent and the actual production of the
         * sound provided to that event, if known.  The time is expressed in seconds.
         */
        [Bindable("positionChange")]
        public function get latency():Number
        {
            return _sampleHandler.latency;
        }
    }
}