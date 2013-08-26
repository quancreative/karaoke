/**
* @description  Visualizes an MP3 as vertical bars drawn horizontally across the display.
*/
package com.foed.media.soundVisualizers {

	import flash.utils.ByteArray;

	import com.foed.media.controllers.MP3Controller;

	public class VerticalBars extends SoundVisualizer {

		private var _barColor:uint;
		private var _percentHeight:Number = .6;
		private var _percentWidth:Number = .8;
	
		/**
		* @description  Constructor.
		*
		* @param  pWidth  The pixel width for the display.
		* @param  pHeight  The pixel height for the display.
		* @param  pBackgroundColor  The background color for the display.
		* @param  pBarColor  The color to use for the vertical bars in the display.
		*/	
		public function VerticalBars(pWidth:Number, pHeight:Number, pBackgroundColor:uint=0x000000, pBarColor:uint=0xFFFFFF):void {
			super(pWidth, pHeight, pBackgroundColor);
			_barColor = pBarColor;
		}

		/**
		* @description  Called to display a single moment in an MP3 playback.
		*
		* @param  pMP3Controller  The controller to access the sound spectrum from.
		* @param  pWidth  The pixel width for the display.
		* @param  pheight  The pixel height for the display.
		*/
		override public function display(pMP3Controller:MP3Controller, pWidth:Number, pHeight:Number):void {
			var pSpectrumData:ByteArray = pMP3Controller.getSoundSpectrum(FFTMode, stretchFactor);
			_spectrumGraph.graphics.clear();
			_spectrumGraph.graphics.beginFill(_barColor);
			var pW:Number = pWidth*_percentWidth;
			var pH:Number = pHeight*_percentHeight;
			var pRatio:Number = pW/512;
			var pX:Number = (pWidth-pW)/2;
			var pY:Number;
			if (FFTMode) {
				pY = pHeight-(pHeight-pH)/2;
			} else {
				pH /= 2;
				pY = pHeight/2;
			}
			var i:int = -1;
			var pVal:Number;
			while (++i < 512) {
				pVal = Math.min(pH, Math.ceil(pH*pSpectrumData.readFloat()));
				_spectrumGraph.graphics.drawRect(pX+i*pRatio, pY, 1, -pVal);
			} 
		}

		/**
		* @description  Returns the color of the graphic bars.
		*
		* @returns  The color of the graphic bars.
		*/
		public function get barColor():uint { return _barColor; }

		/**
		* @description  Sets the color of the graphic bars.
		*
		* @param  pColor  The color of the graphic bars.
		*/
		public function set barColor(pColor:uint):void { _barColor = pColor; }

		/**
		* @description  Returns the percent of the display width to take up with the vertical bars.
		*
		* @returns  The percent of the display width to take up with the vertical bars.
		*/
		public function get percentWidth():Number { return _percentWidth; }

		/**
		* @description  Returns the percent of the display width to take up with the vertical bars.
		*
		* @param  pWidth  The percent of the display width to take up with the vertical bars.
		*/
		public function set percentWidth(pWidth:Number):void { _percentWidth = pWidth; }

		/**
		* @description  Returns the percent of the display height to take up with the vertical bars.
		*
		* @returns  The percent of the display height to take up with the vertical bars.
		*/
		public function get percentHeight():Number { return _percentHeight; }

		/**
		* @description  Returns the percent of the display height to take up with the vertical bars.
		*
		* @param  pHeight  The percent of the display height to take up with the vertical bars.
		*/
		public function set percentHeight(pHeight:Number):void { _percentHeight = pHeight; }

	}
	
}