package
{
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.Sample;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.media.SoundChannel;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class MP3Pitch extends MovieClip
	{
		private const BLOCK_SIZE: int = 3072;

		public var _mp3: Sound;
		public var _sound: Sound;

		private var _target: ByteArray;

		public var _position: Number;
		private var _rate: Number;
		private var _available:Number;

		private var positionInt:int = 0;
		private var need:int;
		private var tryPlay:Boolean = false;
		public var channel:SoundChannel
		private var convers;
		private var lastSavedPosition;
		private var firstPlay:Boolean = false;;
		private var OnePercent:Number;
		private var timPasses = 0;
		public var _tim;
		public var _idCh = 0;

		public var Recod = false;

		private var _eqL;
		private var _eqR;

		private var _revolt;
		public var mediaDuration;

		public var recordedBytes:ByteArray
		public var _sample:Sample;
		public var UseEqualizer = false;
		private var stopped:Boolean;

		public function MP3Pitch( url: String, rat:Number =  1, soundOBJ = null, rev=null, eq = null)

		{
			_revolt = rev;
			var desc:AudioDescriptor = new AudioDescriptor(AudioDescriptor.RATE_44100, 2);
			_sample = new Sample(desc, 0);

			if(eq) {
				_eqL = eq._eqL;
				_eqR = eq._eqL;

			}

			_target = new ByteArray();

			_position = 0.0;
			_rate = rat;

			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );

			if (soundOBJ) {
				_mp3 = soundOBJ;
				channel = _sound.play();
				mediaDuration = _mp3.length;
			}
			else {
				_mp3 = new Sound();
				_mp3.addEventListener( Event.COMPLETE, complete );
				_mp3.addEventListener( ProgressEvent.PROGRESS , showProgress);

				_mp3.load( new URLRequest( url))// +"?as"+Math.random()*100+"s=cacac") );
			}

			recordedBytes = new ByteArray();

		}

		private function showProgress(e:ProgressEvent):void
		{
			mediaDuration= (_mp3.bytesTotal / (_mp3.bytesLoaded / _mp3.length)) ;

			_available = _mp3.bytesLoaded;
			if (!firstPlay) {
				if (_mp3.bytesLoaded / _mp3.bytesTotal > .01* rate) {
					firstPlay = true;
					tryPlay  = false;
					channel = _sound.play();
					addEventListener(Event.ENTER_FRAME, showHowMuch);

				}
			}

			dispatchEvent(e);
		}

		private function showHowMuch(e:Event):void
		{

			//textDisplay.text = (Math.round(Math.ceil((channel.position) + 1) * _rate)/ _mp3.length) + "||" + _mp3.bytesLoaded / _mp3.bytesTotal;
			//_tim = (Math.round(Math.ceil((channel.position + _idCh) + 1) * 1) / _mp3.length);
			//
			//if ( _tim >_mp3.bytesLoaded / _mp3.bytesTotal)
			//{
			//lastSavedPosition = channel.position;
			//channel.stop();
			//tryPlay  = true;
			//}
			//
			//else {
			//if (tryPlay ) {
			//tryPlay = false;
			//channel = _sound.play(lastSavedPosition);
			//}
			//
			//}

			dispatchEvent(new Event("Playing_Sound"));

		}
		public function kill() {
			if (channel) {
				channel.stop();
				channel = null;
			}
			if (_sound) {
				_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
				_sound = null;
			}
			removeEventListener(Event.ENTER_FRAME, showHowMuch);
			_mp3 = null;
			_target = null;
			channel = null;
			_sample  = null;

		}

		public function Play()
		{

			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			need = Math.ceil( scaledBlockSize ) + 2;

			if (_position + need +need < _available &&  _available > (1024*10)) {
				channel = _sound.play();

			}
			else {
				tryPlay = true;
			}
		}
		public function get rate(): Number
		{
			return _rate;
		}
		public function seekTo(e:Number) {

			channel.stop();
			_idCh = Math.round(mediaDuration * e);

			_position = Math.round(mediaDuration * 44.1 * e);

			trace(channel.position , "THE POSITION !!!");
			//var u2 = (channel.position + _idCh) /  _mp3.length;
			//trace(u2);
			//if(u2 > e) {
			//_idCh += - ((u2*_mp3.length) - (e * _mp3.length));
			//}
			//else {
			//_idCh += ((e * _mp3.length)- (u2*_mp3.length));
			//}

		}
		public function set rate( value: Number ): void
		{
			if( value < 0.0 )
			value = 0;

			_rate = value;
		}

		private function complete( event: Event ): void
		{
			mediaDuration = _mp3.length;

			dispatchEvent(event);
			//removeEventListener(Event.ENTER_FRAME, showHowMuch);
		}
		public function delRecording() {
			var desc:AudioDescriptor = new AudioDescriptor(AudioDescriptor.RATE_44100, 2);
			_sample = new Sample(desc, 0);

		}
		public function stopIt() {

			//_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, sampleData ); ?????????
			channel.stop();
			stopped = true;
		}
		public function startIt() {
			if(stopped){
				channel = _sound.play();
				stopped = false;
			}
		}
		private function sampleData( event: SampleDataEvent ): void
		{

			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;

			//-- SHORTCUT
			var data: ByteArray = event.data;

			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			positionInt = _position;
			var alpha: Number = _position - positionInt;

			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;

			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			need = Math.ceil( scaledBlockSize ) + 2;

			//-- EXTRACT SAMPLES

			//trace(positionInt / 9216 ,_mp3.bytesTotal/9216);

			var read: int = _mp3.extract( _target, need, positionInt );

			var n: int = read == need ? BLOCK_SIZE : read / _rate;

			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;
			if(_revolt) {
				var toSend = new Vector.<Number>();
			}
			var channel:Vector.<Number> = _sample.channelData[0];
			var channelB:Vector.<Number> = _sample.channelData[1];

			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;

					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;

					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					l0 = _target.readFloat();
					r0 = _target.readFloat();

					l1 = _target.readFloat();
					r1 = _target.readFloat();
				}

				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				if(UseEqualizer) {
					//-- WITH EQUALIZER
					data.writeFloat( _eqL.compute(l0 + alpha * ( l1 - l0 ) ));
					data.writeFloat(_eqR.compute( r0 + alpha * ( r1 - r0 ) ));
				}
				else {
					data.writeFloat(l0 + alpha * ( l1 - l0 ) );
					data.writeFloat( r0 + alpha * ( r1 - r0 ));
				}

				if(_revolt) {
					toSend.push(l0 + alpha * ( l1 - l0 ));
				}

				if ( Recod) {

					channel.push(l0 + alpha * ( l1 - l0 ) );
					channelB.push( r0 + alpha * ( r1 - r0 ));
				}

				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;

				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}

			if(_revolt){
				_revolt.drawSpectrum(toSend);
			}

			//-- FILL REST OF STREAM WITH ZEROs
			if( i < BLOCK_SIZE )
			{
				while( i < BLOCK_SIZE )
				{
					data.writeFloat( 0.0 );
					data.writeFloat( 0.0 );

					++i;
				}
			}
			if ( Recod) {
				trace("mp3 SAMPLE DATA" , getTimer());
			}
			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;

			// RECORDING OUTPUT
			//if( Recod) {
			//
			//data.position = 0;
			// data.endian = Endian.LITTLE_ENDIAN;   // HACK to work around Adobe bug
			//var channel:Vector.<Number> = _sample.channelData[0];
			//var channelB:Vector.<Number> = _sample.channelData[1]; // coment thei for mono read donw
			//var j:Number = _sample.frameCount;
			//var count:Number = j + data.bytesAvailable / 8;
			//_sample.frameCount = count;
			//while (j < count)
			//{
			//j++
			//channel[j] =  data.readFloat();;
			//channelB[j] =  data.readFloat();; // comment theis for mono
			//}
			//}

		}
	}
}
