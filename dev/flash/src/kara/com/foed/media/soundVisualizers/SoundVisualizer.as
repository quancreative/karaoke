/**
* @description  Abstract base class to handle visualization of loaded MP3 files within a media display.
*/
package com.foed.media.soundVisualizers {

	import flash.display.Shape;
	import flash.display.Sprite;
	
	import com.foed.media.controllers.MP3Controller;

	public class SoundVisualizer extends Sprite {

		private var _backgroundColor:uint;
		private var _FFTMode:Boolean;
		private var _stretchFactor:int;
		protected var _spectrumGraph:Shape;

		/**
		* @description  Constructor. This should only be called by concrete child classes.
		*
		* @param  pWidth  The pixel width for the display.
		* @param  pHeight  The pixel height for the display.
		* @param  pBackgroundColor  The background color for the display.
		*/
		public function SoundVisualizer(pWidth:Number, pHeight:Number, pBackgroundColor:uint=0x000000):void {
			_backgroundColor = pBackgroundColor;
			drawBack(pWidth, pHeight);
			_spectrumGraph = new Shape();
			addChild(_spectrumGraph);
		}

		/**
		* @description  Draws a solid rectangle to fill the display.
		*
		* @param  pWidth  The pixel width for the display.
		* @param  pheight  The pixel height for the display.
		*/
		private function drawBack(pWidth:Number, pHeight:Number):void {
			graphics.clear();
			graphics.beginFill(_backgroundColor);
			graphics.drawRect(0, 0, pWidth, pHeight);
			graphics.endFill();
		}

		/**
		* @description  Called to display a single moment in an MP3 playback.
		*
		* @param  pMP3Controller  The controller to access the sound spectrum from.
		* @param  pWidth  The pixel width for the display.
		* @param  pheight  The pixel height for the display.
		*/
		public function display(pMP3Controller:MP3Controller, pWidth:Number, pHeight:Number):void {}

		/**
		* @description  Returns the background color for the visualization.
		*
		* @returns  The background color for the visualization.
		*/
		public function get backgroundColor():uint { return _backgroundColor; }

		/**
		* @description  Sets the background color for the visualization.
		*
		* @param  pColor  The background color for the visualization.
		*/
		public function set backgroundColor(pColor:uint):void { _backgroundColor = pColor; }

		/**
		* @description  Returns a Boolean value indicating whether a Fourier transformation is performed on the sound data first.
		*
		* @returns  A Boolean value indicating whether a Fourier transformation is performed on the sound data first.
		*/
		public function get FFTMode():Boolean { return _FFTMode; }

		/**
		* @description  Sets the Boolean value indicating whether a Fourier transformation is performed on the sound data first.
		*
		* @param  pMode  A Boolean value indicating whether a Fourier transformation is performed on the sound data first.
		*/
		public function set FFTMode(pMode:Boolean):void { _FFTMode = pMode; }

		/**
		* @description  Returns the resolution of the sound samples.
		*
		* @returns  The resolution of the sound samples.
		*/
		public function get stretchFactor():int { return _stretchFactor; }

		/**
		* @description  Sets the resolution of the sound samples.
		*
		* @param  pFactor  The resolution of the sound samples.
		*/
		public function set stretchFactor(pFactor:int):void { _stretchFactor = pFactor; }

	}
	
}