package objects.curves;

import data.*;
import scenes.*;

using FS;
using FSHeaps;

class CurveType {
    
    public var curve:Array<h3d.Vector> = [];
    public var curveDis:Array<Float> = [];
    public var ncurve:Int;
    public var totalDistance:Float;

    public function pointAt(t:Float):h3d.Vector {
        return new h3d.Vector();
    }

    public function init(approxlength:Float) {
        // subdivide the curve
        ncurve = Std.int(approxlength / 4) + 2;
        ncurve.iter(i -> curve[i] = pointAt(i / (ncurve - 1)));

        // find the distance of each point from the previous point
        totalDistance = 0;
        ncurve.iter(i -> {
            curveDis[i] = (i == 0) ? 0 : curve[i].tmp().sub(curve[i - 1]).len();
            totalDistance += curveDis[i];
        });
    }
}