package
{
	public class RC4 
	{ 
		/**
		* Variables
		* @exclude
		*/
		
		private static var m_nBox:Array = new Array(256);
		
		/**
		* Encrypts a string with the specified key.
		*/
		public static function encrypt(src:String, key:String):String {
			var mtxt:Array = strToChars(src);
			var mkey:Array = strToChars(key);
			var result:Array = calculate(mtxt, mkey);
			return charsToHex(result);
		}
		
		/**
		* Decrypts a string with the specified key.
		*/
		public static function decrypt(src:String, key:String):String {
			var mtxt:Array = hexToChars(src);
			var mkey:Array = strToChars(key);
			var result:Array = calculate(mtxt, mkey);
			return charsToStr(result);
		}
		
		/**
		* Private methods.
		*/

		private static function initialize(pwd:Array):void 
		{
			var asciiChars:Array = new Array(256);
			var index2:Number = 0;
			var tempSwap:Number;
			var intLength:Number = pwd.length;
			for (var count:Number=0; count<256; count++) 
			{
				asciiChars[count] = pwd[(count%intLength)];
				m_nBox[count] = count;
			}
			
			for (count = 0; count<256; count++) 
			{
				index2 = (index2+m_nBox[count]+asciiChars[count]) % 256;
				tempSwap = m_nBox[count];
				m_nBox[count] = m_nBox[index2];
				m_nBox[index2] = tempSwap;
			}
		}
		
		public static function calculate(plaintxt:Array, psw:Array):Array 
		{
			initialize(psw);
			var i:Number = 0; var j:Number = 0;
			var cipher:Array = new Array();
			var k:Number, temp:Number, cipherby:Number;
			for (var a:Number = 0; a<plaintxt.length; a++) {
				i = (i+1) % 256;
				j = (j+m_nBox[i])%256;
				temp = m_nBox[i];
				m_nBox[i] = m_nBox[j];
				m_nBox[j] = temp;
				var idx:Number = (m_nBox[i]+m_nBox[j]) % 256;
				k = m_nBox[idx];
				cipherby = plaintxt[a]^k;
				cipher.push(cipherby);
			}
			return cipher;
		}
		public static function charsToHex(chars:Array):String {
			var result:String = new String("");
			var hexes:Array = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
			for (var i:Number = 0; i<chars.length; i++) {
				result += hexes[chars[i] >> 4] + hexes[chars[i] & 0xf];
			}
			return result;
		}
		public static function hexToChars(hex:String):Array {
			var codes:Array = new Array();
			for (var i:Number = (hex.substr(0, 2) == "0x") ? 2 : 0; i<hex.length; i+=2) {
				codes.push(parseInt(hex.substr(i, 2), 16));
			}
			return codes;
		}
		public static function charsToStr(chars:Array):String {
			var result:String = new String("");
			for (var i:Number = 0; i<chars.length; i++) {
				result += String.fromCharCode(chars[i]);
			}
			return result;
		}
		public static function strToChars(str:String):Array {
			var codes:Array = new Array();
			for (var i:Number = 0; i<str.length; i++) {
				codes.push(str.charCodeAt(i));
			}
			return codes;
		}
	
	}
}