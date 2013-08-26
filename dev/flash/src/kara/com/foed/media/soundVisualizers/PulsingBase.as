/**
* @description  Visualizes an MP3 as rings that pulse to the bass.
*/
package com.foed.media.soundVisualizers {

	import flash.utils.ByteArray;
	import flash.filters.BlurFilter;
	
	import com.foed.media.controllers.MP3Controller;

	public class PulsingBase extends SoundVisualizer {

		private var _ringColor:uint;
		private var _numRings:uint = 3;
		private var _ringThickness:Number = 8;
		private var _ringGap:Number = 5;
		private var _minRingRadius:Number = 10;
		private var _maxRingRadius:Number = 40;
		private var DEFAULT_WIDTH:Number = 320;
		private var DEFAULT_HEIGHT:Number = 240;
	
		/**
		* @description  Constructor.
		*
		* @param  pWidth  The pixel width for the display.
		* @param  pHeight  The pixel height for the display.
		* @param  pBackgroundColor  The background color for the display.
		* @param  pRingColor  The color to use for the rings in the display.
		*/	
		public function PulsingBase(pWidth:Number, pHeight:Number, pBackgroundColor:uint=0x000000, pRingColor:uint=0xFFFFFF):void {
			super(pWidth, pHeight, pBackgroundColor);
			filters = [new BlurFilter(3, 3)];
			_ringColor = pRingColor;
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
			var pVal:Number = 0;
			var i:int = -1;
			while (++i < 128) {
				pVal = Math.max(pVal, pSpectrumData.readFloat());
			}
			i = 255;
			while (++i < 384) {
				pVal = Math.max(pVal, pSpectrumData.readFloat());
			}
			pVal = Math.min(1, pVal);
			var pRatio:Number = Math.min(pWidth/DEFAULT_WIDTH, pHeight/DEFAULT_HEIGHT);
			var pOffset:Number = pVal*(_maxRingRadius-_minRingRadius)*pRatio;
			var pX:Number = pWidth/2;
			var pY:Number = pHeight/2;
			var pThickness:Number = (_ringThickness/2)*pRatio;
			var pGap:Number = _ringGap*pRatio;
			var pMinRadius:Number = _minRingRadius*pRatio;
			var pRadius:Number;
			for (var j:uint = 0; j < _numRings; j++) {
				pRadius = (j+1)*pMinRadius + j*pGap + pOffset*(j/(_numRings-1));
				_spectrumGraph.graphics.beginFill(_ringColor);
				_spectrumGraph.graphics.drawCircle(pX, pY, pRadius+pThickness);
				_spectrumGraph.graphics.drawCircle(pX, pY, pRadius-pThickness);
				_spectrumGraph.graphics.endFill();
			}
		}

		/**
		* @description  Returns the color of the graphic rings.
		*
		* @returns  The color of the graphic rings.
		*/
		public function get ringColor():uint { return _rRingColor; }

		/**
		* @description  Sets the color of the graphic rings.
		*
		* @param  pColor  The color of the graphic rings.
		*/
		public function set ringColor(pColor:uint):void { _ringColor = pColor; }

		/**
		* @description  Returns the number of graphic rings drawn.
		*
		* @returns  The number of graphic rings drawn.
		*/
		public function get numRings():uint { return _numRings; }

		/**
		* @description  Sets the number of graphic rings drawn.
		*
		* @param  pNumRings  The number of graphic rings drawn.
		*/
		public function set numRings(pNumRings:uint):void { _numRings = pNumRings; }

		/**
		* @description  Returns the pixel thickness for the graphic rings.
		*
		* @returns  The pixel thickness for the graphic rings.
		*/
		public function get ringThickness():Number { return _ringThickness; }

		/**
		* @description  Sets the pixel thickness for the graphic rings.
		*
		* @param  pThickness  The pixel thickness for the graphic rings.
		*/
		public function set ringThickness(pThickness:Number):void { _ringThickness = pThickness; }

		/**
		* @description  Returns the pixel gap between drawn rings.
		*
		* @returns  The pixel gap between drawn rings.
		*/
		public function get ringGap():Number { return _ringGap; }

		/**
		* @description  Sets the pixel gap between drawn rings.
		*
		* @param  pGap  The pixel gap between drawn rings.
		*/
		public function set ringGap(pGap:Number):void { _ringGap = pGap; }

		/**
		* @description  Returns the radius of the innermost ring drawn.
		*
		* @returns  The radius of the innermost ring drawn.
		*/
		public function get minRingRadius():Number { return _minRingRadius; }

		/**
		* @description  Sets the radius of the innermost ring drawn.
		*
		* @param  pRadius  The radius of the innermost ring drawn.
		*/
		public function set minRingRadius(pRadius:Number):void { _minRingRadius = pRadius; }

		/**
		* @description  Returns the radius of the outermost ring drawn.
		*
		* @returns  The radius of the outermost ring drawn.
		*/
		public function get maxRingRadius():Number { return _maxRingRadius; }

		/**
		* @description  Sets the radius of the outermost ring drawn.
		*
		* @param  pRadius  The radius of the outermost ring drawn.
		*/
		public function set maxRingRadius(pRadius:Number):void { _maxRingRadius = pRadius; }

	}
	
}