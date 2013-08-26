/**
* @description  Interface for class that can playback media, or be played back.
*/
package com.foed.media {

	public interface IPlayable {
	
		/**
		* @description  Begins playback of media.
		*/		
		function startMedia():void; 

		/**
		* @description  Sends the media to the specified position, in milliseconds.
		*
		* @param  pOffset  The position in milliseconds to send the media to.
		*/
		function seek(pOffset:Number):void;

		/**
		* @description  Halts playback of media.
		*/		
		function stopMedia():void;

		/**
		* @description  Pauses or resumes playback of media.
		*
		* @param  pPause  True to pause media. False to resume.
		*/		
		function pauseMedia(pPause:Boolean):void;
	
	}
	
}