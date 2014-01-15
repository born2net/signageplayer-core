// By Sean S. Levy 12-17-06
// String Extension Class for AS 2.0
// Commands based on the Great Tcl ( Tool control Language ) 

// import mx.utils.StringUtil;


package {


// import com.lib.RegExp;


	public class StrExt {
		
		
		
		/*
		#############################################################  
		
		Replace String		
		
		#############################################################
		*/		
		
		private var _strValue:String
		
		public function replaceStr(replaceString:String, withString:String, input:String):String {
			
			if ( replaceString == null || withString == null || input == null) { return ""; }

			var myArray:Array = input.split(replaceString);

			var str:String = myArray.join(withString)

			return str;
		}
		
		public static function ReplaceStr(replaceString:String, withString:String, input:String):String {
			
			if ( replaceString == null || withString == null || input == null) { return ""; }

			var myArray:Array = input.split(replaceString);

			var str:String = myArray.join(withString)

			return str;
		}
		
		public function prePlace(input:String):void {

			_strValue = this.replaceStr("&reg;", "\u00ae", _strValue);			
			_strValue = this.replaceStr("&copy;", "\u00a9", _strValue);
			_strValue = this.replaceStr("&trade;", "\u2122", _strValue);
			_strValue = this.replaceStr("&ndash;", "\u2013", _strValue);
			_strValue = this.replaceStr("&mdash;", "\u2014", _strValue);
			
		}
		
		public function get strValue():String{
			return _strValue;
		}
		
		
		
		/*
		#############################################################  
		
		cleanReturn
		
		   Remove spaces and braces
		
		#############################################################
		*/
	   
	    public function cleanReturn ( sVar:String ):String {
	    	
	    	var result:String = "";
	       
	        result = trimleft(sVar, " ");
		    
	  	    result = trimleft(result, "{");
	  	    
	   	    result = trimright(result, " ");
		    
	  	    result = trimright(result, "}");
	
			return result;
	    }
		

		
		/*
		#############################################################  
		
		lindex
	
		returns the index offset of a string using space delimiter
		you can use the offset index number or the keyword first or end
	
		method: lindex ( sList:String, sIndex:String ):String 
	
		Args: (1) a list such as "Hello World I am here"
		Args: (2) a string index such as first, end or string numeric such as 1,2,3 ...
		Return: the string offset from index
	
		Example:
	
		var oStrExt:StrExt = new StrExt();
		var oResult:String = oStrExt.lindex("Hello World, {Im here} and so are you", "1");
		trace(oResult); // Im here
		Note that Curley braces protect spaces
	
		Notes:
		Make sure you do not open braces such as "{hello world {I am good}"  without closing
	
		
		#############################################################
		*/
	   
	   public function lindex ( sList:String, sIndexKey:String ):String {
	        
	             
	        var counter:Number = -1;
	        
	        var nState:Number = -1;   
			
			var aListSrc:Array = sList.split(" ");
	
			var aListDst:Array = new Array();
	
	   
	        // Translate keywords 
			   	
			switch (sIndexKey) {
				
				case "first": {
	
					var sIndex:String = "0";
	
					break;
				}
	
				case "end": {
	
					sIndex = String(aListSrc.length - 1);
	
					break;
				}
				
				default: {
	
					sIndex = String(sIndexKey);
	
				}
			}		
			
			for (var i:Number = 0 ; i < aListSrc.length ; i++ ) {			
				
				counter++;
				
				// If Open Mode
				
				if ( aListSrc[i].charAt(0) == "{" ) {
	
					// trace("OPEN: " + counter + " " + aListSrc[i]);
	
					nState = 1;
	
					aListDst[counter] = aListSrc[i] + " ";				
	
				// If in Open and going to close
				
				} else if ( nState == 1 && aListSrc[i].charAt(aListSrc[i].length - 1) == "}"  ) {
					
					counter--;
					
					// trace("CLOSE: " + counter + " " + aListSrc[i] );
					
					nState = 0;
					
					aListDst[counter] += ( aListSrc[i] + " ");
					
					// trace("CLOSE" + counter + " " + sIndex + aListSrc[i].toString());
					
					if ( String(counter) == sIndex ) {
						
						return cleanReturn(aListDst[counter]);
						
					}
					
					// counter++;
					
			    // Continue mode
			    
				} else if ( nState == 1 && aListSrc[i].charAt(aListSrc[i].length - 1) != "}"  ) {
					
					counter--
					
					// trace("CONTINUE: " + counter + " " + aListSrc[i]);
					
					aListDst[counter] += aListSrc[i] + " ";
					
	
				
				// Copy mode
					
				} else {
			
					aListDst[counter] = aListSrc[i];				
	
				}
				
				
				// If no braces found than just return result
				
				if (sIndex == String(i) && nState == -1 ) {				
	
	 				return cleanReturn(aListSrc[i]);
					
				}
			}
			
			if ( sIndexKey == "end" && nState != -1  ) {
				
				sIndex = String(aListDst.length - 1);
			}
			
			// for (var x = 0 ; x < aListDst.length ; x++ ) {
	
				// trace(x + " " + aListDst[x]);
			// }
	
	        // return empty string if use specified range that's too high 
	           	    
	   	    if ( aListDst[sIndex] == undefined ) {
	
	   	    	aListDst[sIndex] = "";
	
	   	    }
	
	        return cleanReturn(aListDst[sIndex]);
	
	   
		}
	
		
	   	/*
	   	#############################################################
	  
	    isVarEmpty
	
		#############################################################
		*/
	  
		public function isVarEmpty ( sText:String ):Boolean {
	
			var pattern:RegExp = new RegExp("^(\ )+$|^()$");
			
			if ( pattern.test(sText) ) {
				return true;
			}
			
			return false;
	   	}
		
		
		static public function IsVarEmpty ( sText:String ):Boolean {
	
			var pattern:RegExp = new RegExp("^(\ )+$|^()$");
			
			if ( pattern.test(sText) ) {
				return true;
			}
			
			return false;
	   }
	
		
	   	
	   	/*
	   	#############################################################
	  
	    trimright
	    
	     	removes character from left of word
	    	if sTrimChar is given as an argument remove it from end
	    	of word. if sTrimChar is not given as an arg than we 
	    	we remove white space.
	    	
	    	Example:
	    	
	    	trace("Result: " + oStrExt.trimright("{Sean Levy}","}"));
	
		#############################################################
		*/
	  
		public function trimright ( sText:String, sTrimChar:String ):String {
	
	       var sResult:String = "";
	   	      	
	   	   for (var i:Number = 0 ; i <= sText.length ; i++) {
	   	   	
	   	   	    if ( i != 0 ) {
	   	   	
	    	 	   	var sLastChar:String = sText.charAt(sText.length - i);
	     	   	
	     		   	if ( sLastChar == sTrimChar ) {
	   		   		
	     	   			continue;
	     	   			
	     	   		} else {
	     		   		     		   		
	     	   			return sText.substr(0,(sText.length - (i - 1)));
	     	   			
	     	   		}
	     	   		
	   	   	    }   	    	
	   	   }   
	
		return "";	
	
	   }

	   	/*
		#############################################################
	  
	    safeTcl
	
		#############################################################
		*/

	   	
		public function safeTcl(value:String):String {
				
				value = this.replaceStr("\"","",value);
				value = this.replaceStr("\{","",value);
				value = this.replaceStr("\}","",value);								
				value = this.replaceStr("\[","",value);
				value = this.replaceStr("\]","",value);				
				value = this.replaceStr("\&","and",value);								
				value = this.replaceStr("\;",".",value);	
				value = this.cleanReturn(value);															

				return value;
				
			}	   	
	   	
	   	/*
		#############################################################
	  
	    trimleft
	    
	     	removes character from right of word
	    	if sTrimChar is given as an argument remove it from end
	    	of word. if sTrimChar is not given as an arg than we 
	    	we remove white space.
	    	
	    	Example:
	    	
	    	trace("Result: " + oStrExt.trimleft("{Sean Levyyy}"y"}"));
	
		#############################################################
		*/
	  
	   	public function trimleft ( sText:String, sTrimChar:String ):String {
	
	       var sResult:String = "";
	   	
	   	   // trace(sTrimChar);
	   	    
	   	   
	   	   for (var i:Number = 0 ; i <= sText.length ; i++) {
	   	   	
	     	   	// trace( i + " > " + sText.charAt(i));
	     	   	
	      	   	var sChar:String = sText.charAt(i);
	      	   	
	   		   	if ( sChar == sTrimChar ) {
			  				  		     		   		
	   	   			continue;
	   	   			
	   		   	} else {
	   		   		
	 	  	   		return sText.substr(i,(sText.length));
	 	  	   		
	   		   	}
	   	   }   
	
		return "";
		
	
  	   }  	
	
	}	
}