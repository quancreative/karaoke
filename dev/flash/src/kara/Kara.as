package
{
	import com.anttikupila.revolt.Revolt;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.utils.IDataInput;
	import nochump.util.zip.*;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import com.loadLocal.org.audiofx.mp3.MP3FileReferenceLoader;
	import com.loadLocal.org.audiofx.mp3.MP3SoundEvent;
	import com.noteflight.standingwave2.*;
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.IAudioSource;
	import com.noteflight.standingwave2.performance.AudioPerformer;
	import com.noteflight.standingwave2.performance.ListPerformance;
	import flash.events.MouseEvent;
	import flash.media.Microphone;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import com.noteflight.standingwave2.output.AudioPlayer;
	import com.noteflight.standingwave2.sources.SineSource;
	import com.noteflight.standingwave2.sources.SoundSource;
	import com.noteflight.standingwave2.input.MicrophoneInput;
	import com.noteflight.standingwave2.filters.GainFilter;
	import com.noteflight.standingwave2.filters.EchoFilter;
	import com.noteflight.standingwave2.filters.BiquadFilter
	import com.noteflight.standingwave2.formats.WaveFile;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import org.as3wavsound.WavSound;
	import org.bytearray.micrecorder.encoder.WaveEncoder;

	import PlayList;

	public class Kara extends MovieClip
	{
		var loader2:MP3FileReferenceLoader;
		var _localFile;
		var songFR:FileReference;
		var cdgFR:FileReference;
		var playlist:Array
		var f:FileReferenceList = new FileReferenceList();

		var mp3:String;
		var cdg:String;

		var pit:MP3Pitch;
		var bit:Bitmap  = new Bitmap();
		var bitData:BitmapData=new BitmapData(320,216,true,0x00000000);

		var cTransform:ColorTransform = new ColorTransform();
		var rect:Rectangle=new Rectangle(0,0,320,216);
		var stream:URLStream;
		var CDGbytes:ByteArray = new ByteArray();

		var timer:Timer=new Timer(3,0);

		var colorTable:Array=[];
		var colorTableLow:Array=[0];
		var colorTableHigh:Array = [0];

		var iXr:Number = 1;

		var channel:SoundChannel;
		var lastRanderdPosition:Number=0;
		var lastJ;
		var i2:int = 1;

		var source:IAudioSource;
		var mic:MicrophoneInput;
		var _file:FileReference = new FileReference();
		//var recorder:MicRecorder = new MicRecorder( new WaveEncoder() );
		var currentSongName;
		var player:AudioPlayer;
		var micRecoding;
		var theMic:Microphone;
		var sound:Sound;
		var _pl:PlayList;
		var theDragedOBJ:Sprite;
		var popRec;

		var _revolt:Revolt;
		var revolt2:Revolt;

		var	_equalizerScreen;
		private var mp3Enc:encodeToMp3;
		private var _Format:String  = "MP3";
		private var voiceVisualizer;

		public function Kara()
		{
			addEventListener(Event.ADDED_TO_STAGE , init);
		}
		public function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE , init);
			bit.bitmapData=bitData;
			car.addChild(bit);
			bit.smoothing = true
			stage.frameRate=1000;
			mp.currentSpeed.text = String(iXr);
			timer.addEventListener(TimerEvent.TIMER, getExactPosition);

			this.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);

			mp.slowerBtn.addEventListener(MouseEvent.CLICK , slower);
			mp.fasterBtn.addEventListener(MouseEvent.CLICK , faster);
			mp.bckBar.addEventListener(MouseEvent.MOUSE_DOWN, seekTo);
			mp.progressBar.width = 0;
			mp.seekBar2.width = 1
			mp.prevBtn.addEventListener(MouseEvent.CLICK , goBackone);
			mp.nextBtn.addEventListener(MouseEvent.CLICK , goNextone);
			mp.pauseBtn.addEventListener(MouseEvent.CLICK , pauseSong);
			mp.playBtn.addEventListener(MouseEvent.CLICK , playSong);
			mp.showHidePlayList.addEventListener(MouseEvent.CLICK , showHidePlaylist);
			mp.eqBtn.addEventListener(MouseEvent.CLICK , showHideEq)

			mp.recordBtn.addEventListener(MouseEvent.CLICK , startRecording);
			mp.bck.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag);

			revolt2 = new Revolt(150*2, 100*2, true);
			revolt2.width = 1920;
			revolt2.height = 1080;
			revolt2.x = 0;
			revolt2.y = 0
			addChild(revolt2);

			_revolt = new Revolt(300*2, 200*2, false);
			_revolt.width = 600;
			_revolt.height = 400;

			setChildIndex(car, numChildren-1)
			setChildIndex(mp, numChildren-1)

			theMic = Microphone.getMicrophone();
			if(theMic)
			{
				theMic.rate = 44;
				mic = new MicrophoneInput(theMic,_revolt);
			}
			else {
				mp.recordBtn.visible = false;
			}

			mp.recordBtn.stop();
			mp.seekBar2.mouseEnabled = false;
			loadPlayList();
			//_pl = new PlayList(["Evanescence - My Immortal","Evanescence - Bring Me To Life",
			//"Aerosmith - Luv Lies" , "Gabrielle - Should I Stay", "Foreigner - Double Vision", "Enrique Iglesias - Escape",
			//"Foreigner - Double Vision", "Gabrielle - Should I Stay", "Dionne Warwick - You'll Never Get To Heaven",
			//"Devo - Whip It", "Frank Sinatra - Can I Steal A Little Love",
			//"Frank Sinatra - Call Me Irresponsible", "Frank Sinatra - All The Way",
			//"Frank Sinatra - All Or Nothing At All",
			//"A1 - Caught In The Middle"]
			//,2);
			//_pl.x = 300;
			//_pl.y = 20;
			//_pl.plBkg.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			//_pl.plHeader.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			//addChild(_pl);
			//
			//_pl.addEventListener("SongClicked" , songClicked);
			stage.scaleMode  = "showAll";

			popRec = new SaveRecordinScreen();
			popRec.x = mp.width;
			mp.addChild(popRec);

			popRec.visible = false;
			popRec.encodeBtn.addEventListener(MouseEvent.CLICK , saveTheSongMan);
			popRec.encodeBtn.encFinBtn.visible = false;

			popRec.saveBtn.addEventListener(MouseEvent.CLICK, saveTheWav);
			popRec.playRecBtn.addEventListener(MouseEvent.CLICK , playRecording);
			popRec.delBtn.addEventListener(MouseEvent.CLICK , disposeOfRecoding);

			_equalizerScreen = new Equalizer();
			addChild(_equalizerScreen);
			_equalizerScreen.onBtn.addEventListener(MouseEvent.CLICK , equalizerOnOf);
			_equalizerScreen.onBtn.alpha = .3;
			_equalizerScreen.closeBtn.addEventListener(MouseEvent.CLICK , closeIt);
			_equalizerScreen.bck.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			_equalizerScreen.visible = false;

			voiceVisualizer= new VoiceVisualizer();
			voiceVisualizer.fund.width = _revolt.width  + 10;
			voiceVisualizer.fund.height = _revolt.height  + 10;
			voiceVisualizer.bck.width = _revolt.width  + 10;
			voiceVisualizer.bck.x -= 5;
			voiceVisualizer.fund.x -= 5;
			voiceVisualizer.fund.y -= 5;
			voiceVisualizer.x = 1920 - voiceVisualizer.width - 20
			voiceVisualizer.btnClose.x = voiceVisualizer.bck.width - voiceVisualizer.btnClose.width - 5;
			voiceVisualizer.btnClose.addEventListener(MouseEvent.CLICK, closeVoiceVisualizer);
			voiceVisualizer.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			addChild(voiceVisualizer);
			voiceVisualizer.visible = false;
			voiceVisualizer.addChild(_revolt);

		}

		private function closeVoiceVisualizer(e:MouseEvent):void
		{
			voiceVisualizer.visible = false;
		}

		private function closeIt(e:MouseEvent):void
		{
			e.target.parent.visible =  false;
		}

		private function loadPlayList():void
		{
			var myTextLoader:URLLoader = new URLLoader();
			myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
			myTextLoader.load(new URLRequest("playlist.txt"));

		}

		function onLoaded(e:Event):void {
			var s:String = e.target.data
			var rg:RegExp  = new RegExp(".mp3", "g");
			var rg2:RegExp  = new RegExp(".MP3", "g");
			var rg3:RegExp  = new RegExp("\n","g");
			//s = s.replace(rg, "");
			s = s.replace(rg2, ".mp3");

			var a = s.split("\n")
			for (var i = 0 ; i < a.length; i++) {

				a[i] = a[i].substring(0, a[i].lastIndexOf(".mp3"));

			}

			_pl = new PlayList(a,0);
			_pl.x = 300;
			_pl.y = 20;
			_pl.plBkg.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			_pl.plHeader.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag)
			addChild(_pl);

			_pl.addEventListener("SongClicked" , songClicked);

		}

		private function showHideEq(e:MouseEvent):void
		{
			_equalizerScreen.visible = !_equalizerScreen.visible
		}

		private function equalizerOnOf(e:MouseEvent):void
		{
			if(pit) {
				pit.UseEqualizer = !pit.UseEqualizer;
				_equalizerScreen.onBtn.alpha = pit.UseEqualizer == true?1:.3;
			}
		}

		private function showHidePlaylist(e:MouseEvent):void
		{
			_pl.visible = !Boolean(_pl.visible);
		}

		private function startTheDrag(e:MouseEvent):void
		{

			if (e.target.name == "bck") {
				setChildIndex(e.target.parent , numChildren - 1);
				theDragedOBJ = Sprite(e.target.parent)
				theDragedOBJ.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP , stopTheDrag);
			}
		}

		private function stopTheDrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP , stopTheDrag);
			if (theDragedOBJ) {
				theDragedOBJ.stopDrag();
				theDragedOBJ.addEventListener(MouseEvent.MOUSE_DOWN, startTheDrag);
				theDragedOBJ = null;
			}
		}

		private function stopRecording():void
		{
			if (mic.recording) {
				mp.recordBtn.gotoAndStop(1);
				mic.stop();
				if (pit) {
					pit.Recod = false;
				}
				popRec.visible = true;
				mic.removeEventListener(Event.CHANGE , userAcceptedRecoding);
			}
		}
		private function startRecording(e:MouseEvent):void
		{

			if (mic.recording) {
				voiceVisualizer.visible = false;
				stopRecording();
			}
			else {
				setChildIndex(voiceVisualizer , numChildren - 1);
				voiceVisualizer.visible = true;
				mic.record();
				mic.addEventListener(Event.CHANGE , userAcceptedRecoding);

			}
		}

		private function userAcceptedRecoding(e:Event):void
		{
			mic.removeEventListener(Event.CHANGE , userAcceptedRecoding);
			mp.recordBtn.play();
			if (pit) {
				pit.Recod = true;
			}
		}

		private function playRecording(e:MouseEvent):void

		{
			player = new AudioPlayer();
			player.play(createSeqPlayer());
		}

		private function createSeqPlayer():IAudioSource
		{
			mic.stop();
			var sequence:ListPerformance = new ListPerformance();
			if(pit) {
				pit.stopIt();
				sequence.addSourceAt(1, pit._sample);
			}
			sequence.addSourceAt(.77, mic.sample);
			sequence.addSourceAt(0, new SineSource(new AudioDescriptor(), 0.1, 660));
			var Lsource:IAudioSource = new AudioPerformer(sequence);
			return Lsource
		}

		private function saveTheSongMan(e:MouseEvent):void
		{

			_Format = "mp3";
			popRec.encodeBtn.removeEventListener(MouseEvent.CLICK , saveTheSongMan);
			popRec.encodeBtn.encFinBtn.visible = true;
			player = new AudioPlayer();
			player.addEventListener("compleateSound", recodrNewBytes);
			player.save(createSeqPlayer());

			trace("strat encoding at " + getTimer());

		}

		private function recodrNewBytes(e:Event):void
		{
			player.stop();
			trace("end at " + getTimer());

			var  wavEnc:ByteArray =   new WaveEncoder().encode( player.recordedBytes, 2);
			if (_Format == "mp3") {
				mp3Enc = new encodeToMp3( wavEnc);
				mp3Enc.addEventListener("encdoing_done" , showFinished);
				mp3Enc.addEventListener(ProgressEvent.PROGRESS, mp3EncodeProgress);
				// _file.save(  wavEnc, "recorded.wav" );
				trace("after encoding " + getTimer());
			}
			else {
				_file.save(wavEnc, "recorded.wav" );
			}
		}

		private function mp3EncodeProgress(e:ProgressEvent):void
		{
			popRec.encodeBtn.encFinBtn.percent.text = e.bytesLoaded + "/" +  e.bytesTotal;
		}

		private function showFinished(e:Event):void
		{
			mp3Enc.removeEventListener("encdoing_done" , showFinished);
			popRec.encodeBtn.encFinBtn.percent.text = "Save MP3 encoding";
			popRec.encodeBtn.addEventListener(MouseEvent.CLICK , saveTheMP3);

		}

		private function saveTheMP3(e:MouseEvent):void
		{
			mp3Enc.saveMP3();
		}

		private function disposeOfRecoding(e:MouseEvent):void
		{

			popRec.visible = false;

			if(mp3Enc){
				mp3Enc.removeEventListener("encdoing_done" , showFinished);
				mp3Enc.removeEventListener(ProgressEvent.PROGRESS, mp3EncodeProgress);
				mp3Enc = null;
			}

			if (mic) {
				mic.delRecording();
			}
			if (pit) {
				pit.delRecording();
			}
			popRec.encodeBtn.removeEventListener(MouseEvent.CLICK , saveTheMP3);
			popRec.encodeBtn.addEventListener(MouseEvent.CLICK , saveTheSongMan);
			if(player) {
				player.removeEventListener("compleateSound", recodrNewBytes);
			}

		}

		private function saveTheWav(e:MouseEvent):void
		{
			_Format = "wav";
			mic.stop();
			pit.stopIt();

			player = new AudioPlayer();
			player.addEventListener("compleateSound", recodrNewBytes);
			player.save(createSeqPlayer());

			trace("strat encoding at " + getTimer());

		}

		function stopPit() {
			iXr = 1;
			mp.currentSpeed.text = "1";
			timer.removeEventListener(TimerEvent.TIMER, getExactPosition);
			timer.stop();

			if(cdgFR){
				cdgFR.removeEventListener(Event.COMPLETE , compleateLocalLoad);
				cdgFR.cancel()
				cdgFR = null;
			}

			if(songFR){
				songFR.cancel();
				songFR = null;
			}

			if (pit) {
				pit.removeEventListener(ProgressEvent.PROGRESS, showLoadProgress);
				pit.removeEventListener(Event.COMPLETE, complete);
				pit.removeEventListener("Playing_Sound", soundPlaying);
				pit.stopIt()
				pit = null;
			};
			i2 = 0;
			mp.seekBar2.width = 1;
			lastRanderdPosition = 0;
			if (bitData) {
				clearDisplay();
			}

		}

		function songClicked(e:Event)
		{

			stopPit();
			stopRecording();
			if (_pl.lastClickedItem.parent.mp3Ref.toString() == "[object FileReference]") {
				mp3 = null;

				if (loader2)  {

					loader2.Kill();
					loader2.removeEventListener(MP3SoundEvent.COMPLETE, mp3LoaderCompleteHandler);
					loader2 = null;
				}

				cdgFR  = _pl.lastClickedItem.parent.cdgRef;
				songFR = _pl.lastClickedItem.parent.mp3Ref ;

				loader2 = new MP3FileReferenceLoader();
				loader2.addEventListener(MP3SoundEvent.COMPLETE, mp3LoaderCompleteHandler);
				loader2.getSound(songFR);
				currentSongName = songFR.name;

			}
			else {
				trace("!!!!",   _pl.lastClickedItem.parent.mp3Ref)
				mp3 = _pl.lastClickedItem.parent.mp3Ref;
				cdg = _pl.lastClickedItem.parent.cdgRef;

				currentSongName = mp3
				loadCDG();

			}

		}

		function goBackone (e:Event) {

			_pl.getPrevSong();

		}

		function goNextone (e:Event) {
			_pl.getNextSong();

		}

		function pauseSong (e:Event) {
			pit.stopIt();
		};

		function playSong (e:Event) {
			if (!pit) {
				_pl.playFirstSong();
				return

			}

			pit.startIt();

		}
		private function soundPlaying(e:Event):void
		{
			if (!timer.running && mp3) {

				timer.addEventListener(TimerEvent.TIMER, getExactPosition);
				timer.start();
			}
			//seekBar.width = pit._tim * mp.bckBar.width;
			//trace(pit._idCh )
		}

		private function seekTo(e:MouseEvent):void
		{
			timer.stop();

			clearDisplay();
			lastRanderdPosition = 0;

			if (mp.bckBar.mouseX < mp.progressBar.width) {

				pit.seekTo(mp.bckBar.mouseX / mp.bckBar.width);

			}

			i2 = 0;

			var tw = Math.ceil(((pit._idCh)/3.33)+1)

			for (var j= lastRanderdPosition; j < Math.round(tw*1); j++) {

				if (lastJ+1!=j) {
					//trace("!");
				}
				lastJ=j;

				stepCDG(j);
			}
			lastRanderdPosition = Math.round(tw*iXr);

			pit.channel = pit._sound.play(0);
			timer.start();

		}

		private function clearDisplay():void
		{
			var clearColor=colorTable[int(CDGbytes[i2*24+4]&0x0F)];
			//if(clearColor !=0 ) {clearColor+=4278190080}
			cTransform.alphaMultiplier=0.0;
			cTransform.color=clearColor;
			bitData.colorTransform(rect, cTransform);
			bitData.dispose();
			bitData = new BitmapData(320, 216, true, 0x00000000);

			bit.bitmapData=bitData;
			bit.smoothing = true
			lastRanderdPosition = 0;

		}

		private function formaMilisocondTime(n:Number):String {

			var seconds=n/1000;
			var m=Math.floor(seconds/60);
			var s = Math.round(seconds - (m * 60));
			if (m<10) {
				m="0"+m;
			}
			if (s<10) {
				s="0"+s;
			}
			return m + ":" + s;
		}

		private function complete(e:Event):void
		{

		}

		private function showLoadProgress(e:ProgressEvent):void
		{

			mp.progressBar.width = (mp.bckBar.width * e.bytesLoaded / e.bytesTotal);
		}

		function slower(e:Event) {

			iXr -= .1
			pit.rate = iXr;

			lastRanderdPosition = Math.round(Math.ceil(((pit.channel.position + pit._idCh)/3.33)-1)*iXr);

			mp.currentSpeed.text = String(iXr);

		}
		function faster(e:Event) {

			iXr += .1
			pit.rate= iXr;
			lastRanderdPosition = Math.round(Math.ceil(((pit.channel.position + pit._idCh)/3.33)+1)*iXr);

			mp.currentSpeed.text = String(iXr);

		}

		function loaderComplete(myEvent:Event) {
			continueLoading(this.loaderInfo.parameters.fileName);
		}

		function continueLoading(e=null) {

			if ( e ) {
				playlist = e.split(",")
			}

		}

		function mp3LoaderCompleteHandler(e:MP3SoundEvent) {
			_localFile = e.sound;
			cdgFR.removeEventListener(Event.COMPLETE , compleateLocalLoad);
			cdgFR.cancel();
			cdgFR = null
			songCompleate(null);

		}

		function songCompleate(e:Event) {

			cdgFR = _pl.lastClickedItem.parent.cdgRef;
			cdgFR.addEventListener(Event.COMPLETE , compleateLocalLoad);
			cdgFR.load();

		}

		function compleateLocalLoad(e:Event) {
			CDGbytes = cdgFR.data;
			colorTable= []
			colorTableLow = [];
			colorTableHigh = [];
			pit = new MP3Pitch("", 1, _localFile, revolt2,_equalizerScreen);
			mp.progressBar.width = mp.bckBar.width;
			timer.addEventListener(TimerEvent.TIMER, getExactPosition);
			timer.start()

		}

		function loadCDG() {

			stream = new URLStream();
			stream.load(new URLRequest(cdg));

			stream.addEventListener(Event.COMPLETE, startPlaying);
			CDGbytes = new ByteArray();
			colorTable=[];
			colorTableLow=[];
			colorTableHigh=[];

		}

		function getExactPosition(e:Event) {

			var cp = pit.channel.position;

			for (var j= lastRanderdPosition; j < Math.round(Math.ceil(((cp + pit._idCh)/3.33)+1)*iXr); j++) {

				if (lastJ+1!=j) {
					//trace("!");
				}
				lastJ=j;

				stepCDG(j);
			}

			lastRanderdPosition = Math.round(Math.ceil(((cp + pit._idCh) / 3.33) + 1) * iXr);

		}

		function startPlaying(e:Event):void {

			var us2:ByteArray = new ByteArray();
			stream.readBytes(us2, 0);

			var zipFile:ZipFile = new ZipFile(us2);
			var entry:ZipEntry = zipFile.entries[0];
			CDGbytes = zipFile.getInput(entry);
			//
			//CDGbytes =us2

			pit = new MP3Pitch(mp3, iXr, null, revolt2, _equalizerScreen );

			pit.addEventListener(ProgressEvent.PROGRESS, showLoadProgress);
			pit.addEventListener(Event.COMPLETE, complete);
			pit.addEventListener("Playing_Sound", soundPlaying);

			//stream.readBytes(CDGbytes, 0);

		}

		function stepCDG(e:int) {

			var i=i2*24;
			i2++;

			var j;
			var l;
			var HB;
			var LB;
			var red;
			var green;
			var blue;
			var hex;
			if (i>CDGbytes.length) {
				timer.stop();
				return;
			}
			var percent = i / CDGbytes.length
			mp.seekBar2.width = ( percent * mp.bckBar.width);

			mp.currentSongTitle.text = currentSongName +"..." +formaMilisocondTime(percent*pit.mediaDuration)+  "....." + formaMilisocondTime(pit.mediaDuration);
			if (mp.seekBar2.width + 20 > mp.progressBar.widht) {
				pit.stopIt();
			}
			if (Number(CDGbytes[i]&0x3F)==9) {

				switch (Number(CDGbytes[i+1]&0x3F)) {

					case 1 ://Memory preset
						if ((CDGbytes[i+5]&0x0F)!=0) {
						break;
					}
					//trace( "Memory preset  comand ",  CDGbytes[i+1]&0x3F);
					//trace( "color = " , CDGbytes[i+4]&0x0F);
					//trace( "repeat  = " , CDGbytes[i+5]&0x0F);
					var clearColor=colorTable[int(CDGbytes[i+4]&0x0F)];
					//if(clearColor !=0 ) {clearColor+=4278190080}
					cTransform.alphaMultiplier=0.0;
					cTransform.color=clearColor;
					bitData.colorTransform(rect, cTransform);
					//bit.bitmapData = bd;
					break;

					case 2 ://Border preset
						//trace(  "Border preset comand ",  CDGbytes[i+1]&0x3F);
						//trace( "color = " , CDGbytes[i+4]&0x0F);
					break;

					case 6 ://Title Block
					case 38 ://Title Block

						//trace(  "Title Block ",  CDGbytes[i+1]&0x3F);
						var color0=colorTable[Number(CDGbytes[i+4]&0x0F)];
						var color1=colorTable[Number(CDGbytes[i+5]&0x0F)];

						var row=int(CDGbytes[i+6]&0x1F)*12;// "actual pixels",Number(CDGbytes[i+6]&0x1F)* 12);
						var column=int(CDGbytes[i+7]&0x3F)*6;//,  "actual pixels",Number(CDGbytes[i+7]&0x3F)* 6);

						var tilePixels:Array=[];

						for (j= 0; j < 12; j++) {
							tilePixels.push(  CDGbytes[i+8 +j ]&0x3F);
					}

					for (j = 0; j < tilePixels.length; j++) {

						for (l =0; l< 6; l++) {
							var b = int((tilePixels[j]  )& 0x1) == 0 ? color0:color1;

							////trace( "row=", j , "col=", l,b )
							tilePixels[j]=tilePixels[j]>>1;

							////trace( "row=", row , "col=", column,b )
							if (Number(CDGbytes[i+1]&0x3F)==6) {

								if (b!=colorTable[0]) {
									b+=4278190080;
								}
								bitData.setPixel32( column+(5-l),row+j,  b);
							} else {

								var toXOR = bitData.getPixel( column+(5-l),row+j);
								if (toXOR==0) {
									toXOR=colorTable[0];
								}
								b=colorTable[colorTable.indexOf(toXOR)^colorTable.indexOf(b)];

								if (b!=colorTable[0]) {
									b+=4278190080;
								}

								bitData.setPixel32( column+(5-l),row+j, b);
							}
						}
					}

					break;

				case 24 :
					//trace(  "Scroll preset ",  CDGbytes[i+1]&0x3F);
				break;
				case 20 ://need to implement the Scroll Copy r 24

					//trace(  "Scroll preset ",  CDGbytes[i+1]&0x3F);
					//trace( "color = " , CDGbytes[i+2]&0x0F);
					//trace( "hScroll = " , CDGbytes[i+3]&0x3F);
					//trace( "vScroll = " , CDGbytes[i+3]&0x3F);
				break;
				case 28 ://need to implement the Scroll Copy r 28
					//trace(  "Define Transparent Color ",  CDGbytes[i+1]&0x3F);
				break;
				case 30 :
					//trace(  "Load Color Table Low ",  CDGbytes[i+1]&0x3F);
					colorTableLow=[];
					for (j = 4; j < 20; j += 2) {

						HB=CDGbytes[i+j]&0x3F3F;//("highByte = " , CDGbytes[i+4]&0x3F3F);
						LB=CDGbytes[i+j+1]&0x3F3F;////trace("lowByte = " , CDGbytes[i+5]&0x3F3F);
						red=HB>>2;
						green = ((HB & 0x3) * 4) + (LB >> 4);
						blue=LB&0xF;
						hex=RGBToHex(red*17,green*17,blue*17);
						colorTableLow.push(hex);
				}
				colorTable=colorTableLow.concat(colorTableHigh);
				break;

			case 31 ://need to implement high nr 31
				//trace(  "Load Color Table High  ",  CDGbytes[i+1]&0x3F);

				colorTableHigh=[];
				for (j = 4; j < 20; j += 2) {

					HB=CDGbytes[i+j]&0x3F3F;//("highByte = " , CDGbytes[i+4]&0x3F3F);
					LB=CDGbytes[i+j+1]&0x3F3F;////trace("lowByte = " , CDGbytes[i+5]&0x3F3F);
					red=HB>>2;
					green = ((HB & 0x3) * 4) + (LB >> 4);
					blue=LB&0xF;
					hex=RGBToHex(red*17,green*17,blue*17);
					colorTableHigh.push(hex);
			}
			colorTable=colorTableLow.concat(colorTableHigh);
			break;

		}
	}
}

function RGBToHex(r, g, b ) {
	var hex=r<<16^g<<8^b;

	return hex;
}

}

}