package com.jamwix;

import haxe.Json;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class JWDeltaDNA 
{
	
#if android
	private static var funcInit = JNI.createStaticMethod(
		"com.jamwix.JWDeltaDNA", 
		"initDeltaDNA", 
		"(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V");
	private static var funcRecordEvent =
		JNI.createStaticMethod("com.jamwix.JWDeltaDNA", "recordEvent", "(Ljava/lang/String;Ljava/lang/String;)V");
#elseif ios
	private static var funcInit = Lib.load("jwdeltadna", "jwdeltadna_init", 4);
	private static var funcRecordEvent = Lib.load("jwdeltadna", "jwdeltadna_record_event", 2);
#end

	private static var _initialized:Bool = false;
	
	public static function init(envKey:String, cHostname:String, eHostname:String, userId:String, useDebug:Bool = false):Void
	{
		if (_initialized) return;
#if android
		funcInit(envKey, cHostname, eHostname, userId, useDebug);
#elseif ios
		funcInit(envKey, cHostname, eHostname, userId);
#end
		_initialized = true;
	}

	public static function recordEvent(name:String, params:Dynamic):Void
	{
#if (android || ios)
		var paramsStr:String = null;
		try
		{
			paramsStr = Json.stringify(params);
		}
		catch (msg:String)
		{
			trace("Stringify error: " + msg + " ON: " + params);
			return;
		}

		funcRecordEvent(name, paramsStr);
#end
	}
}
