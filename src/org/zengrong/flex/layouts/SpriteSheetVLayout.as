package org.zengrong.flex.layouts
{
import flash.geom.Rectangle;

import mx.core.ILayoutElement;

import org.zengrong.flex.primitives.SpriteSheetBitmapImage;
import org.zengrong.flex.layouts.SpriteSheetCellVO;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;
import spark.primitives.BitmapImage;

/**
 * 实现对SpriteSheetBitmapImage的纵向排版
 * 更多的代码注释可以参考SpriteSheetHLayout
 * @author zrong
 * 创建时间：2012-02-06
 */
public class SpriteSheetVLayout extends SpriteSheetLayoutBase
{
	public function SpriteSheetVLayout()
	{
		super();
	}
	
	override public function updateDisplayList($w:Number, $h:Number):void
	{
		var __target:GroupBase = target;
		if(!__target) return;
		trace('layoutTarget wh:', __target.width, __target.height);
		if(cells && cells.length>0)
			updateImageListFromCell();
		else
			updateImageListFromElement();
	}
	
	/**
	 * 基于提供的Cell生成图像
	 */	
	private function updateImageListFromCell():void
	{
		var __num:int = cells.length;
		var __sizeList:Vector.<SpriteSheetCellVO> = new Vector.<SpriteSheetCellVO>;
		var __sizevo:SpriteSheetCellVO = null;
		var __target:GroupBase = target;
		var __bmpi:SpriteSheetBitmapImage = null;
		
		for(var i:int=0;i<__num;i++)
		{
			__bmpi = __target.getElementAt(i) as SpriteSheetBitmapImage;
			if(!__bmpi) continue;
			__sizevo = new SpriteSheetCellVO();
			__sizevo.bmp = __bmpi;
			__sizevo.originalW = __bmpi.getPreferredBoundsWidth();
			__sizevo.originalH = __bmpi.getPreferredBoundsHeight();
			__sizevo.explicitX = __bmpi.cell.x;
			__sizevo.explicitY = __bmpi.cell.y;
			__sizevo.fillMode = __bmpi.cell.fillMode;
			__sizevo.rowIndex = __bmpi.cell.rowIndex;
			__sizeList.push(__sizevo);
		}
		
		//根据fillMode更新xy的位置
		updateSpriteSheetCellVOList(__target.height, __sizeList);
		
		for (var j:int = 0; j < __sizeList.length; j++) 
		{
			__sizevo = __sizeList[j];
			__sizevo.bmp.setLayoutBoundsSize(__sizevo.measureW, __sizevo.measureH);
			__sizevo.bmp.setLayoutBoundsPosition(__sizevo.measureX, __sizevo.measureY);
			trace('图像在布局中的尺寸：', __sizevo.bmp.getLayoutBoundsWidth(), __sizevo.bmp.getLayoutBoundsHeight());
		}
		
	}
	
	/**
	 * 在检测到计算出的排列尺寸大于当前容器的最大尺寸的时候，重新计算
	 */	
	private function updateSpriteSheetCellVOList($layoutH:int, $sizeList:Vector.<SpriteSheetCellVO>):void
	{
		trace('需要更新sizevo：', $layoutH, ',共有'+$sizeList.length+'个对象');
		var __sizevo:SpriteSheetCellVO;
		//保存可用宽度，默认是最大宽度
		var __totalH:int = $layoutH;
		//记录需要平铺的对象的索引
		var __numRepeat:Vector.<int> = new Vector.<int>;
		var i:int=0;
		//计算百分比宽度的可分配性
		for (i = 0;i<$sizeList.length; i++) 
		{
			__sizevo = $sizeList[i];
			if(__sizevo.fillMode)
			{
				if(isNaN(__sizevo.bmp.cell.height))
					__numRepeat.push(i);
				else
					__sizevo.measureH = __sizevo.bmp.cell.height;
				trace('计算使用平铺的对象,__repeatVOList.length:', __numRepeat.length);
			}
			else
			{
				__sizevo.measureH = __sizevo.originalH;
				__totalH -= __sizevo.originalH;
				trace('计算没有使用平铺的对象,__totalH:', __totalH);
			}
		}
		if(__totalH<0) __totalH = 0;
		if(__numRepeat.length>0)
		{
			var __repeatH:Number = __totalH/__numRepeat.length;
			var __curRepeat:int = 0;
			//根据使用平铺的对象的总数量计算宽度，所有平铺的对象评分可用宽度
			for(i=0;i<__numRepeat.length;i++)
			{
				__curRepeat = __numRepeat[i];
				__sizevo = $sizeList[__curRepeat];
				__sizevo.measureH = __repeatH;
				trace('重新计算百分比宽度:', __sizevo.measureW);
			}
			//根据计算出的宽度更新x
			var __rect:Rectangle = new Rectangle();
			for ( i = 0; i < $sizeList.length; i++) 
			{
				__sizevo = $sizeList[i];
				//如果没有显示的设置x值，就使用默认的值
				if(isNaN(__sizevo.explicitX))
				{
					__sizevo.measureY = __rect.height;
					__rect.height += __sizevo.measureH;
				}
				else
				{
					//对于显示设定的x值，将下一个x的位置设定在当前的对象的后方
					__sizevo.measureY = __sizevo.explicitY;
					__rect.height = __sizevo.measureY + __sizevo.measureH;
				}
				trace('重新计算y,H:',__sizevo.measureH,',Y:',__sizevo.measureY);
			}
		}
	}
	
	/**
	 * 基于SpriteSheet提供的所有元素生成图像
	 */	
	private function updateImageListFromElement():void
	{
		var __locRect:Rectangle = new Rectangle();
		var __target:GroupBase = this.target;
		var __num:int = __target.numElements;
		var __bmpi:SpriteSheetBitmapImage = null;
		var __x:int = 0;
		var __y:int = 0;
		var __imageOriginalW:int = 0;
		var __imageOriginalH:int = 0;
		for(var i:int=0;i<__num;i++)
		{
			__bmpi = __target.getElementAt(i) as SpriteSheetBitmapImage;
			if(!__bmpi) continue;
			__imageOriginalW = __bmpi.getPreferredBoundsWidth();
			__imageOriginalH = __bmpi.getPreferredBoundsHeight();
			__y = __locRect.height;
			__locRect.height += __imageOriginalH;
			__bmpi.setLayoutBoundsSize(NaN, NaN);
			__bmpi.setLayoutBoundsPosition(__x, __y);
//			trace(__bmpi.getLayoutBoundsWidth(), __bmpi.getLayoutBoundsHeight());
//			trace('wh2:',__bmpi.width, __bmpi.height);
		}
	}
}
}
