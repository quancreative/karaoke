package com.anttikupila.revolt {
	import flash.media.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.filters.DropShadowFilter;
	import com.anttikupila.soundSpectrum.SoundProcessor;
	import com.anttikupila.revolt.presets.*;
	
	public class Revolt extends Sprite {
		private var sp:SoundProcessor;
		private var gfx:BitmapData;
		private var presetList:Array;
		private var presetInt:Timer;
		private var preset:Preset;
		private var lastChange:Number;
		
		private var effectType:LineFourier;
	
		function Revolt(w:uint, h:uint) {
			
			sp = new SoundProcessor();		
			
			gfx = new BitmapData(w, h, false, 0x000000)
			var pic:Bitmap = new Bitmap(gfx);			
			addChild(pic);
			
			effectType = new LineFourier();
			addEventListener(Event.ENTER_FRAME, compute);
	
		}
		
		private function compute(ev:Event):void {
			var soundArray:Array = sp.getSoundSpectrum(effectType.fourier);
			
			effectType.applyGfx(gfx, soundArray);
		}
		


		

		
	}
}