/**
* @description  Interface for class that has audio settings.
*/
package com.foed.media {
	
	import flash.media.SoundTransform;
	
	public interface IAudible {
	
		function getVolume():Number; 

		/**
		* @description  Sets the volume of the controller's media.
		*
		* @param  pVolume  A number between 0 and 1 representing the volume level of the media.
		*/		
		function setVolume(pVolume:Number):void; 
	
		/**
		* @description  Returns the current sound pan of the controller's media.
		*
		* @returns  A number between -1 and 1 representing the pan of the media's sound.
		*/		
		function getPan():Number;

		/**
		* @description  Sets the pan of the controller's media's sound.
		*
		* @param  pPan  A number between -1 and 1 representing the pan of the media's sound.
		*/		
		function setPan(pPan:Number):void;
	
		/**
		* @description  Returns a SoundTransform instance containing the current sound properties for the media.
		*
		* @returns  A new SoundTransform instance containing the volume and pan values for the media.
		*/		
		function getSoundTransform():SoundTransform;

		/**
		* @description  Sets the sound volume and pan properties for the media.
		*
		* @param  pTransform  A SoundTransform instance with volume and pan values to apply to the media.
		*/		
		function setSoundTransform(pTransform:SoundTransform):void;
	
	}
	
}