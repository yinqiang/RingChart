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

package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import yq.charts.RingChart;
	
	/**
	 * RingChart Example
	 * @author Yinqiang
	 */
	[SWF(backgroundColor="#DDDDDD")]
	public class Example extends Sprite 
	{
		
		public function Example():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			const cx:Number = stage.stageWidth * 0.5;
			const cy:Number = stage.stageHeight * 0.5;
			
			var tf:TextFormat = new TextFormat("Microsoft YaHei", 20, 0xFFFFFF, true);
			var counts:Array;
			var texts:Array;
			var text:TextField;
			var i:int;
			
			counts = [0.15, 0.3, 0.4, 0.15];
			texts = [];
			for (i = 0; i < counts.length; i++)
			{
				text = new TextField;
				text.selectable = false;
				text.text = Math.floor(counts[i] * 100) + "%";
				text.setTextFormat(tf);
				text.filters = [ new DropShadowFilter(4, 45, 0, 0.3) ];
				texts[i] = text;
			}
			var ring:RingChart = new RingChart(
				counts,
				[0x0D9A91, 0xDC2166, 0xE89C2C, 0x5597C7],
				texts
			);
			ring.x = cx - ring.width * 0.6;
			ring.y = cy - ring.height * 0.6;
			addChild(ring);
			
			counts = [0.15, 0.3, 0.55];
			texts = [];
			for (i = 0; i < counts.length; i++)
			{
				text = new TextField;
				text.selectable = false;
				text.text = Math.floor(counts[i] * 100) + "%";
				text.setTextFormat(tf);
				text.filters = [ new DropShadowFilter(4, 45, 0, 0.3) ];
				texts[i] = text;
			}
			ring = new RingChart(
				counts,
				[0x0D9A91, 0xDC2166, 0xE89C2C],
				texts,
				0.2, 270 + 2.5*2, 58, 58, 180, 2.5
			);
			ring.x = cx + ring.width * 0.6;
			ring.y = cy - ring.height * 0.6;
			ring.filters = [ new DropShadowFilter(4, 45, 0, 0.3) ];
			addChild(ring);
			
			counts = [0.45, 0.3, 0.25];
			texts = [];
			tf = new TextFormat("Microsoft YaHei", 20, 0xFFFFFF, true);
			for (i = 0; i < counts.length; i++)
			{
				text = new TextField;
				text.selectable = false;
				text.text = Math.floor(counts[i] * 100) + "%";
				text.setTextFormat(tf);
				texts[i] = text;
			}
			ring = new RingChart(
				counts,
				[0x5597C7, 0xE89C2C, 0x0D9A91],
				texts,
				0.2, 270 + 2.5*2, 58, 58, 45, 2.5
			);
			ring.x = cx;
			ring.y = cy + ring.height * 0.6;
			ring.getChartLayer().filters = [ new DropShadowFilter(5, 90, 0, 0.3) ];
			addChild(ring);
			
			const textsLayer:Sprite = ring.getTextsLayer();
			const points:Array = ring.getPoints();
			var point:Point = points[0];
			textsLayer.filters = [ new DropShadowFilter(4, 45, 0, 0.3) ];
			textsLayer.graphics.lineStyle(2, 0xFFFFFF, 1);
			textsLayer.graphics.moveTo(point.x, point.y);
			textsLayer.graphics.lineTo(point.x + 50, point.y - 50);
			textsLayer.graphics.lineTo(point.x + 150, point.y - 50);
			text = texts[0];
			text.x = point.x + 100 - text.textWidth / 2;
			text.y = point.y - (50 + text.textHeight);
			point = points[1];
			textsLayer.graphics.moveTo(point.x, point.y);
			textsLayer.graphics.lineTo(point.x + 50, point.y - 50);
			textsLayer.graphics.lineTo(point.x + 150, point.y - 50);
			text = texts[1];
			text.x = point.x + 100 - text.textWidth / 2;
			text.y = point.y - (50 + text.textHeight);
			point = points[2];
			textsLayer.graphics.moveTo(point.x, point.y);
			textsLayer.graphics.lineTo(point.x - 50, point.y - 50);
			textsLayer.graphics.lineTo(point.x - 150, point.y - 50);
			text = texts[2];
			text.x = point.x - 100 - text.textWidth / 2;
			text.y = point.y - (50 + text.textHeight);
		}
		
	}
	
}