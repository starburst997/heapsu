package objects.curves;

import data.*;
import scenes.*;
import utils.*;
import utils.Colors;
import skins.Skin;

using FS;
using FSHeaps;

class Curve extends h2d.Sprite {
    
    public static inline var CURVE_POINTS_SEPERATION = 5.0;

    public static var borderColor:Int;

    public var hitObject:HitObject;

    public var posX:Float;
    public var posY:Float;

    public var curve:Array<h3d.Vector> = [];
    public var sliderX:Array<Float> = [];
    public var sliderY:Array<Float> = [];

    var hitCircles:Array<h2d.Bitmap> = [];
    var hitCirclesOverlay:Array<h2d.Bitmap> = [];

    public static function init(width:Int, height:Int, circleDiameter:Float, borderColor:Int) {
        Curve.borderColor = borderColor;

        //urveRenderState.init(width, height, circleDiameter);
    }

    public function new(hitObject:HitObject, scaled:Bool) {
        super();

        this.hitObject = hitObject;

        if (scaled) {
			this.x = hitObject.getScaledX();
			this.y = hitObject.getScaledY();
			this.sliderX = hitObject.getScaledSliderX();
			this.sliderY = hitObject.getScaledSliderY();
		} else {
			this.x = hitObject.x;
			this.y = hitObject.y;
			this.sliderX = hitObject.sliderX;
			this.sliderY = hitObject.sliderY;
		}
    }

    public function pointAt(t:Float):h3d.Vector {
        return new h3d.Vector();
    }

    public function drawCurve(color:Int, t:Float) {
        t = t.clamp(0, 1.0);

        // peppysliders
		if (Options.skin.sliderStyle == PeppySlider || true) {
			var drawUpTo = (curve.length * t).int();
			var hitCircle = hxd.Res.images.hitcircle;
            var hitCircleOverlay = hxd.Res.images.hitcircleoverlay;
            drawUpTo.iter(i -> {
                hitCirclesOverlay
                .getOr(i, () -> hitCircleOverlay.bitmap(this).changeScale(0.40).center())
                .setPosition(curve[i].x, curve[i].y)
                .setColor(WhiteFade);
            });
			
            /*for (int i = 0; i < drawUpTo; i++)
				hitCircleOverlay.drawCentered(curve[i].x, curve[i].y, Colors.WHITE_FADE);
			for (int i = 0; i < drawUpTo; i++)
				hitCircle.drawCentered(curve[i].x, curve[i].y, color);*/
		}

		// mmsliders
		else {
			//if (renderState == null)
			//	renderState = new CurveRenderState(hitObject, curve);
			//renderState.draw(color, borderColor, t);
		}
    }

    public inline function getX(i:Int) return i == 0 ? posX : sliderX[i - 1];
    public inline function getY(i:Int) return i == 0 ? posY : sliderY[i - 1];
}