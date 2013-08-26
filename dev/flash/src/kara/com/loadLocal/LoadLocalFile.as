package com.loadLocal{  
	
    import flash.display.MovieClip;  
    import flash.events.MouseEvent;  
    import flash.net.*;  
    import flash.display.*;  
    import flash.events.*;  
    import flash.utils.ByteArray;  
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	
	import fl.controls.Button;
	import flash.display.Sprite;
    import flash.display.SimpleButton;
	import fl.controls.Button
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import flash.media.Sound;
	import flash.media.Video;
	
	import com.loadLocal.org.audiofx.mp3.MP3FileReferenceLoader;
	import com.loadLocal.org.audiofx.mp3.MP3SoundEvent;


	
  
    public class  LoadLocalFile extends MovieClip {  

        private var jagFileRefSave:FileReference = new FileReference();  
        public var loader:Loader = new Loader(); 
	    private var imagesFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");  	
		public  var rawBytes:ByteArray = new ByteArray();
		
		
		
		public var  _urlLoader:URLLoader = new URLLoader(); 	
		public  var server_rawBytes:ByteArray = new ByteArray();
		public 	var jpgStream:ByteArray;
		
		public var llcoolJ:SimpleButton;
		public var ButerRims:SimpleButton;
		public var normalLoader:Loader;
		
		public var _localFile:Object;
		
		public var stringReference:String;
		
		
		
		private var loader2:MP3FileReferenceLoader;
		private var fileReference:FileReference;
		
		
    public function  LoadLocalFile(){  
        super();  
		
        llcoolJ.addEventListener(MouseEvent.CLICK,onClickSave);  
		ButerRims.addEventListener(MouseEvent.CLICK , saveToDisk);
		
		loader2 = new MP3FileReferenceLoader();
		loader2.addEventListener(MP3SoundEvent.COMPLETE,mp3LoaderCompleteHandler);
		
		}  
	

	
	
	private function onClickSave(e:MouseEvent):void{      
        jagFileRefSave.browse();  
        jagFileRefSave.addEventListener(Event.SELECT, selectedFile);  
    }  
	
       
    private function selectedFile(e:Event):void{  
      
		var str:String = jagFileRefSave.name
		ftype = str.slice(str.length -3, str.length);
		stringReference = str
		

		switch (ftype) {
			
				case "jpg" :
					Tracer.trac("SS")
				   jagFileRefSave.load();  
				   jagFileRefSave.addEventListener(Event.COMPLETE, loadedJPG);  
				 break;		
			   case "swf" :
				   jagFileRefSave.load();  
				   jagFileRefSave.addEventListener(Event.COMPLETE, loadedSWF); 
				break;		
			   case "flv" :
			     break;
			   case "mp4" :	
    			 break;
			   case "mp3" :
				loader2.getSound(jagFileRefSave);	
				 break;	 
			   default :
			    
			     trace("---! File type not recognized----");
		}
		
			
    }  
    private function loadedJPG(e:Event):void {  
		Tracer.trac("SS2")
       	rawBytes = jagFileRefSave.data;  
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, getBitmapData)  
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, doError) 
        loader.loadBytes(rawBytes); 
				
	
    }  
	  private function loadedSWF(e:Event):void {  
		
       	rawBytes = jagFileRefSave.data;  
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, getMovieClipData)  
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, doError) 
        loader.loadBytes(rawBytes); 
		
	
    }  
	
	private function mp3LoaderCompleteHandler(e:MP3SoundEvent):void 
	{
		//trace(e.sound)
		_localFile = e.sound;
		dispatchEvent(new Event("LOAD_LOCAL"));
	}
	
	private function doError(e:IOErrorEvent):void 
	{
	  trace("IO_ERROR happend")
	}
	private function saveToDisk(e:Event):void {
  	 var file:FileReference = new FileReference();
	 file.save(rawBytes, "LocalLoader.mp3");
	}	
	
    private function getBitmapData(e:Event):void{      

		_localFile = Bitmap(loader.content)
		dispatchEvent(new Event("LOAD_LOCAL"));
			
		
		}  
		
 private function getMovieClipData(e:Event):void{      
	    
 
		_localFile = MovieClip(loader.content)
		
		
		dispatchEvent(new Event("LOAD_LOCAL"));
		
		
		
		} 
		
		
	public function getBitmap():Bitmap {
		
		return _localFile
		}
	

  
    }  
	

	
}  