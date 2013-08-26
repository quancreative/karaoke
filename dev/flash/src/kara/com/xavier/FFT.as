package com.xavier
{
    import __AS3__.vec.*;

    public class FFT extends Object
    {
        var coslookup:Vector.<Number>;
        var cred:String = "Developed by xavierenigma: Eric Cheek, Xavier Case. Unauthorized use strictly prohibited";
        public var spectrum:Vector.<Number>;
        var sinlookup:Vector.<Number>;
        var imag:Vector.<Number>;
        var real:Vector.<Number>;
        var hammingTable:Vector.<Number>;
        var reverse:Vector.<uint>;
        var sampleRate:int;
        var timeSize:int;
        var spectrumSize:int;
        static const TWO_PI:Number = 6.28319;

        public function FFT(param1:int, param2:Number = 44100)
        {
            this.timeSize = param1;
            this.spectrumSize = param1 / 2 + 1;
            this.sampleRate = int(param2);
            this.allocateArrays();
            this.buildHammingTable();
            this.buildReverseTable();
            this.buildTrigTables();
            return;
        }// end function

        final private function cos(param1:uint) : Number
        {
            return this.coslookup[param1];
        }// end function

        public function allocateArrays() : void
        {
            this.spectrum = new Vector.<Number>(this.timeSize / 2 + 1, true);
            this.real = new Vector.<Number>(this.timeSize, true);
            this.imag = new Vector.<Number>(this.timeSize, true);
            return;
        }// end function

        final private function sin(param1:uint) : Number
        {
            return this.sinlookup[param1];
        }// end function

        private function buildReverseTable() : void
        {
            var _loc_4:uint = 0;
            var _loc_1:* = this.timeSize;
            this.reverse = new Vector.<uint>(_loc_1, true);
            this.reverse[0] = 0;
            var _loc_2:uint = 1;
            var _loc_3:* = _loc_1 / 2;
            while (_loc_2 < _loc_1)
            {
                
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    this.reverse[_loc_4 + _loc_2] = this.reverse[_loc_4] + _loc_3;
                    _loc_4 = _loc_4 + 1;
                }
                _loc_2 = _loc_2 << 1;
                _loc_3 = _loc_3 >> 1;
            }
            return;
        }// end function

        public function process(param1:Vector.<Number>) : void
        {
            this.doWindow(param1);
            this.bitReverseSamples(param1);
            this.fft();
            return;
        }// end function

        public function fft() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:int = 0;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_9:int = 1;
            while (_loc_9 < this.timeSize)
            {
                
                _loc_1 = this.cos(_loc_9);
                _loc_2 = this.sin(_loc_9);
                _loc_3 = 1;
                _loc_4 = 0;
                _loc_11 = 0;
                while (_loc_11 < _loc_9)
                {
                    
                    _loc_12 = _loc_11;
                    while (_loc_12 < this.timeSize)
                    {
                        
                        _loc_5 = _loc_9 + _loc_12;
                        _loc_6 = _loc_3 * this.real[_loc_5] - _loc_4 * this.imag[_loc_5];
                        _loc_7 = _loc_3 * this.imag[_loc_5] + _loc_4 * this.real[_loc_5];
                        this.real[_loc_5] = this.real[_loc_12] - _loc_6;
                        this.imag[_loc_5] = this.imag[_loc_12] - _loc_7;
                        this.real[_loc_12] = this.real[_loc_12] + _loc_6;
                        this.imag[_loc_12] = this.imag[_loc_12] + _loc_7;
                        _loc_12 = _loc_12 + (_loc_9 << 1);
                    }
                    _loc_8 = _loc_3;
                    _loc_3 = _loc_8 * _loc_1 - _loc_4 * _loc_2;
                    _loc_4 = _loc_8 * _loc_2 + _loc_4 * _loc_1;
                    _loc_11++;
                }
                _loc_9 = _loc_9 << 1;
            }
            var _loc_10:int = 0;
            while (_loc_10 < this.spectrumSize)
            {
                
                this.spectrum[_loc_10] = this.real[_loc_10] * this.real[_loc_10] + this.imag[_loc_10] * this.imag[_loc_10];
                _loc_10++;
            }
            return;
        }// end function

        private function buildTrigTables() : void
        {
            var _loc_1:* = this.timeSize;
            this.sinlookup = new Vector.<Number>(_loc_1, true);
            this.coslookup = new Vector.<Number>(_loc_1, true);
            var _loc_2:uint = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.sinlookup[_loc_2] = Math.sin((-Math.PI) / _loc_2);
                this.coslookup[_loc_2] = Math.cos((-Math.PI) / _loc_2);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function buildHammingTable() : void
        {
            this.hammingTable = new Vector.<Number>(this.timeSize, true);
            var _loc_1:int = 0;
            while (_loc_1 < this.timeSize)
            {
                
                this.hammingTable[_loc_1] = 0.54 - 0.46 * Math.cos(TWO_PI * _loc_1 / (this.timeSize - 1));
                _loc_1++;
            }
            return;
        }// end function

        private function bitReverseSamples(param1:Vector.<Number>) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.timeSize)
            {
                
                this.real[_loc_2] = param1[this.reverse[_loc_2]];
                this.imag[_loc_2] = 0;
                _loc_2++;
            }
            return;
        }// end function

        private function doWindow(param1:Vector.<Number>) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.timeSize)
            {
                
                param1[_loc_2] = param1[_loc_2] * this.hammingTable[_loc_2];
                _loc_2++;
            }
            return;
        }// end function

    }
}
