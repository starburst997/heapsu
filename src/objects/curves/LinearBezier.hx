package objects.curves;

import data.*;
import objects.*;
import scenes.*;

class LinearBezier extends EqualDistanceMultiCurve {
    
    public function new(hitObject:HitObject, line:Bool, scaled:Bool = true) {
        super(hitObject, scaled);

        var beziers:Array<CurveType> = [];

        // Beziers: splits points into different Beziers if has the same points (red points)
        // a b c - c d - d e f g
        // Lines: generate a new curve for each sequential pair
        // ab  bc  cd  de  ef  fg
        var controlPoints = hitObject.sliderX.length + 1;
        var points:Array<h3d.Vector> = [];  // temporary list of points to separate different Bezier curves
        var lastPoi:h3d.Vector = null;
        controlPoints.iter(i -> {
            var tpoi = new h3d.Vector(getX(i), getY(i));
            if (line) {
                if (lastPoi != null) {
                    points.push(tpoi);
                    beziers.push(new Bezier2(points));
                    points = [];
                }
            } else if (lastPoi != null && tpoi.equals(lastPoi)) {
                if (points.length >= 2)
                    beziers.push(new Bezier2(points));
                points = [];
            }
            points.push(tpoi);
            lastPoi = tpoi;
        });

        if (line || points.length < 2) {
            // trying to continue Bezier with less than 2 points
            // probably ending on a red point, just ignore it
        } else {
            beziers.push(new Bezier2(points));
        }

        init(beziers);
    }
}