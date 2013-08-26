package com.xavier
{
    import flash.text.*;

    public class XText extends TextField
    {
        public var LEFT:String = "left";
        public var CENTER:String = "center";
        public var format:TextFormat;
        public var RIGHT:String = "right";

        public function XText()
        {
            mouseEnabled = false;
            autoSize = this.LEFT;
            this.format = new TextFormat();
            this.format.size = 12;
            return;
        }// end function

        public function setAlignment(param1:String) : void
        {
            autoSize = param1;
            return;
        }// end function

        public function setBorder(param1:uint) : void
        {
            border = true;
            borderColor = param1;
            return;
        }// end function

        public function setText(param1:String) : void
        {
            text = param1;
            setTextFormat(this.format);
            return;
        }// end function

        public function setBackground(param1:uint) : void
        {
            background = true;
            backgroundColor = param1;
            return;
        }// end function

        public function setFontSize(param1:int) : void
        {
            this.format.size = param1;
            setTextFormat(this.format);
            return;
        }// end function

    }
}
