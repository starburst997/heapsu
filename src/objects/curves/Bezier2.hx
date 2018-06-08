package objects.curves;

using FS;
using FSHeaps;

class Bezier2 extends CurveType {
	
    public var points:Array<h3d.Vector>;

	public function new(points:Array<h3d.Vector>) {
        this.points = points;

        // TODO: Probably unnecessary???
        var approxlength = points.length.iterAdd(i -> points[i].tmp().sub(points[i + 1]).len());
		init(approxlength);
	}

	public override function pointAt(t:Float):h3d.Vector {
		var c = new h3d.Vector();
		var n = points.length - 1;
        points.iteri((i, pt) -> {
			var b = bernstein(i, n, t);
			c.x += pt.x * b;
			c.y += pt.y * b;
        });
		return c;
	}

	static inline function binomialCoefficient(n:Int, k:Int) {
		if (k < 0 || k > n)
			return 0;
		if (k == 0 || k == n)
			return 1;
		k = Math.min(k, n - k).int(); // take advantage of symmetry
		var c:Integer = 1;
		k.iter(i -> c = c * (n - i) / (i + 1));
		return c;
	}

	static inline function bernstein(i:Int, n:Int, t:Float) {
		return binomialCoefficient(n, i) * Math.pow(t, i) * Math.pow(1 - t, n - i);
	}
}