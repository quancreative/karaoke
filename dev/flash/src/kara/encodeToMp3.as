package 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import fr.kikko.lab.ShineMP3Encoder;
	
	public class encodeToMp3 extends EventDispatcher
	{
	private var _file:FileReference = new FileReference();
	public var mp3Encoder:ShineMP3Encoder;
	public function encodeToMp3(wavData:ByteArray):void {
			
			mp3Encoder = new ShineMP3Encoder(wavData);
			mp3Encoder.addEventListener(Event.COMPLETE, mp3EncodeComplete);
			mp3Encoder.addEventListener(ProgressEvent.PROGRESS, mp3EncodeProgress);
			mp3Encoder.addEventListener(ErrorEvent.ERROR, mp3EncodeError);
			mp3Encoder.start();
			
	}

	private function mp3EncodeProgress(event : ProgressEvent) : void {
			dispatchEvent(event);			
			trace(event.bytesLoaded, event.bytesTotal);
	}

	private function mp3EncodeError(event : ErrorEvent) : void {
							
			trace("Error : ", event.text);
	}

	private function mp3EncodeComplete(event : Event) : void {
				dispatchEvent(new Event("encdoing_done"));			
			trace("Done !", mp3Encoder.mp3Data.length);
			
			
	}
	
	public function saveMP3 () {
		_file.save(mp3Encoder.mp3Data, "recorded.mp3" );
	}
	
	}
}