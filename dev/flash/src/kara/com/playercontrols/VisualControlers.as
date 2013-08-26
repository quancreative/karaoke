package com.playercontrols

{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public dynamic class VisualControlers extends MovieClip
	{
		
		
		public function VisualControlers(displayArea:MovieClip , borderSize:Number =10, posit:String = "TOP", vol:Number = 1) 
		
		{
			setControlPosition(displayArea , posit, vol);

		}
		
		
		public function setControlPosition (displayArea, posit:String= "TOP", vol:Number = 1) {				
			
					x = displayArea.x ;			
					this.bck.width = displayArea.width; 			
					this._localLoad.x  = displayArea.width - this._localLoad.width;
					this.fullScreen_btn.x = this._localLoad.x - this.fullScreen_btn.width - 10;
					this.volumeControl.volumeBtn.x = vol  * 50;
					
					
				switch (posit) {
					case "TOP":
					y = displayArea.y - this.bck.height;
					alpha = 1
					break;
					case "BOTTOM":
					y = displayArea.y + displayArea.height;
					alpha = 1
					break;
					case "OVER_TOP":
					y = displayArea.y ;
					alpha = 1
					break;
					case "OVER_BOTTOM":
					y = displayArea.y + displayArea.height -this.bck.height ;
					alpha = 1
					break;
					case "FULL_SCREEN":
						y = displayArea.y + displayArea.height -this.bck.height ;
					alpha = .5
					break;
				
			}

			
			
			}
		
		public  function setControlsforMedia(e:String) {

			switch (e) {
				case "jpg" :
				case "png" :
				case "bmp" :
				case "gif" :
			 
					this.progressBar.seeker.visible = false;
					this.progressBar.visible=true;
					this.buttons.visible=false;
					this.volumeControl.visible = false;
					this.progressBar.progressBar.visible = false;
					
				
					break;
				case "swf" :
					this.progressBar.seeker.visible = true;
					this.progressBar.visible=true;
					this.buttons.visible=true;
					this.volumeControl.visible=true;
				
					break;
					
				case "flv" :
				case "mp4" :
					this.progressBar.seeker.visible = true;
					this.progressBar.visible=true;
					this.buttons.visible=true;
					this.volumeControl.visible=true;

					break;
				case "mp3" :
					this.progressBar.seeker.visible = true;
					this.progressBar.visible=true;
					this.buttons.visible=true;
					this.volumeControl.visible=true;
					


					break;

				default :
			}

		}
		
	}
	
}