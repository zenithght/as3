////////////////////////////////////////////////////////////////////////////////
//
//  zengrong.net
//  创建者:	zrong
//  创建时间：2010-12-07
//  最后更新时间：2012-02-02
//
////////////////////////////////////////////////////////////////////////////////
package org.zengrong.utils
{
public class TimeUtil
{
	/**
	 * 基准日期。可用于所有需要基准日起的方法。例如：getTimestamp 
	 */	
	public static var baseDate:Date;
	
	/**
	 * 获取当前的时间，并格式化后作为字符串返回
	 * @param $separator 分隔符
	 * @param $dateOrSecond 若传递一个date，则格式化它；若传递一个正整数，则将其当作秒进行格式化；若传递0或负数，返回0；否则使用当前时间格式化。
	 */
	public static function getFormatedTime($separator:String=':', $dateOrSecond:*=null):String
	 {
		var __curHour:int = 0;
		var __curMinutes:int = 0;
		var __curSeconds:int = 0;
		var __second:Number = parseInt($dateOrSecond);
		if(isNaN(__second))
		{
			var __curDate:Date = ($dateOrSecond is Date)?$dateOrSecond:new Date();
			__curHour = __curDate.getHours();
			__curMinutes = __curDate.getMinutes();
			__curSeconds = __curDate.getSeconds();
		}
		else if(__second <= 0)
		{
			return '0';
		}
		else
		{
			__curSeconds = __second%60;
			__curMinutes = int(__second/60);
			__curHour = int(__second/3600);
		}
		
		var __curHourString:String = __curHour.toString();
		var __curMinutesString:String = __curMinutes.toString();
		var __curSecondsString:String = __curSeconds.toString();
		
		__curHourString = __curHour<10 ? ("0" + __curHourString) : __curHourString;			
		__curMinutesString = __curMinutes<10 ? ("0" + __curMinutesString) : __curMinutesString;			
		__curSecondsString = __curSeconds<10 ? ("0" + __curSecondsString) : __curSecondsString;
		
		return __curHourString + $separator +__curMinutesString + $separator +__curSecondsString;
	}
	
	public static function getFormatedMinAndSecond($sec:int):String
	{
		if($sec<=0) return '0';
		var __curSeconds:int = $sec%60;
		var __curMinutes:int = int($sec/60);
		
		var __curMinutesString:String = __curMinutes.toString();
		var __curSecondsString:String = __curSeconds.toString();
		
		__curMinutesString = __curMinutes<10 ? ("0" + __curMinutesString) : __curMinutesString;			
		__curSecondsString = __curSeconds<10 ? ("0" + __curSecondsString) : __curSecondsString;
		return __curMinutesString + ':' +__curSecondsString;
	}
	
	/**
	 * 获取当前的日期，并格式化后作为字符串返回
	 * @param $date 传递一个date用于格式化
	 */
	public static function getFormatedDate($separator:String='-', $date:Date=null):String
	{
		var __date:Date = null;
		if($date)
			__date = $date;
		else
			__date = new Date();
		
		var __curYear:int = __date.getFullYear();
		var __curMonth:int = __date.getMonth() + 1;
		var __curDate:int = __date.getDate();
		return __curYear + $separator + (__curMonth < 10 ? ('0' + __curMonth) : __curMonth) + $separator + ( __curDate < 10 ? ('0' + __curDate) : __curDate); 
	}
	 
	 /**
	  * 获取当前的日期和时间，并格式化后作为字符串返回
	  * @param $date 传递一个date用于格式化
	  */	
	 public static function getFormatedDateAndTime($date:Date=null):String
	 {
		 var __date:Date = null;
		 if($date)
			 __date = $date;
		 else
			 __date = new Date();
		 return getFormatedDate('-', __date) + ' ' + getFormatedTime(':', __date);
	 }
	 
	 /**
	  * 获取一个时间戳，它是从过去某一个时刻到现在的毫秒数。
	  * @param $oldDate 过去的某个时刻，默认为2010年国庆节
	  */	 
	 public static function getTimestamp($oldDate:Date=null):uint
	 {
		 var __oldDate:Date = $oldDate ? $oldDate : ( baseDate ? baseDate : (baseDate = new Date(2010, 9, 1)));
		 return uint((new Date()).time - __oldDate.time);
	 }
}
}
