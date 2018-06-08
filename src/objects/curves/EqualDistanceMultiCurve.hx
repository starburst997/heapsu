package objects.curves;

import data.*;
import objects.*;
import scenes.*;

using FS;
using FSHeaps;
using Lambda;

class EqualDistanceMultiCurve extends Curve {
    
    public var startAngle:Float;
    public var endAngle:Float;

    public var ncurve:Int;

    public function new(hitObject:HitObject, scaled:Bool = true) {
        super(hitObject, scaled);
    }

    public function init(curvesList:Array<CurveType>){
        // now try to creates points the are equidistant to each other
		this.ncurve = (hitObject.pixelLength / Curve.CURVE_POINTS_SEPERATION).int();
		this.curve = [];

		var distanceAt = 0.0;
		var curPoint = 0;
        var iter = curvesList.iterator();
		var curCurve = iter.next();
		var lastCurve = curCurve.curve[0];
		var lastDistanceAt = 0.0;

		// length of Curve should equal pixel length (in 640x480)
		var pixelLength = hitObject.pixelLength * HitObject.xMultiplier;

		// for each distance, try to get in between the two points that are between it
		(ncurve + 1).iter(i -> {
			var prefDistance = (i * pixelLength / ncurve).int();
			while (distanceAt < prefDistance) {
				lastDistanceAt = distanceAt;
				lastCurve = curCurve.curve[curPoint];
				curPoint++;

				if (curPoint >= curCurve.ncurve) {
					if (iter.hasNext()) {
						curCurve = iter.next();
						curPoint = 0;
					} else {
						curPoint = curCurve.ncurve - 1;
						if (lastDistanceAt == distanceAt) {
							// out of points even though the preferred distance hasn't been reached
							break;
						}
					}
				}
				distanceAt += curCurve.curveDis[curPoint];
			}
			var thisCurve = curCurve.curve[curPoint];

			// interpolate the point between the two closest distances
			if (distanceAt - lastDistanceAt > 1) {
				var t = (prefDistance - lastDistanceAt) / (distanceAt - lastDistanceAt);
				curve[i] = new h3d.Vector(lastCurve.x.lerp(thisCurve.x, t), lastCurve.y.lerp(thisCurve.y, t));
			} else
				curve[i] = thisCurve;
		});

		//if (hitObject.repeat > 1) {
			var c1 = curve[0];
			var cnt = 1;

			if (cnt > ncurve) {
				return;
			}

			var c2 = curve[cnt++];
			while (cnt <= ncurve && c2.tmp().sub(c1).len() < 1)
				c2 = curve[cnt++];
			this.startAngle = Math.atan2(c2.y - c1.y, c2.x - c1.x) * 180 / Math.PI;

			c1 = curve[ncurve];
			cnt = ncurve - 1;
			c2 = curve[cnt--];
			while (cnt >= 0 && c2.tmp().sub(c1).len() < 1)
				c2 = curve[cnt--];
			this.endAngle = Math.atan2(c2.y - c1.y, c2.x - c1.x) * 180 / Math.PI;
        //}
    }
}