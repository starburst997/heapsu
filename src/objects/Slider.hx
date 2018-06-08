package objects;

import data.*;
import scenes.*;
import objects.curves.*;

class Slider extends GameObject {
    
    public static var sliderMultiplier:Float = 1.0;

    var color:Int;
    var comboEnd:Bool;

    var curve:Curve;

    var sliderTime:Float;
    var sliderTimeTotal:Float;
    
    public function new(hitObject:HitObject, game:Game, color:Int, comboEnd:Bool) {
        super(hitObject, game);

        this.color = color;
        this.comboEnd = comboEnd;

        sliderTime = hitObject.getSliderTime(sliderMultiplier, game.beatLength);
        sliderTimeTotal = sliderTime * hitObject.repeat;
    }

    public override function draw(trackPosition:Float) {
        if (curve == null) curve = hitObject.getSliderCurve(true);

        if (curve.parent == null) sprite.addChild(curve);
        curve.drawCurve(color, trackPosition);
    }

    public override function update(delta:Float, mouseX:Float, mouseY:Float, keyPressed:Bool, trackPosition:Float):Bool {
        draw(trackPosition);
        updatePosition();

        if (trackPosition > hitObject.time + sliderTimeTotal) {
			// TODO: !!!
			return true;
		}

        return false;
    }

    public override function updatePosition() {
        sprite.setPos(0, 0);
    }
}