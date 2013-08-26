package  com.equalizer
{
	/**
	* 5 band EQ
	* Original @author leo@blixtsystems.com
	* http://www.blixtsystems.com/2008/05/simple-3-band-eq-with-flash-player-10/
	* 
	* Adapted by kevin@ciboloweb.com
	* http://ciboloweb.com/flex-sound-equalizer
	*/
	public class EQ	{		
		// List your frequencies here
		private var freqs:Array = new Array(512,1024,2048,4096,8192);
		
		// Set default equalizer gains
		public var gains:Array = new Array(1,1,1,1,1);
		
		// Cutoffs
		private var c0:Number = 0, c1:Number = 0, c2:Number = 0, 
					c3:Number = 0, c4:Number = 0, c5:Number = 0; 
		
		// Poles
		private var f0p0:Number = 0, f0p1:Number = 0, f0p2:Number = 0, f0p3:Number = 0;
		private var f1p0:Number = 0, f1p1:Number = 0, f1p2:Number = 0, f1p3:Number = 0;
		private var f2p0:Number = 0, f2p1:Number = 0, f2p2:Number = 0, f2p3:Number = 0;
		private var f3p0:Number = 0, f3p1:Number = 0, f3p2:Number = 0, f3p3:Number = 0;
		private var f4p0:Number = 0, f4p1:Number = 0, f4p2:Number = 0, f4p3:Number = 0;
        
		// Sample history buffer
        private var sdm1:Number = 0;
		private var sdm2:Number = 0;
        private var sdm3:Number = 0;
        
		public static const SAMPLE_RATE:int = 44100;
		
        static private const vsa:Number = 1.0 / 4294967295.0; // Very small amount (Denormal Fix)

        public function EQ() {
        	c0 = 2 * Math.sin(Math.PI * (freqs[0] / SAMPLE_RATE));
        	c1 = 2 * Math.sin(Math.PI * (freqs[1] / SAMPLE_RATE));
        	c2 = 2 * Math.sin(Math.PI * (freqs[2] / SAMPLE_RATE));
        	c3 = 2 * Math.sin(Math.PI * (freqs[3] / SAMPLE_RATE));
        	c4 = 2 * Math.sin(Math.PI * (freqs[4] / SAMPLE_RATE));
        }

        public function compute(sample:Number): Number {			
			var output:Number = 0;
			
			// Run computation on first frequency
			f0p0 += (c0 * (sample - f0p0)) + vsa;
			f0p1 += c0 * (f0p0 - f0p1);
			f0p2 += c0 * (f0p1 - f0p2);
			f0p3 += c0 * (f0p2 - f0p3); 
			output += (f0p3 * gains[0]);
			
			// Run computation on second frequency... and so on
			f1p0 += (c1 * (sample - f1p0)) + vsa;
			f1p1 += c1 * (f1p0 - f1p1);
			f1p2 += c1 * (f1p1 - f1p2);
			f1p3 += c1 * (f1p2 - f1p3);  
			output += (f1p3 * gains[1]);			
			
			f2p0 += (c2 * (sample - f2p0)) + vsa;
			f2p1 += c2 * (f2p0 - f2p1);
			f2p2 += c2 * (f2p1 - f2p2);
			f2p3 += c2 * (f2p2 - f2p3);  
			output += f2p3 * gains[2];
			
			f3p0 += (c3 * (sample - f3p0)) + vsa;
			f3p1 += c3 * (f3p0 - f3p1);
			f3p2 += c3 * (f3p1 - f3p2);
			f3p3 += c3 * (f3p2 - f3p3);  
			output += f3p3 * gains[3];
			
			f4p0 += (c4 * (sample - f4p0)) + vsa;
			f4p1 += c4 * (f4p0 - f4p1);
			f4p2 += c4 * (f4p1 - f4p2);
			f4p3 += c4 * (f4p2 - f4p3);  
			output += (sdm3 - f4p3) * (gains[4]); 
						
			// Shuffle history buffer
			sdm3 = sdm2;
			sdm2 = sdm1;
			sdm1 = sample;
			
			// Return result
			return output;
        }
		
	}
	
}