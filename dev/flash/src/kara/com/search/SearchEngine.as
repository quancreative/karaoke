package com.search {
	import flash.utils.Dictionary;
	public class SearchEngine
	{
		private static var _dictionary:Dictionary;
		private static var _index:Array;
		private static var _filterText:String;
		private static var _currentLanguage:String;
		//
		public static function IndexContent(lang:String):void 
		{
			var i:int;
			var words:Array;
			var j:int;
			var word:String;
			var letter:String;
			_dictionary = new Dictionary();
			_index = new Array();
			_currentLanguage = lang;
			
			for each (var obj:Object in TextFeed.StoryList) {
				if (_currentLanguage=="en"){
					words = (obj.textEn + " " + obj.titleEn + " " + obj.keywordsEn).split(" ");
				} else {
					words = (obj.cleanTextGr + " " + obj.cleanTitleGr + " " + obj.keywordsGr).split(" ");
				}
				for (j = 0; j < words.length; j += 1) {
					word = words[j];
					word = cleanString(word.toLowerCase());
					
					if (word.length > 3) {
						try {
							if (_dictionary[word] == undefined) {
								_dictionary[word] = new Array();
							}
							_dictionary[word].push(obj.storyId);
						} catch (e:Error){
							trace(e,">"+word+"<");
						}
						if(_index.indexOf(word)==-1){
							_index.push(word);
						}
					}
				}
			}
			_index.sort();
			
		}
		private static function cleanString(text:String):String {
			var search:Array = ["“","”","\"","'",",","<br>","‘","’","\\(","\\)","\\.",";","»","«",":","<i>","</i>"];
			var tmp:String = text;
			var i:int;
			var pattern:RegExp;
			//var whitespace:RegExp = /\s*/g;
			//text = text.replace(whitespace, "");
			for(i=0; i<search.length; i+=1){
				pattern = new RegExp(search[i],"ig");
				tmp = tmp.replace(pattern, "");
			}
			
			return tmp;
		}
		public static function Find(text:String):Array{
			var j:int;
			var pattern:RegExp = /\s*/g;
			var tmp:Array;
			var results:Array = new Array();
			var tmpResult:Array = new Array();
			text = clearText(text.replace(pattern, "").toLowerCase());
			if (text.length > 0) {
				_filterText = text;
				tmp = _index.filter(filterFunc);
				for (var i:int = 0; i < tmp.length; i += 1) {
					for (j = 0; j < _dictionary[tmp[i]].length; j += 1) {
						if(_currentLanguage=="en"){
							tmpResult[_dictionary[tmp[i]][j]] = _dictionary[tmp[i]][j];
						} else {
							tmpResult[_dictionary[tmp[i]][j]] = _dictionary[tmp[i]][j];
						}
					}
				}
				for each (var id:String in tmpResult) {
					results.push(id);
				}
			}
			return results;
		}
		private static function filterFunc(element:*, index:int, arr:Array):Boolean{
			var e:String =  element as String;
			//if (e.indexOf(_filterText) !=-1) {
			// does a word exact match
			//if (e == _filterText) {
			if (e.indexOf(_filterText) !=-1) {
				return true;
			} else {
				return false;
			}
		}
		private static function clearText(text:String):String {
			var search:Array = ['ά','έ','ή','ί','ό','ύ','ώ'];
			var replace:Array = ['α', 'ε', 'η', 'ι', 'ο', 'υ', 'ω'];
			var pattern:RegExp;
			var result:String = text;
			var i:int;
			//
			for(i=0; i<search.length; i+=1){
				pattern = new RegExp(search[i],"ig");
				result = result.replace(pattern,replace[i]);
			}
			return result;
		}
	}
}
