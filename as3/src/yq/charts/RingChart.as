/*
The MIT License (MIT)

Copyright (c) 2014 Yinqiang Zhu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package yq.charts
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * 环形图表 - A chart of ring shape
	 * @author Yinqiang
	 */
	public class RingChart extends Sprite
	{
		/**
		 * 一个环面留白宽度
		 */
		protected var margin:Number;

		/**
		 * 环厚度
		 */
		protected var thickness:Number;

		/**
		 * 环面的中心点
		 */
		protected var points:Array;
		
		public function getPoints():Array { return points; }
		
		/**
		 * 图表层
		 */
		protected var chartLayer:Sprite;
		
		public function getChartLayer():Sprite { return chartLayer; }
		
		/**
		 * 标签层
		 */
		protected var textsLayer:Sprite;
		
		public function getTextsLayer():Sprite { return textsLayer; }
		
		/**
		 * RingChart
		 * @param    counts      统计数据，原数组不会被修改。例如：[0.15, 0.3, 0.4, 0.15]
		 * @param    colors      颜色组，例如：[0x0D9A91, 0xDC2166, 0xE89C2C, 0x5597C7]
		 * @param    texts       文本元件组
		 * @param    minmum      最小百分比
		 * @param    allAngle    环的最大角度
		 * @param    radius      内弧半径
		 * @param    thickness   环厚度
		 * @param    from        起始角度
		 * @param    margin      一个环面留白宽度
		 */
		public function RingChart(counts:Array, colors:Array, texts:Array = null,
									minmum:Number = 0.05, allAngle:Number = 360,
									radius:Number = 58, thickness:Number = 58,
									from:Number = 160, margin:Number = 2.5)
		{
			super();
			
			const radiusInside:Number = radius;
			const radiusOutside:Number = radius + thickness;
			const len:int = counts.length;
			var to:Number = 0;
			var i:int;
			
			counts = checkCounts(counts.concat(), minmum);
			
			this.thickness = thickness;
			this.margin = margin;
			points = [];
			
			chartLayer = new Sprite();
			addChild(chartLayer);
			from += margin;
			for (i = 0; i < len; i++)
			{
				to = from - allAngle * counts[i];
				chartLayer.graphics.beginFill(colors[i]);
				points[i] = drawArc(radiusInside, radiusOutside, from - margin, to + margin, 1);
				chartLayer.graphics.endFill();
				from = to;
			}
			
			if (texts != null)
			{
				textsLayer = new Sprite();
				addChild(textsLayer);
				for (i = 0; i < len; i++)
				{
					var text:TextField = texts[i] as TextField;
					text.x = points[i].x - text.textWidth * 0.5;
					text.y = points[i].y - text.textHeight * 0.5;
					textsLayer.addChild(text);
				}
			}
		}
		
		/**
		 * 画单个环面
		 * @param    radiusInside   内弧半径
		 * @param    radiusOutside  外弧半径
		 * @param    angleFrom      起始角度
		 * @param    angleTo        结束角度
		 * @param    precision      圆弧精细度
		 * @return   环型中心坐标
		 */
		protected function drawArc(radiusInside:Number, radiusOutside:Number,
									angleFrom:Number, angleTo:Number,
									precision:Number = 1):Point
		{
			angleFrom = angleFrom % 360;
			angleTo = angleTo % 360;
			
			const degreeToRadian:Number = 0.0174532925;
			var angle_diff:Number = (angleTo - angleFrom) % 360;
			var steps:Number = Math.abs(Math.round(angle_diff * precision));
			var angle:Number = angleFrom;
			var px:Number = radiusInside * Math.cos(angle * degreeToRadian);
			var py:Number = radiusInside * Math.sin(angle * degreeToRadian);
			var radian:Number;
			var i:int;
			
			// inside
			chartLayer.graphics.moveTo(px, py);
			for (i = 1; i < steps; i++)
			{
				radian = (angleFrom + angle_diff / steps * i) * degreeToRadian;
				chartLayer.graphics.lineTo(radiusInside * Math.cos(radian), radiusInside * Math.sin(radian));
			}
			
			// outside
			for (i = steps; i >= 0; i--)
			{
				radian = (angleFrom + angle_diff / steps * i) * degreeToRadian;
				chartLayer.graphics.lineTo(radiusOutside * Math.cos(radian), radiusOutside * Math.sin(radian));
			}
			chartLayer.graphics.lineTo(px, py);
			
			radian = (angleFrom + angle_diff * 0.5) * degreeToRadian;
			radiusOutside -= thickness * 0.5;
			var center:Point = new Point(radiusOutside * Math.cos(radian), radiusOutside * Math.sin(radian));
			
			return center;
		}
		
		/**
		 * 检查每条统计数据不会因过小而显示不出，在需要时会重新分配百分比来满足画图的需要。
		 * @param    counts    统计数据
		 * @param    minmum    最小百分比
		 * @return   修正后的统计数据
		 */
		protected function checkCounts(counts:Array, minmum:Number):Array
		{
			const len:int = counts.length;
			const minX2:int = minmum * 2;
			var tmp:Array;
			var fix:Number;
			var i:int;
			var j:int;
			var n:int;
			
			for (i = 0; i < len; i++)
			{
				if (counts[i] < minmum)
				{
					tmp = [];
					fix = minmum - counts[i];
					n = 0;
					
					for (j = 0; j < i; j++)
					{
						if (counts[j] >= minX2)
						{
							tmp.push(j);
							n += 1;
						}
					}
					for (j = i + 1; j < len; j++)
					{
						if (counts[j] >= minX2)
						{
							tmp.push(j);
							n += 1;
						}
					}
					
					counts[i] = minmum;
					fix /= Math.max(1, n);
					n = tmp.length;
					
					for (j = n; j >= 0; j--)
						counts[tmp[j]] -= fix;
					tmp = null;
				}
			}
			
			return counts;
		}
	
	}

}