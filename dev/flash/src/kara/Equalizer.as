package 
{
	import flash.display.MovieClip;
	import com.equalizer.EQ;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Radu
	 */
	public class  Equalizer extends MovieClip
	{
		
		public const _eqL:EQ = new EQ();
        public const _eqR:EQ = new EQ();
		 
		public function Equalizer() {
			for (var j = 1 ; j < 6; j++) {
				
				this["fq" + j].fasterBtn.addEventListener(MouseEvent.MOUSE_DOWN , setEq);
				this["fq" + j].slowerBtn.addEventListener(MouseEvent.MOUSE_DOWN , setEq);
				
				}
			
			for(var i = 0; i < _eqL.gains.length; i++){
                    _eqL.gains[i] =1;
                }
				for( i = 0; i < _eqR.gains.length; i++){
                    _eqR.gains[i] = 1;
                }
				
			
			
			}
			
			private function setEq(e:Event):void 
			{
				
			
				var value = Number(e.currentTarget.parent.currentSpeed.text);
				if (e.currentTarget.name == "fasterBtn") {
						e.currentTarget.parent.currentSpeed.text = value + 1
					}
				else {
					e.currentTarget.parent.currentSpeed.text = value-1
					}
					
				var pos = (Number(String(e.target.parent.name).charAt(2)) - 1);
				
				_eqL.gains[pos] = Number(e.currentTarget.parent.currentSpeed.text) ;
				
			}
	}
	
}