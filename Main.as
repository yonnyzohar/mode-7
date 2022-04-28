package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.events.*;
	import flash.display.*;
	import flash.ui.Keyboard;

	public class Main extends MovieClip {

		var Model: Object = {
			up: false,
			down: false,
			left: false,
			right: false,
			G: false,
			H: false,
			N: false,
			B: false
		};
		
		var TURN_SPEED:Number = 0;
		var TURN_INCREMENT:Number = 1;

		var MAX_SPEED: Number = 2;
		var INCREMENT: Number = 0.1;
		var SPEED: Number = 0;
		var H: Number = 5;
		var bmp: Bitmap;
		var bd: BitmapData = new IMG();
		var mountains:BitmapData = new Mountains();


		var mc: MovieClip = new MovieClip();

		var mc2: MovieClip = new MovieClip();


		var bmp2: Bitmap;
		var bmd2: BitmapData = new BitmapData(640, 480, false);


		var pos: Point = new Point(640 / 2, 480 / 2);
		var angle: int = 0;
		var near: Number = 20;
		var far: Number = 200;
		var fov_h: Number = 30;
		
		var stars:Array = [];
		
		public function Main() {
			// constructor code
			bmp = new Bitmap(bd);
			mc.addChild(bmp);
			stage.addChild(mc);
			stage.addChild(mc2);
			bmp2 = new Bitmap(bmd2);
			stage.addChild(bmp2);
			bmp2.x = stage.stageWidth / 2;
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, myKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, myKeyUp);
			
		}
		
	


		function update(e: Event): void {

			var angleRad: Number = Math.PI / 180 * angle;
			var leftAngleRad: Number = Math.PI / 180 * (angle - fov_h);
			var rightAngleRad: Number = Math.PI / 180 * (angle + fov_h);

			var bottomLeftPX: Point = new Point(Math.cos(leftAngleRad) * near, Math.sin(leftAngleRad) * near);
			var topLeftPX: Point = new Point(Math.cos(leftAngleRad) * far, Math.sin(leftAngleRad) * far);

			var bottomRightPX: Point = new Point(Math.cos(rightAngleRad) * near, Math.sin(rightAngleRad) * near);
			var topRightPX: Point = new Point(Math.cos(rightAngleRad) * far, Math.sin(rightAngleRad) * far);

			bottomLeftPX.x += pos.x;
			bottomLeftPX.y += pos.y;

			topLeftPX.x += pos.x;
			topLeftPX.y += pos.y;

			bottomRightPX.x += pos.x;
			bottomRightPX.y += pos.y;

			topRightPX.x += pos.x;
			topRightPX.y += pos.y;

			mc2.graphics.clear();
			mc2.graphics.lineStyle(1);
			mc2.graphics.drawCircle(pos.x, pos.y, 3);
			mc2.graphics.moveTo(bottomLeftPX.x, bottomLeftPX.y);
			mc2.graphics.lineTo(bottomLeftPX.x, bottomLeftPX.y);
			mc2.graphics.lineTo(topLeftPX.x, topLeftPX.y);
			mc2.graphics.lineTo(topRightPX.x, topRightPX.y);
			mc2.graphics.lineTo(bottomRightPX.x, bottomRightPX.y);
			mc2.graphics.lineTo(bottomLeftPX.x, bottomLeftPX.y);

			/*
			1 - top left
			2 - top right
			3 - bottom left
			4 - bottom right
			*/

			//var time:Number = getTimer();
			bmd2.fillRect(new Rectangle(0, 0, bmd2.width, bmd2.height/2), 0x000000);
			//bmd2.copyPixels(mountains, new Rectangle(0,0,mountains.width, mountains.height), new Point(angle,125), null, null, true);
			
			//return;

			drawImage({
				topLeft: topLeftPX,
				topRight: topRightPX,
				btmLeft: bottomLeftPX,
				btmRight: bottomRightPX
			});

			//trace(getTimer() - time);
			if(SPEED > 0)
			{
				angle += TURN_SPEED;
			}
			
			

			if (Model.left) {
				//
				if (TURN_SPEED > -MAX_SPEED) {
					TURN_SPEED -= TURN_INCREMENT;
				}
			}

			if (Model.right) {
				//angle += TURN_SPEED;
				
				if (TURN_SPEED < MAX_SPEED) {
					TURN_SPEED += TURN_INCREMENT;
				}
			}
			
			if(!Model.left && !Model.right)
			{
				if (TURN_SPEED > 0) {
					TURN_SPEED -= TURN_INCREMENT;
				}
				else if(TURN_SPEED < 0)
				{
					TURN_SPEED += TURN_INCREMENT;
				}
			}

			if (Model.up) {

				if (SPEED < MAX_SPEED) {
					SPEED += INCREMENT;
				}


			} else {
				if (SPEED > 0) {
					SPEED -= INCREMENT;
				}
			}
			
			if (Model.down) {
				if (SPEED > 0) {
					SPEED -= INCREMENT;
				}
			}


			var angleRad: Number = Math.PI / 180 * angle;
			var SIN: Number = Math.sin(angleRad) * SPEED;
			var COS: Number = Math.cos(angleRad) * SPEED;


			pos.x += COS;
			pos.y += SIN;

			mc.x -= COS;
			mc.y -= SIN;

			mc2.x -= COS;
			mc2.y -= SIN;

			

			if (Model.G) {
				near += H;
				trace("near " + near);
			}
			if (Model.B) {
				near -= H;
				trace("near " + near);
			}

			if (Model.H) {
				far += H;
				trace("far " + far);
			}
			if (Model.N) {
				far -= H;
				trace("far " + far);
			}
			
			
			
			/*
			if(angle > 360)
			{
				angle -= 360;
			}
			if(angle < 0)
			{
				angle += 360;
			}
*/

			//stage.removeEventListener(Event.ENTER_FRAME, update);
		}



		function drawImage(o: Object): void {
			var p1: Point = o.topLeft;
			var p2: Point = o.topRight;
			var p3: Point = o.btmLeft;
			var p4: Point = o.btmRight;

			var leftLen: int = getDistance(p1, p3);
			var rightLen: int = getDistance(p2, p4);

			var startRowsAngle: Number;
			var startRowsLen: Number;
			var fromPStart: Point;
			var fromPEnd: Point;

			var endRowsAngle: Number;
			var endRowsLen: Number;
			var toPStart: Point;
			var toPEnd: Point;



			startRowsLen = Number(leftLen);
			endRowsLen = Number(rightLen);
			fromPStart = p1;
			fromPEnd = p3;
			toPStart = p2;
			toPEnd = p4;


			startRowsAngle = getAngle(fromPStart, fromPEnd);
			endRowsAngle = getAngle(toPStart, toPEnd);

			var startRowCos: Number = -1;
			var startRowSin: Number = -1;
			var startrowSinDist:Number;
			var startrowCosDist:Number;

			var endRowCos: Number = -1;
			var endRowSin: Number = -1;
			var endrowSinDist:Number;
			var endrowCosDist:Number;
			
			
			var halfBd:Number = bmd2.height /2;

			for (var row: Number = halfBd; row < bmd2.height; row++) {
				//looks best but does not make sense!
				//var rowPer: Number = 1 - (bmd2.height / row);
				//naive and looks like shit
				//var rowPer: Number =  ( ((row - halfBd)/2) / halfBd);
				//this makes most sense
				var rowPer: Number = easeOutQuint( (row - halfBd)/2,  0 , 1, halfBd);
				//
				//trace(rowPer);

				//we are getting an angle from the far to the near, not near to far. hence 0 percent is exactly on FAR
				if (startRowCos == -1) {
					startRowCos = Math.cos(startRowsAngle);
					startRowSin = Math.sin(startRowsAngle);
					startrowSinDist = (startRowSin * startRowsLen);
					startrowCosDist = (startRowCos * startRowsLen);
				}

				//rows in the trapeze start at the distance and move towards the player
				var currStartX: int = startrowCosDist * rowPer;
				var currStartY: int = startrowSinDist * rowPer;
				//add the offset of the start pixel
				currStartX += fromPStart.x;
				currStartY += fromPStart.y;


				if (endRowCos == -1) {
					endRowCos = Math.cos(endRowsAngle);
					endRowSin = Math.sin(endRowsAngle);
					endrowSinDist = (endRowSin * endRowsLen);
					endrowCosDist = (endRowCos * endRowsLen);
				}

				var currEndX: Number = endrowCosDist * rowPer;
				var currEndY: Number = endrowSinDist * rowPer;
				//add the offset of the start pixel
				currEndX += toPStart.x;
				currEndY += toPStart.y;

				var cp1: Point = new Point(currStartX, currStartY);
				var cp2: Point = new Point(currEndX, currEndY);

				var slopeStartToEndAngle: Number = getAngle(cp1, cp2);
				var distanceBetweenCurrs: int = getDistance(cp1, cp2);

				var COS: Number = -1;
				var SIN: Number = -1;
				var SIN_dist:Number;
				var COS_dist:Number ;

				for (var col: Number = 0; col < bmd2.width; col++) {

					if (COS == -1) {
						COS = Math.cos(slopeStartToEndAngle);
						SIN = Math.sin(slopeStartToEndAngle);
						SIN_dist = SIN * distanceBetweenCurrs;
						COS_dist = COS * distanceBetweenCurrs;
					}

					var colPer: Number = col / bmd2.width;
					var currColX: int = COS_dist * colPer;
					var currColY: int = SIN_dist * colPer;
					currColX += cp1.x;
					currColY += cp1.y;
					var pixel: uint = bd.getPixel(currColX, currColY);
					//bmd2.setPixel(col,  row, pixel);
					//half bd is the start row in the center of the screen
					bmd2.setPixel(col, row, pixel);

				}

			}

		}

		function getAngle(from: Point, to: Point): Number {
			var angle: Number = Math.atan2(to.y - from.y, to.x - from.x);
			return angle;
		}

		function getDistance(p1: Point, p2: Point): int {
			var dX: Number = p1.x - p2.x;
			var dY: Number = p1.y - p2.y;
			var dist: Number = Math.sqrt(dX * dX + dY * dY);
			return dist;
		}

		//jump by increment
		function easeOutQuad(time: Number, duration: Number, start: Number, end: Number): Number {
			time /= duration;
			return -end * time * (time - 2) + start;
		};
		//bigger increment
		function easeOutCubic(t, b, c, d): Number {
			t /= d;
			t--;
			return c * (t * t * t + 1) + b;
		};
		//even bigger increment
		function easeOutQuart(t, b, c, d): Number {
			t /= d;
			t--;
			return -c * (t * t * t * t - 1) + b;
		};
		//even bigger increment
		function easeOutQuint(t, b, c, d): Number {
			t /= d;
			t--;
			return c * (t * t * t * t * t * t * t + 1) + b;
		};




		function myKeyDown(e: KeyboardEvent): void {

			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) {
				Model.up = true;
				Model.down = false;
			}
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S) {

				Model.down = true;
				Model.up = false;
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.D) {

				Model.left = true;
				Model.right = false;
			}
			if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.A) {

				Model.right = true;
				Model.left = false;
			}


			if (e.keyCode == Keyboard.G) {
				Model.G = true;
			}
			if (e.keyCode == Keyboard.H) {
				Model.H = true;
			}

			if (e.keyCode == Keyboard.N) {
				Model.N = true;
			}

			if (e.keyCode == Keyboard.B) {
				Model.B = true;
			}

		}




		function myKeyUp(e: KeyboardEvent): void {

			if (e.keyCode == Keyboard.UP || e.keyCode == Keyboard.W) {
				Model.up = false;
			}
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.S) {

				Model.down = false;
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.D) {

				Model.left = false;
			}
			if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.A) {

				Model.right = false;
			}


			if (e.keyCode == Keyboard.G) {
				Model.G = false;
			}
			if (e.keyCode == Keyboard.H) {
				Model.H = false;
			}

			if (e.keyCode == Keyboard.N) {
				Model.N = false;
			}

			if (e.keyCode == Keyboard.B) {
				Model.B = false;
			}

		}

	}

}