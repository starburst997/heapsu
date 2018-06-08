package objects.curves;

import data.*;
import scenes.*;

using FS;
using FSHeaps;

class CentripetalCatmullRom extends CurveType {
    private var time:Array<Float> = [];
    private var points:Array<h3d.Vector> = [];

    public function new(points:Array<h3d.Vector>) {
        Assert.that(points.length == 4);
        
        this.points = points;
        time[0] = 0;
        var approxLength = 0.0;
        for (i in 1...4) {
            var len = 0.0;
            if (i > 0)
                len = points[i].tmp().sub(points[i - 1]).len();
            if (len <= 0)
                len += 0.0001;
            approxLength += len;
            //time[i] = Math.sqrt(len) + time[i-1]; // ^(0.5)
            time[i] = i;
        }

        init(approxLength / 2);
    }

    public override function pointAt(t:Float) {
        t = t * (time[2] - time[1]) + time[1];

        var A1 = points[0].cpy().scale((time[1] - t) / (time[1] - time[0]))
              .add(points[1].tmp().scale((t - time[0]) / (time[1] - time[0])));
        var A2 = points[1].cpy().scale((time[2] - t) / (time[2] - time[1]))
              .add(points[2].tmp().scale((t - time[1]) / (time[2] - time[1])));
        var A3 = points[2].cpy().scale((time[3] - t) / (time[3] - time[2]))
              .add(points[3].tmp().scale((t - time[2]) / (time[3] - time[2])));

        var B1 = A1.cpy().scale((time[2] - t) / (time[2] - time[0]))
              .add(A2.tmp().scale((t - time[0]) / (time[2] - time[0])));
        var B2 = A2.cpy().scale((time[3] - t) / (time[3] - time[1]))
              .add(A3.tmp().scale((t - time[1]) / (time[3] - time[1])));

        var C = B1.cpy().scale((time[2] - t) / (time[2] - time[1]))
             .add(B2.tmp().scale((t - time[1]) / (time[2] - time[1])));

        return C;
    }
}