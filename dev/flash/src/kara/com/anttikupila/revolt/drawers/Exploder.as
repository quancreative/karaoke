﻿package com.anttikupila.revolt.drawers {
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.anttikupila.revolt.drawers.Drawer;
		
	public class Exploder extends Drawer {
		private var pos:Number = 0;
		private var lineSprite:Sprite;
		
		function Exploder() {
			super();
			lineSprite = new Sprite();
			fourier = true;
		}
		
		override public function drawGFX(gfx:BitmapData, soundArray:Object):void {
			var size:Number = gfx.height*0.75;
			lineSprite.graphics.clear();
			lineSprite.graphics.beginFill(0xf09000);
			lineSprite.graphics.moveTo(-Math.sin(0)*2 + gfx.width/2 + gfx.width/8*Math.sin(pos), Math.cos(0) + gfx.height*0.65 + gfx.height/8*Math.cos(pos/2))
			for (var i in soundArray) {
				var lev:Number = soundArray[i];
				var a:uint = i;
//				lineSprite.graphics.lineStyle(1, 0x996600|(lev*360 << 8));
				if (i < soundArray.length/2) a += soundArray.length/2;
				var l:Number = Math.ceil((size/2)*(lev+0.5));
				var xPos:Number = -Math.sin(i/(soundArray.length/2)*Math.PI)*l*lev*3 + gfx.width/2 + gfx.width/8*Math.sin(pos);
				var yPos:Number = Math.cos(a/(soundArray.length/2)*Math.PI)*l*lev/2 + gfx.height*0.65 + gfx.height/8*Math.cos(pos/2);
				lineSprite.graphics.lineTo(xPos, yPos);
			}
			lineSprite.graphics.endFill();
			gfx.draw(lineSprite, null, null, "screen", null, true);
			pos += 0.01;
		}
	}
}