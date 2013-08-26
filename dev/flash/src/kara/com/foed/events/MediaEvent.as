/**
* @description  Events to be broadcast for media loading and playback.
*/
package com.foed.events {

	import flash.events.Event;
	
	public class MediaEvent extends Event {
		public static const RESIZE:String = "resizeDisplay";
		public static const START:String = "mediaStart";
		public static const STOP:String = "mediaStop";
		public static const PROGRESS:String = "mediaProgess";
		public static const COMPLETE:String = "mediaComplete";
		public static const METADATA:String = "mediaMetadata";
		public static const LOAD:String = "mediaLoad";
		private var _width:Number; 
		private var _height:Number; 
		private var _position:Number; 
		private var _duration:Number; 
		
		/**
		* @description  Constructor.
		*
		* @param  pType  The event name.
		* @param  pPosition  The position of the media, in milliseconds.
		* @param  pDuration  The duration of the media, in milliseconds.
		* @param  pWidth  The width of the media, when applicable, in pixels.
		* @param  pHeight  The height of the media, when applicable, in pixels.
		* @param  pBubbles  Whether the event bubbles up through the display list.
		* @param  pCancelable  Whether the event can be canceled as it bubbles.
		*/
		public function MediaEvent(
			pType:String,
			pPosition:Number=0,
			pDuration:Number=0,
			pWidth:Number=0,
			pHeight:Number=0,
			pBubbles:Boolean=false,
			pCancelable:Boolean=false
		) {
			super(pType, pBubbles, pCancelable);
			_position = pPosition;
			_duration = pDuration;
			_width = pWidth;
			_height = pHeight;
		}
		
		/**
		* @description  Returns a copy of the event instance.
		*
		* @returns  A copy of the event.
		*/
		override public function clone():Event {
			return new MediaEvent(
				type,
				_position,
				_duration,
				_width,
				_height,
				bubbles,
				cancelable
			);
		}

		/**
		* @description  Returns the width of the media, when applicable, in pixels.
		*
		* @returns  The width of the media in pixels.
		*/
		public function get width():Number { return _width; }

		/**
		* @description  Returns the height of the media, when applicable, in pixels.
		*
		* @returns  The height of the media in pixels.
		*/
		public function get height():Number { return _height; }

		/**
		* @description  Returns the current position of the media played back.
		*
		* @returns  The current position of the media in milliseconds.
		*/
		public function get position():Number { return _position; }

		/**
		* @description  Returns the duration of the media.
		*
		* @returns  The duration of the media in milliseconds.
		*/
		public function get duration():Number { return _duration; }
				
	}
	
}